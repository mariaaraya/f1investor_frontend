import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../datos/servicios/api/api_servicio.dart';
import '../../../../dominio/entidades/entidades.dart';

class InicioVista extends StatefulWidget {
  const InicioVista({
    super.key,
    required this.resultadoAutenticacion,
    this.onCarreraSimulada,
  });

  final ResultadoAutenticacion resultadoAutenticacion;
  final VoidCallback? onCarreraSimulada;

  @override
  State<InicioVista> createState() => _InicioVistaState();
}

class _InicioVistaState extends State<InicioVista> {
  final ApiServicio _apiServicio = ApiServicio();

  bool _simulando = false;
  bool _cargandoUltimaCarrera = false;

  Map<String, dynamic>? _ultimaCarrera;
  List<Map<String, dynamic>> _ultimosResultados = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    _cargarUltimaCarrera();
  }

  String _formatearMonto(double monto) {
    return '\$${monto.toStringAsFixed(2)}';
  }

  List<Map<String, dynamic>> _normalizarResultados(dynamic raw) {
    final List<dynamic> resultadosRaw = raw as List<dynamic>? ?? <dynamic>[];

    final List<Map<String, dynamic>> resultados = resultadosRaw
        .whereType<Map<dynamic, dynamic>>()
        .map((Map<dynamic, dynamic> item) => Map<String, dynamic>.from(item))
        .toList();

    resultados.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
      final int posicionA = int.tryParse(a['posicion'].toString()) ?? 999;
      final int posicionB = int.tryParse(b['posicion'].toString()) ?? 999;
      return posicionA.compareTo(posicionB);
    });

    return resultados;
  }

  Future<void> _cargarUltimaCarrera() async {
    debugPrint('==================== INICIO DEBUG ====================');
    debugPrint('Intentando cargar ultima carrera completada...');
    debugPrint('Token presente: ${widget.resultadoAutenticacion.token.isNotEmpty}');
    debugPrint('Endpoint: /api/carreras/ultima-completada');

    if (_cargandoUltimaCarrera) {
      debugPrint('Ya se estaba cargando ultima carrera, se cancela');
      debugPrint('======================================================');
      return;
    }

    setState(() {
      _cargandoUltimaCarrera = true;
    });

    try {
      final Map<String, dynamic> respuesta = await _apiServicio.get(
        '/api/carreras/ultima-completada',
        token: widget.resultadoAutenticacion.token,
      );

      debugPrint('Respuesta ultima carrera: $respuesta');

      final Map<String, dynamic>? carrera = respuesta['carrera'] == null
          ? null
          : Map<String, dynamic>.from(respuesta['carrera']);

      final List<Map<String, dynamic>> resultados = _normalizarResultados(
        respuesta['resultados'],
      );

      debugPrint('Carrera cargada: $carrera');
      debugPrint('Cantidad resultados cargados: ${resultados.length}');

      if (!mounted) {
        debugPrint('InicioVista no esta montado despues de cargar ultima carrera');
        debugPrint('======================================================');
        return;
      }

      setState(() {
        _ultimaCarrera = carrera;
        _ultimosResultados = resultados;
      });

      debugPrint('Estado actualizado con ultima carrera');
    } catch (error) {
      debugPrint('ERROR CARGANDO ULTIMA CARRERA: $error');

      if (!mounted) {
        debugPrint('InicioVista no esta montado despues del error');
        debugPrint('======================================================');
        return;
      }

      setState(() {
        _ultimaCarrera = null;
        _ultimosResultados = <Map<String, dynamic>>[];
      });
    } finally {
      if (mounted) {
        setState(() {
          _cargandoUltimaCarrera = false;
        });
      }

      debugPrint('FIN cargar ultima carrera');
      debugPrint('======================================================');
    }
  }

  Future<void> _simularSiguienteCarrera() async {
    if (_simulando) {
      return;
    }

    setState(() {
      _simulando = true;
    });

    try {
      final Map<String, dynamic> respuesta = await _apiServicio.post(
        '/api/carreras/simular-siguiente',
        token: widget.resultadoAutenticacion.token,
        body: <String, dynamic>{
          'recalcular_mercado': true,
          'limpiar_previos': true,
        },
      );

      if (!mounted) {
        return;
      }

      widget.onCarreraSimulada?.call();

      final Map<String, dynamic> carreraSimulada =
          Map<String, dynamic>.from(respuesta['carrera_simulada'] ?? {});

      final List<Map<String, dynamic>> resultados = _normalizarResultados(
        respuesta['resultados'],
      );

      setState(() {
        _ultimaCarrera = carreraSimulada;
        _ultimosResultados = resultados;
      });

      await _mostrarTablaResultados(respuesta);

      await _cargarUltimaCarrera();
    } catch (error) {
      if (!mounted) {
        return;
      }

      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1C1C1C),
            title: const Text(
              'No se pudo simular',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              error.toString().replaceFirst('Exception: ', ''),
              style: const TextStyle(color: Colors.white70),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Aceptar',
                  style: TextStyle(color: Color(0xFFE60000)),
                ),
              ),
            ],
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _simulando = false;
        });
      }
    }
  }

  Future<void> _mostrarTablaResultados(
    Map<String, dynamic> respuesta,
  ) async {
    final Map<String, dynamic> carreraSimulada =
        Map<String, dynamic>.from(respuesta['carrera_simulada'] ?? {});

    final Map<String, dynamic>? siguienteCarrera =
        respuesta['siguiente_carrera'] == null
            ? null
            : Map<String, dynamic>.from(respuesta['siguiente_carrera']);

    final List<Map<String, dynamic>> resultados = _normalizarResultados(
      respuesta['resultados'],
    );

    final String nombreCarrera =
        carreraSimulada['nombre_gp']?.toString() ?? 'Carrera simulada';

    final String siguiente = siguienteCarrera == null
        ? 'No hay siguiente carrera pendiente.'
        : 'Siguiente: ${siguienteCarrera['nombre_gp'] ?? 'Carrera pendiente'}';

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF111111),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 760,
              maxHeight: 650,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.emoji_events_outlined,
                        color: Color(0xFFE60000),
                        size: 26,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          nombreCarrera,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    siguiente,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _CabeceraTablaResultados(mostrarEstado: true),
                  const SizedBox(height: 8),
                  Expanded(
                    child: resultados.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay resultados para mostrar.',
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : ListView.separated(
                            itemCount: resultados.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 6),
                            itemBuilder: (BuildContext context, int index) {
                              return _FilaResultadoCarrera(
                                resultado: resultados[index],
                                mostrarEstado: true,
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE60000),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Aceptar',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Usuario usuario = widget.resultadoAutenticacion.usuario;

    final double gananciaPerdida =
        usuario.patrimonioTotal - usuario.capitalInicial;

    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _cargarUltimaCarrera,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Hola, ${usuario.nombre}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Temporada actual',
                  style: TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 24),
                _TarjetaResumen(
                  capitalDisponible: _formatearMonto(usuario.capital),
                  valorCartera: _formatearMonto(usuario.valorPortfolio),
                  gananciaPerdida: _formatearMonto(gananciaPerdida),
                  gananciaPositiva: gananciaPerdida >= 0,
                ),
                const SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: _simulando ? null : _simularSiguienteCarrera,
                    icon: _simulando
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.play_arrow),
                    label: Text(
                      _simulando
                          ? 'Simulando carrera...'
                          : 'Simular siguiente carrera',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE60000),
                      foregroundColor: Colors.white,
                      disabledForegroundColor: Colors.white70,
                      disabledBackgroundColor: const Color(0xFF7A0000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                _TablaUltimaCarrera(
                  cargando: _cargandoUltimaCarrera,
                  carrera: _ultimaCarrera,
                  resultados: _ultimosResultados,
                  onActualizar: _cargarUltimaCarrera,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TablaUltimaCarrera extends StatelessWidget {
  const _TablaUltimaCarrera({
    required this.cargando,
    required this.carrera,
    required this.resultados,
    required this.onActualizar,
  });

  final bool cargando;
  final Map<String, dynamic>? carrera;
  final List<Map<String, dynamic>> resultados;
  final VoidCallback onActualizar;

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFFE60000)),
        ),
      );
    }

    if (carrera == null || resultados.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Última carrera simulada',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aún no hay resultados de carreras simuladas.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onActualizar,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Actualizar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white24),
              ),
            ),
          ],
        ),
      );
    }

    final String nombreCarrera =
        carrera!['nombre_gp']?.toString() ?? 'Última carrera';

    final String fecha = carrera!['fecha']?.toString() ?? '';
    final String round = carrera!['round_number']?.toString() ?? '';

    final List<Map<String, dynamic>> topResultados =
        resultados.length > 10 ? resultados.take(10).toList() : resultados;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(
                Icons.emoji_events_outlined,
                color: Color(0xFFE60000),
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Última carrera: $nombreCarrera',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: onActualizar,
                icon: const Icon(Icons.refresh, color: Colors.white70),
                tooltip: 'Actualizar resultados',
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Round ${round.isEmpty ? '-' : round}${fecha.isEmpty ? '' : ' · $fecha'}',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          const _CabeceraTablaResultados(mostrarEstado: false),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: topResultados.length,
            separatorBuilder: (_, _) => const SizedBox(height: 6),
            itemBuilder: (BuildContext context, int index) {
              return _FilaResultadoCarrera(
                resultado: topResultados[index],
                mostrarEstado: false,
              );
            },
          ),
          if (resultados.length > 10) ...<Widget>[
            const SizedBox(height: 10),
            Text(
              'Mostrando top 10 de ${resultados.length} posiciones.',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CabeceraTablaResultados extends StatelessWidget {
  const _CabeceraTablaResultados({
    required this.mostrarEstado,
  });

  final bool mostrarEstado;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 42,
            child: Text(
              'Pos',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Expanded(
            flex: 3,
            child: Text(
              'Piloto',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            flex: 2,
            child: Text(
              'Equipo',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            width: 48,
            child: Text(
              'Pts',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (mostrarEstado)
            const SizedBox(
              width: 82,
              child: Text(
                'Estado',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilaResultadoCarrera extends StatelessWidget {
  const _FilaResultadoCarrera({
    required this.resultado,
    required this.mostrarEstado,
  });

  final Map<String, dynamic> resultado;
  final bool mostrarEstado;

  Color _colorEstado(String estado) {
    if (estado == 'abandono' || estado == 'dsq') {
      return Colors.redAccent;
    }

    return Colors.greenAccent;
  }

  Color _colorPosicion(int posicion) {
    if (posicion == 1) {
      return Colors.amberAccent;
    }

    if (posicion <= 3) {
      return Colors.white;
    }

    if (posicion <= 10) {
      return Colors.greenAccent;
    }

    return Colors.white70;
  }

  @override
  Widget build(BuildContext context) {
    final int posicion = int.tryParse(
          resultado['posicion']?.toString() ?? '',
        ) ??
        0;

    final String piloto = resultado['piloto']?.toString() ?? '-';
    final String equipo = resultado['equipo']?.toString() ?? '-';
    final String estado = resultado['estado_final']?.toString() ?? '-';

    final double puntos = double.tryParse(
          resultado['puntos']?.toString() ?? '0',
        ) ??
        0.0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: posicion <= 3
            ? const Color(0xFF241D10)
            : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              posicion <= 3 ? Colors.amber.withOpacity(0.35) : Colors.white10,
        ),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 42,
            child: Text(
              posicion > 0 ? 'P$posicion' : '-',
              style: TextStyle(
                color: _colorPosicion(posicion),
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              piloto,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              equipo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(
            width: 48,
            child: Text(
              puntos.toStringAsFixed(puntos % 1 == 0 ? 0 : 1),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
          if (mostrarEstado)
            SizedBox(
              width: 82,
              child: Text(
                estado,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _colorEstado(estado),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TarjetaResumen extends StatelessWidget {
  const _TarjetaResumen({
    required this.capitalDisponible,
    required this.valorCartera,
    required this.gananciaPerdida,
    required this.gananciaPositiva,
  });

  final String capitalDisponible;
  final String valorCartera;
  final String gananciaPerdida;
  final bool gananciaPositiva;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Capital disponible',
            style: TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            capitalDisponible,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: <Widget>[
              Expanded(
                child: _DatoResumen(
                  titulo: 'Valor cartera',
                  valor: valorCartera,
                  colorValor: Colors.white,
                ),
              ),
              Expanded(
                child: _DatoResumen(
                  titulo: 'Ganancia/Pérdida',
                  valor: gananciaPerdida,
                  colorValor: gananciaPositiva
                      ? Colors.greenAccent
                      : const Color(0xFFE60000),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DatoResumen extends StatelessWidget {
  const _DatoResumen({
    required this.titulo,
    required this.valor,
    required this.colorValor,
  });

  final String titulo;
  final String valor;
  final Color colorValor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          titulo,
          style: const TextStyle(
            color: Color(0xFFBDBDBD),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          valor,
          style: TextStyle(
            color: colorValor,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}