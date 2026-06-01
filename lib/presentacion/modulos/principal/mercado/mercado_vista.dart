import 'package:f1investor_frontend/presentacion/modulos/principal/mercado/argumentos_activo_mercado.dart';
import 'package:f1investor_frontend/presentacion/modulos/principal/mercado/compra/compra_activo_mercado_vista.dart';
import 'package:f1investor_frontend/presentacion/modulos/principal/mercado/resultado_compra_mercado.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../dominio/casos_uso/mercado/consultar_mercado_caso_uso.dart';
import '../../../../dominio/entidades/entidades.dart';
import '../../../../infraestructura/dependencias/inyeccion_dependencias.dart';
import 'cubit/mercado_cubit.dart';
import 'detalle/detalle_activo_mercado_vista.dart';

class MercadoVista extends StatefulWidget {
  const MercadoVista({
    super.key,
    required this.resultadoAutenticacion,
    this.onCompraRealizada,
  });

  final ResultadoAutenticacion resultadoAutenticacion;
  final ValueChanged<ResultadoCompraMercado>? onCompraRealizada;

  @override
  State<MercadoVista> createState() => _MercadoVistaState();
}

class _MercadoVistaState extends State<MercadoVista> {
  bool mostrandoEscuderias = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MercadoCubit>(
      create: (_) =>
          MercadoCubit(consultarMercadoCasoUso: sl<ConsultarMercadoCasoUso>())
            ..cargarMercado(token: widget.resultadoAutenticacion.token),
      child: BlocBuilder<MercadoCubit, MercadoState>(
        builder: (BuildContext context, MercadoState state) {
          final List<ActivoMercado> activos = mostrandoEscuderias
              ? state.equipos
              : state.pilotos;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Mercado',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Activos disponibles para inversión',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 22),

                  _SelectorMercado(
                    mostrandoEscuderias: mostrandoEscuderias,
                    onCambiar: (bool escuderiasSeleccionadas) {
                      setState(() {
                        mostrandoEscuderias = escuderiasSeleccionadas;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: _ContenidoMercado(
                      cargando: state.cargando,
                      mensajeError: state.mensajeError,
                      activos: activos,
                      mostrandoEscuderias: mostrandoEscuderias,
                      resultadoAutenticacion: widget.resultadoAutenticacion,
                      onCompraRealizada: widget.onCompraRealizada,
                      onReintentar: () {
                        context.read<MercadoCubit>().cargarMercado(
                          token: widget.resultadoAutenticacion.token,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ContenidoMercado extends StatelessWidget {
  const _ContenidoMercado({
    required this.cargando,
    required this.mensajeError,
    required this.activos,
    required this.mostrandoEscuderias,
    required this.onReintentar,
    required this.resultadoAutenticacion,
    this.onCompraRealizada,
  });

  final bool cargando;
  final String? mensajeError;
  final List<ActivoMercado> activos;
  final bool mostrandoEscuderias;
  final VoidCallback onReintentar;
  final ResultadoAutenticacion resultadoAutenticacion;
  final ValueChanged<ResultadoCompraMercado>? onCompraRealizada;

  @override
  Widget build(BuildContext context) {
    if (cargando && activos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (mensajeError != null && activos.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 34),
            const SizedBox(height: 10),
            Text(
              mensajeError!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onReintentar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (activos.isEmpty) {
      return const Center(
        child: Text(
          'No hay activos disponibles.',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onReintentar(),
      child: ListView.separated(
        itemCount: activos.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (BuildContext context, int index) {
          return _CardActivoMercado(
            activo: activos[index],
            esEscuderia: mostrandoEscuderias,
            resultadoAutenticacion: resultadoAutenticacion,
            onCompraRealizada: onCompraRealizada,
          );
        },
      ),
    );
  }
}

class _SelectorMercado extends StatelessWidget {
  const _SelectorMercado({
    required this.mostrandoEscuderias,
    required this.onCambiar,
  });

  final bool mostrandoEscuderias;
  final ValueChanged<bool> onCambiar;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1B),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _BotonSelectorMercado(
              texto: 'Escuderías',
              icono: Icons.groups_outlined,
              seleccionado: mostrandoEscuderias,
              onTap: () => onCambiar(true),
            ),
          ),
          Expanded(
            child: _BotonSelectorMercado(
              texto: 'Pilotos',
              icono: Icons.sports_motorsports_outlined,
              seleccionado: !mostrandoEscuderias,
              onTap: () => onCambiar(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _BotonSelectorMercado extends StatelessWidget {
  const _BotonSelectorMercado({
    required this.texto,
    required this.icono,
    required this.seleccionado,
    required this.onTap,
  });

  final String texto;
  final IconData icono;
  final bool seleccionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: seleccionado ? Colors.red : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icono,
                size: 15,
                color: seleccionado ? Colors.white : Colors.white70,
              ),
              const SizedBox(width: 6),
              Text(
                texto,
                style: TextStyle(
                  color: seleccionado ? Colors.white : Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardActivoMercado extends StatelessWidget {
  const _CardActivoMercado({
    required this.activo,
    required this.esEscuderia,
    required this.resultadoAutenticacion,
    this.onCompraRealizada,
  });

  final ActivoMercado activo;
  final bool esEscuderia;
  final ResultadoAutenticacion resultadoAutenticacion;
  final ValueChanged<ResultadoCompraMercado>? onCompraRealizada;

  @override
  Widget build(BuildContext context) {
    final bool variacionPositiva = activo.porcentajeVariacion >= 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _ImagenActivoMercado(activo: activo, esEscuderia: esEscuderia),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  activo.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _obtenerDetalleActivo(activo),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '\$${activo.valorMercado.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: <Widget>[
                              Icon(
                                variacionPositiva
                                    ? Icons.trending_up
                                    : Icons.trending_down,
                                size: 14,
                                color: variacionPositiva
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${variacionPositiva ? '+' : ''}${activo.porcentajeVariacion.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: variacionPositiva
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _BotonMercado(
                      texto: 'Ver',
                      icono: Icons.visibility_outlined,
                      color: const Color(0xFF2A2A2A),
                      onTap: () {
                        context.pushNamed(
                          DetalleActivoMercadoVista.nombre,
                          extra: ArgumentosActivoMercado(
                            activo: activo,
                            resultadoAutenticacion: resultadoAutenticacion,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _BotonMercado(
                      texto: 'Comprar',
                      icono: Icons.shopping_cart_outlined,
                      color: Colors.red,
                      onTap: () async {
                        final ResultadoCompraMercado? resultado = await context
                            .pushNamed<ResultadoCompraMercado>(
                              CompraActivoMercadoVista.nombre,
                              extra: ArgumentosActivoMercado(
                                activo: activo,
                                resultadoAutenticacion: resultadoAutenticacion,
                              ),
                            );

                        if (resultado != null && context.mounted) {
                          onCompraRealizada?.call(resultado);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _obtenerDetalleActivo(ActivoMercado activo) {
    if (activo.tipo == TipoActivoMercado.piloto) {
      final String equipo = activo.equipo?.isNotEmpty == true
          ? activo.equipo!
          : 'Sin escudería';

      final String codigo = activo.codigo?.isNotEmpty == true
          ? ' • ${activo.codigo}'
          : '';

      return '$equipo$codigo\nMedia ${activo.media.toStringAsFixed(1)}';
    }

    final String nacionalidad = activo.nacionalidad?.isNotEmpty == true
        ? activo.nacionalidad!
        : 'Escudería';

    return '$nacionalidad\nMedia ${activo.media.toStringAsFixed(1)}';
  }
}

class _ImagenActivoMercado extends StatelessWidget {
  const _ImagenActivoMercado({required this.activo, required this.esEscuderia});

  final ActivoMercado activo;
  final bool esEscuderia;

  @override
  Widget build(BuildContext context) {
    if (esEscuderia) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _obtenerColorEscuderia(activo.nombre),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(Icons.flag, color: Colors.white, size: 22),
      );
    }

    return CircleAvatar(
      radius: 22,
      backgroundColor: const Color(0xFF451414),
      child: Text(
        _obtenerIniciales(activo),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  String _obtenerIniciales(ActivoMercado activo) {
    if (activo.codigo != null && activo.codigo!.isNotEmpty) {
      return activo.codigo!;
    }

    final List<String> partes = activo.nombre.trim().split(' ');

    if (partes.length >= 2) {
      return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
    }

    if (activo.nombre.isNotEmpty) {
      return activo.nombre[0].toUpperCase();
    }

    return '';
  }

  Color _obtenerColorEscuderia(String nombre) {
    final int valor = nombre.hashCode;

    final List<Color> colores = <Color>[
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.grey,
    ];

    return colores[valor.abs() % colores.length];
  }
}

class _BotonMercado extends StatelessWidget {
  const _BotonMercado({
    required this.texto,
    required this.icono,
    required this.color,
    required this.onTap,
  });

  final String texto;
  final IconData icono;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icono, size: 15),
        label: Text(texto),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }
}
