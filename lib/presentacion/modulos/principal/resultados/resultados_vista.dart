import 'package:flutter/material.dart';

import '../../../../datos/servicios/api/api_servicio.dart';
import '../../../../dominio/entidades/entidades.dart';

class ResultadosVista extends StatefulWidget {
  const ResultadosVista({
    super.key,
    required this.resultadoAutenticacion,
  });

  final ResultadoAutenticacion resultadoAutenticacion;

  @override
  State<ResultadosVista> createState() => _ResultadosVistaState();
}

class _ResultadosVistaState extends State<ResultadosVista> {
  final ApiServicio _apiServicio = ApiServicio();

  bool _cargando = false;
  String? _mensajeError;

  List<Map<String, dynamic>> _carreras = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _resultados = <Map<String, dynamic>>[];

  Map<String, dynamic>? _ultimaCarrera;
  List<Map<String, dynamic>> _resultadosUltimaCarrera = <Map<String, dynamic>>[];

  List<_RankingItem> _rankingPilotos = <_RankingItem>[];
  List<_RankingItem> _rankingEquipos = <_RankingItem>[];

  int _totalAbandonos = 0;
  int _totalFinalizados = 0;
  double _totalPuntos = 0;

  @override
  void initState() {
    super.initState();
    _cargarResultados();
  }

  Future<void> _cargarResultados() async {
    if (_cargando) {
      return;
    }

    setState(() {
      _cargando = true;
      _mensajeError = null;
    });

    try {
      final List<dynamic> carrerasRaw = await _apiServicio.getList(
        '/api/carreras/?estado=completada&orden=round',
        token: widget.resultadoAutenticacion.token,
      );

      final List<Map<String, dynamic>> carreras = carrerasRaw
          .whereType<Map<dynamic, dynamic>>()
          .map((Map<dynamic, dynamic> item) => Map<String, dynamic>.from(item))
          .toList();

      carreras.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
        final int roundA = int.tryParse(a['round_number']?.toString() ?? '') ?? 0;
        final int roundB = int.tryParse(b['round_number']?.toString() ?? '') ?? 0;
        return roundA.compareTo(roundB);
      });

      final List<Map<String, dynamic>> todosLosResultados =
          <Map<String, dynamic>>[];

      Map<String, dynamic>? ultimaCarrera;
      List<Map<String, dynamic>> resultadosUltima = <Map<String, dynamic>>[];

      for (final Map<String, dynamic> carreraResumen in carreras) {
        final int? carreraId = int.tryParse(carreraResumen['id'].toString());

        if (carreraId == null) {
          continue;
        }

        final Map<String, dynamic> carreraDetalle = await _apiServicio.get(
          '/api/carreras/$carreraId',
          token: widget.resultadoAutenticacion.token,
        );

        final List<Map<String, dynamic>> resultadosCarrera =
            _normalizarResultados(carreraDetalle['resultados']);

        for (final Map<String, dynamic> resultado in resultadosCarrera) {
          todosLosResultados.add(<String, dynamic>{
            ...resultado,
            'carrera_nombre': carreraDetalle['nombre_gp'],
            'carrera_round': carreraDetalle['round_number'],
          });
        }

        ultimaCarrera = carreraDetalle;
        resultadosUltima = resultadosCarrera;
      }

      final _MetricasResultados metricas = _calcularMetricas(
        todosLosResultados,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _carreras = carreras;
        _resultados = todosLosResultados;
        _ultimaCarrera = ultimaCarrera;
        _resultadosUltimaCarrera = resultadosUltima;
        _rankingPilotos = metricas.rankingPilotos;
        _rankingEquipos = metricas.rankingEquipos;
        _totalAbandonos = metricas.totalAbandonos;
        _totalFinalizados = metricas.totalFinalizados;
        _totalPuntos = metricas.totalPuntos;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _mensajeError = error.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _cargando = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> _normalizarResultados(dynamic raw) {
    final List<dynamic> resultadosRaw = raw as List<dynamic>? ?? <dynamic>[];

    final List<Map<String, dynamic>> resultados = resultadosRaw
        .whereType<Map<dynamic, dynamic>>()
        .map((Map<dynamic, dynamic> item) => Map<String, dynamic>.from(item))
        .toList();

    resultados.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
      final int posicionA = int.tryParse(a['posicion']?.toString() ?? '') ?? 999;
      final int posicionB = int.tryParse(b['posicion']?.toString() ?? '') ?? 999;
      return posicionA.compareTo(posicionB);
    });

    return resultados;
  }

  _MetricasResultados _calcularMetricas(
    List<Map<String, dynamic>> resultados,
  ) {
    final Map<String, _AcumuladoRanking> pilotos =
        <String, _AcumuladoRanking>{};

    final Map<String, _AcumuladoRanking> equipos =
        <String, _AcumuladoRanking>{};

    int abandonos = 0;
    int finalizados = 0;
    double puntosTotales = 0;

    for (final Map<String, dynamic> resultado in resultados) {
      final String piloto = resultado['piloto']?.toString() ?? 'Sin piloto';
      final String equipo = resultado['equipo']?.toString() ?? 'Sin equipo';
      final String estado = resultado['estado_final']?.toString() ?? '';
      final int posicion =
          int.tryParse(resultado['posicion']?.toString() ?? '') ?? 0;
      final double puntos =
          double.tryParse(resultado['puntos']?.toString() ?? '0') ?? 0.0;

      puntosTotales += puntos;

      if (estado == 'abandono' || estado == 'dsq') {
        abandonos++;
      } else {
        finalizados++;
      }

      pilotos.putIfAbsent(piloto, () => _AcumuladoRanking(nombre: piloto));
      equipos.putIfAbsent(equipo, () => _AcumuladoRanking(nombre: equipo));

      pilotos[piloto]!.puntos += puntos;
      pilotos[piloto]!.carreras++;
      pilotos[piloto]!.posiciones += posicion;
      pilotos[piloto]!.victorias += posicion == 1 ? 1 : 0;
      pilotos[piloto]!.podios += posicion <= 3 ? 1 : 0;
      pilotos[piloto]!.abandonos += estado == 'abandono' ? 1 : 0;

      equipos[equipo]!.puntos += puntos;
      equipos[equipo]!.carreras++;
      equipos[equipo]!.posiciones += posicion;
      equipos[equipo]!.victorias += posicion == 1 ? 1 : 0;
      equipos[equipo]!.podios += posicion <= 3 ? 1 : 0;
      equipos[equipo]!.abandonos += estado == 'abandono' ? 1 : 0;
    }

    final List<_RankingItem> rankingPilotos = pilotos.values
        .map((e) => e.toRankingItem())
        .toList()
      ..sort((a, b) => b.puntos.compareTo(a.puntos));

    final List<_RankingItem> rankingEquipos = equipos.values
        .map((e) => e.toRankingItem())
        .toList()
      ..sort((a, b) => b.puntos.compareTo(a.puntos));

    return _MetricasResultados(
      rankingPilotos: rankingPilotos,
      rankingEquipos: rankingEquipos,
      totalAbandonos: abandonos,
      totalFinalizados: finalizados,
      totalPuntos: puntosTotales,
    );
  }

  String _formatearNumero(double valor) {
    return valor.toStringAsFixed(valor % 1 == 0 ? 0 : 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _cargarResultados,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Resultados',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Métricas, rankings y desempeño de las carreras simuladas',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 22),

                if (_cargando && _resultados.isEmpty)
                  const _CargandoResultados()
                else if (_mensajeError != null && _resultados.isEmpty)
                  _ErrorResultados(
                    mensaje: _mensajeError!,
                    onReintentar: _cargarResultados,
                  )
                else if (_resultados.isEmpty)
                  _SinResultados(onActualizar: _cargarResultados)
                else ...<Widget>[
                  _ResumenGeneralResultados(
                    carrerasSimuladas: _carreras.length,
                    totalResultados: _resultados.length,
                    totalFinalizados: _totalFinalizados,
                    totalAbandonos: _totalAbandonos,
                    totalPuntos: _totalPuntos,
                  ),
                  const SizedBox(height: 18),

                  _SeccionUltimaCarrera(
                    carrera: _ultimaCarrera,
                    resultados: _resultadosUltimaCarrera,
                  ),
                  const SizedBox(height: 18),

                  _SeccionGraficos(
                    rankingPilotos: _rankingPilotos,
                    rankingEquipos: _rankingEquipos,
                  ),
                  const SizedBox(height: 18),

                  _RankingPanel(
                    titulo: 'Ranking de pilotos',
                    subtitulo: 'Ordenado por puntos acumulados',
                    items: _rankingPilotos,
                    mostrarPromedio: true,
                  ),
                  const SizedBox(height: 18),

                  _RankingPanel(
                    titulo: 'Ranking de equipos',
                    subtitulo: 'Puntos acumulados por escudería',
                    items: _rankingEquipos,
                    mostrarPromedio: false,
                  ),
                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _cargarResultados,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Actualizar resultados'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white24),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResumenGeneralResultados extends StatelessWidget {
  const _ResumenGeneralResultados({
    required this.carrerasSimuladas,
    required this.totalResultados,
    required this.totalFinalizados,
    required this.totalAbandonos,
    required this.totalPuntos,
  });

  final int carrerasSimuladas;
  final int totalResultados;
  final int totalFinalizados;
  final int totalAbandonos;
  final double totalPuntos;

  @override
  Widget build(BuildContext context) {
    final double porcentajeAbandono = totalResultados == 0
        ? 0
        : (totalAbandonos / totalResultados) * 100;

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: _MetricaCard(
                titulo: 'Carreras',
                valor: carrerasSimuladas.toString(),
                icono: Icons.sports_score_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricaCard(
                titulo: 'Resultados',
                valor: totalResultados.toString(),
                icono: Icons.format_list_numbered,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: _MetricaCard(
                titulo: 'Finalizados',
                valor: totalFinalizados.toString(),
                icono: Icons.check_circle_outline,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricaCard(
                titulo: 'Abandonos',
                valor: '${totalAbandonos.toString()} (${porcentajeAbandono.toStringAsFixed(1)}%)',
                icono: Icons.warning_amber_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _MetricaCard(
          titulo: 'Puntos entregados',
          valor: totalPuntos.toStringAsFixed(totalPuntos % 1 == 0 ? 0 : 1),
          icono: Icons.star_border,
        ),
      ],
    );
  }
}

class _MetricaCard extends StatelessWidget {
  const _MetricaCard({
    required this.titulo,
    required this.valor,
    required this.icono,
  });

  final String titulo;
  final String valor;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    return Container(
  constraints: const BoxConstraints(
    minHeight: 92,
  ),
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: const Color(0xFF151515),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.white12),
  ),
      child: Row(
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF2A0A0A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icono,
              color: const Color(0xFFE60000),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  valor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SeccionUltimaCarrera extends StatelessWidget {
  const _SeccionUltimaCarrera({
    required this.carrera,
    required this.resultados,
  });

  final Map<String, dynamic>? carrera;
  final List<Map<String, dynamic>> resultados;

  @override
  Widget build(BuildContext context) {
    final String nombreCarrera =
        carrera?['nombre_gp']?.toString() ?? 'Última carrera';

    final String round = carrera?['round_number']?.toString() ?? '-';
    final String fecha = carrera?['fecha']?.toString() ?? '';

    final List<Map<String, dynamic>> top10 =
        resultados.length > 10 ? resultados.take(10).toList() : resultados;

    final List<Map<String, dynamic>> abandonos = resultados
        .where((r) => r['estado_final']?.toString() == 'abandono')
        .toList();

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
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Round $round${fecha.isEmpty ? '' : ' · $fecha'}',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),

          if (resultados.isNotEmpty)
            _PodioResumen(resultados: resultados),

          const SizedBox(height: 14),
          const _CabeceraTablaResultados(mostrarEstado: true),
          const SizedBox(height: 8),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: top10.length,
            separatorBuilder: (_, _) => const SizedBox(height: 6),
            itemBuilder: (BuildContext context, int index) {
              return _FilaResultadoCarrera(
                resultado: top10[index],
                mostrarEstado: true,
              );
            },
          ),

          if (resultados.length > 10) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              'Mostrando top 10 de ${resultados.length} posiciones.',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ],

          if (abandonos.isNotEmpty) ...<Widget>[
            const SizedBox(height: 14),
            Text(
              'Abandonos: ${abandonos.map((e) => e['piloto']).join(', ')}',
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PodioResumen extends StatelessWidget {
  const _PodioResumen({
    required this.resultados,
  });

  final List<Map<String, dynamic>> resultados;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? primero =
        resultados.isNotEmpty ? resultados[0] : null;
    final Map<String, dynamic>? segundo =
        resultados.length > 1 ? resultados[1] : null;
    final Map<String, dynamic>? tercero =
        resultados.length > 2 ? resultados[2] : null;

    return Row(
      children: <Widget>[
        Expanded(
          child: _PodioCard(
            posicion: 'P1',
            piloto: primero?['piloto']?.toString() ?? '-',
            equipo: primero?['equipo']?.toString() ?? '-',
            destacado: true,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _PodioCard(
            posicion: 'P2',
            piloto: segundo?['piloto']?.toString() ?? '-',
            equipo: segundo?['equipo']?.toString() ?? '-',
            destacado: false,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _PodioCard(
            posicion: 'P3',
            piloto: tercero?['piloto']?.toString() ?? '-',
            equipo: tercero?['equipo']?.toString() ?? '-',
            destacado: false,
          ),
        ),
      ],
    );
  }
}

class _PodioCard extends StatelessWidget {
  const _PodioCard({
    required this.posicion,
    required this.piloto,
    required this.equipo,
    required this.destacado,
  });

  final String posicion;
  final String piloto;
  final String equipo;
  final bool destacado;

  @override
  Widget build(BuildContext context) {
    return Container(
  constraints: const BoxConstraints(
    minHeight: 92,
  ),
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: const Color(0xFF151515),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.white12),
  ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            posicion,
            style: TextStyle(
              color: destacado ? Colors.amberAccent : Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            piloto,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            equipo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _SeccionGraficos extends StatelessWidget {
  const _SeccionGraficos({
    required this.rankingPilotos,
    required this.rankingEquipos,
  });

  final List<_RankingItem> rankingPilotos;
  final List<_RankingItem> rankingEquipos;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _GraficoBarrasRanking(
          titulo: 'Puntos por piloto',
          subtitulo: 'Top 8 pilotos por puntos acumulados',
          items: rankingPilotos.take(8).toList(),
        ),
        const SizedBox(height: 18),
        _GraficoBarrasRanking(
          titulo: 'Puntos por equipo',
          subtitulo: 'Puntos acumulados por escudería',
          items: rankingEquipos.take(8).toList(),
        ),
      ],
    );
  }
}

class _GraficoBarrasRanking extends StatelessWidget {
  const _GraficoBarrasRanking({
    required this.titulo,
    required this.subtitulo,
    required this.items,
  });

  final String titulo;
  final String subtitulo;
  final List<_RankingItem> items;

  @override
  Widget build(BuildContext context) {
    final double maximo = items.isEmpty
        ? 1
        : items
            .map((e) => e.puntos)
            .reduce((double a, double b) => a > b ? a : b);

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
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitulo,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
          if (items.isEmpty)
            const Text(
              'No hay datos suficientes para graficar.',
              style: TextStyle(color: Colors.white70),
            )
          else
            Column(
              children: items.map((item) {
                final double porcentaje =
                    maximo == 0 ? 0 : (item.puntos / maximo).clamp(0.0, 1.0);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _BarraRanking(
                    nombre: item.nombre,
                    valor: item.puntos,
                    porcentaje: porcentaje,
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _BarraRanking extends StatelessWidget {
  const _BarraRanking({
    required this.nombre,
    required this.valor,
    required this.porcentaje,
  });

  final String nombre;
  final double valor;
  final double porcentaje;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                nombre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ),
            Text(
              valor.toStringAsFixed(valor % 1 == 0 ? 0 : 1),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            minHeight: 9,
            value: porcentaje,
            backgroundColor: const Color(0xFF2A2A2A),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFFE60000),
            ),
          ),
        ),
      ],
    );
  }
}

class _RankingPanel extends StatelessWidget {
  const _RankingPanel({
    required this.titulo,
    required this.subtitulo,
    required this.items,
    required this.mostrarPromedio,
  });

  final String titulo;
  final String subtitulo;
  final List<_RankingItem> items;
  final bool mostrarPromedio;

  @override
  Widget build(BuildContext context) {
    final List<_RankingItem> topItems =
        items.length > 10 ? items.take(10).toList() : items;

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
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitulo,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: topItems.length,
            separatorBuilder: (_, _) => const SizedBox(height: 6),
            itemBuilder: (BuildContext context, int index) {
              return _FilaRanking(
                posicion: index + 1,
                item: topItems[index],
                mostrarPromedio: mostrarPromedio,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FilaRanking extends StatelessWidget {
  const _FilaRanking({
    required this.posicion,
    required this.item,
    required this.mostrarPromedio,
  });

  final int posicion;
  final _RankingItem item;
  final bool mostrarPromedio;

  @override
  Widget build(BuildContext context) {
    final String detalle = mostrarPromedio
        ? 'Victorias: ${item.victorias} · Podios: ${item.podios} · Prom. pos: ${item.promedioPosicion.toStringAsFixed(1)}'
        : 'Victorias: ${item.victorias} · Podios: ${item.podios} · Carreras: ${item.carreras}';

    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: posicion <= 3
            ? const Color(0xFF241D10)
            : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: posicion <= 3 ? Colors.amber.withOpacity(0.35) : Colors.white10,
        ),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 34,
            child: Text(
              '#$posicion',
              style: TextStyle(
                color: posicion == 1 ? Colors.amberAccent : Colors.white70,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  detalle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.puntos.toStringAsFixed(item.puntos % 1 == 0 ? 0 : 1),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
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
          color: posicion <= 3 ? Colors.amber.withOpacity(0.35) : Colors.white10,
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

class _CargandoResultados extends StatelessWidget {
  const _CargandoResultados();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
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
}

class _ErrorResultados extends StatelessWidget {
  const _ErrorResultados({
    required this.mensaje,
    required this.onReintentar,
  });

  final String mensaje;
  final VoidCallback onReintentar;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
      ),
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.error_outline,
            color: Colors.redAccent,
            size: 32,
          ),
          const SizedBox(height: 10),
          Text(
            mensaje,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onReintentar,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE60000),
              foregroundColor: Colors.white,
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

class _SinResultados extends StatelessWidget {
  const _SinResultados({
    required this.onActualizar,
  });

  final VoidCallback onActualizar;

  @override
  Widget build(BuildContext context) {
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
            'Aún no hay resultados',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Simulá una carrera desde Inicio para generar métricas, rankings y gráficos.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onActualizar,
            icon: const Icon(Icons.refresh),
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
}

class _MetricasResultados {
  const _MetricasResultados({
    required this.rankingPilotos,
    required this.rankingEquipos,
    required this.totalAbandonos,
    required this.totalFinalizados,
    required this.totalPuntos,
  });

  final List<_RankingItem> rankingPilotos;
  final List<_RankingItem> rankingEquipos;
  final int totalAbandonos;
  final int totalFinalizados;
  final double totalPuntos;
}

class _AcumuladoRanking {
  _AcumuladoRanking({
    required this.nombre,
  });

  final String nombre;

  double puntos = 0;
  int carreras = 0;
  int victorias = 0;
  int podios = 0;
  int abandonos = 0;
  int posiciones = 0;

  _RankingItem toRankingItem() {
    return _RankingItem(
      nombre: nombre,
      puntos: puntos,
      carreras: carreras,
      victorias: victorias,
      podios: podios,
      abandonos: abandonos,
      promedioPosicion: carreras == 0 ? 0 : posiciones / carreras,
    );
  }
}

class _RankingItem {
  const _RankingItem({
    required this.nombre,
    required this.puntos,
    required this.carreras,
    required this.victorias,
    required this.podios,
    required this.abandonos,
    required this.promedioPosicion,
  });

  final String nombre;
  final double puntos;
  final int carreras;
  final int victorias;
  final int podios;
  final int abandonos;
  final double promedioPosicion;
}