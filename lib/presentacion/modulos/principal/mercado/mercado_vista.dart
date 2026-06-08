import 'package:f1investor_frontend/presentacion/modulos/principal/mercado/argumentos_activo_mercado.dart';
import 'package:f1investor_frontend/presentacion/modulos/principal/mercado/compra/compra_activo_mercado_vista.dart';
import 'package:f1investor_frontend/presentacion/modulos/principal/mercado/resultado_compra_mercado.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../dominio/casos_uso/mercado/consultar_mercado_caso_uso.dart';
import '../../../../dominio/entidades/entidades.dart';
import '../../../../infraestructura/dependencias/inyeccion_dependencias.dart';
import '../../../../infraestructura/extenciones/contexto_extensiones.dart';
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

          return ColoredBox(
            color: context.colorFondo,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Mercado',
                      style: TextStyle(
                        color: context.colorTextoPrincipal,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Activos disponibles para inversión',
                      style: TextStyle(
                        color: context.colorTextoSecundario,
                        fontSize: 12,
                      ),
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
      return Center(
        child: CircularProgressIndicator(
          color: context.colorPrimarioApp,
        ),
      );
    }

    if (mensajeError != null && activos.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.redAccent,
              size: 34,
            ),
            const SizedBox(height: 10),
            Text(
              mensajeError!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colorTextoSecundario,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onReintentar,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorPrimarioApp,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (activos.isEmpty) {
      return Center(
        child: Text(
          'No hay activos disponibles.',
          style: TextStyle(
            color: context.colorTextoSecundario,
            fontSize: 13,
          ),
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
        color: context.colorTarjeta,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: context.colorBorde),
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
          color: seleccionado ? context.colorPrimarioApp : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icono,
                size: 15,
                color: seleccionado
                    ? Colors.white
                    : context.colorTextoSecundario,
              ),
              const SizedBox(width: 6),
              Text(
                texto,
                style: TextStyle(
                  color: seleccionado
                      ? Colors.white
                      : context.colorTextoSecundario,
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

  Future<void> _notificarCompraYActualizarMercado({
    required BuildContext context,
    required ResultadoCompraMercado resultado,
  }) async {
    onCompraRealizada?.call(resultado);

    if (context.mounted) {
      context.read<MercadoCubit>().cargarMercado(
            token: resultadoAutenticacion.token,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool variacionPositiva = activo.porcentajeVariacion > 0;
    final bool mostrarVariacion = activo.porcentajeVariacion != 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colorTarjeta,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colorBorde),
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
                  style: TextStyle(
                    color: context.colorTextoPrincipal,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _obtenerDetalleActivo(activo),
                  style: TextStyle(
                    color: context.colorTextoSecundario,
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
                            style: TextStyle(
                              color: context.colorTextoPrincipal,
                              fontSize: 20,
                            ),
                          ),
                          if (mostrarVariacion) ...<Widget>[
                            const SizedBox(height: 2),
                            Row(
                              children: <Widget>[
                                Icon(
                                  variacionPositiva
                                      ? Icons.trending_up
                                      : Icons.trending_down,
                                  size: 14,
                                  color: variacionPositiva
                                      ? Colors.green
                                      : Colors.redAccent,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${variacionPositiva ? '+' : ''}${activo.porcentajeVariacion.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    color: variacionPositiva
                                        ? Colors.green
                                        : Colors.redAccent,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    _BotonMercado(
                      texto: 'Ver',
                      icono: Icons.visibility_outlined,
                      color: context.colorTarjetaSecundaria,
                      colorTexto: context.colorTextoPrincipal,
                      onTap: () async {
                        final ResultadoCompraMercado? resultado =
                            await context.pushNamed<ResultadoCompraMercado>(
                          DetalleActivoMercadoVista.nombre,
                          extra: ArgumentosActivoMercado(
                            activo: activo,
                            resultadoAutenticacion: resultadoAutenticacion,
                          ),
                        );

                        if (resultado != null && context.mounted) {
                          await _notificarCompraYActualizarMercado(
                            context: context,
                            resultado: resultado,
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    _BotonMercado(
                      texto: 'Comprar',
                      icono: Icons.shopping_cart_outlined,
                      color: context.colorPrimarioApp,
                      colorTexto: Colors.white,
                      onTap: () async {
                        final ResultadoCompraMercado? resultado =
                            await context.pushNamed<ResultadoCompraMercado>(
                          CompraActivoMercadoVista.nombre,
                          extra: ArgumentosActivoMercado(
                            activo: activo,
                            resultadoAutenticacion: resultadoAutenticacion,
                          ),
                        );

                        if (resultado != null && context.mounted) {
                          await _notificarCompraYActualizarMercado(
                            context: context,
                            resultado: resultado,
                          );
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

      return '$equipo$codigo';
    }

    final String nacionalidad = activo.nacionalidad?.isNotEmpty == true
        ? activo.nacionalidad!
        : 'Escudería';

    return nacionalidad;
  }
}

class _ImagenActivoMercado extends StatelessWidget {
  const _ImagenActivoMercado({
    required this.activo,
    required this.esEscuderia,
  });

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
        child: const Icon(
          Icons.flag,
          color: Colors.white,
          size: 22,
        ),
      );
    }

    return CircleAvatar(
      radius: 22,
      backgroundColor: context.esTemaOscuro
          ? const Color(0xFF451414)
          : const Color(0xFFFFE5E5),
      child: Text(
        _obtenerIniciales(activo),
        style: TextStyle(
          color: context.esTemaOscuro ? Colors.white : context.colorPrimarioApp,
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
    required this.colorTexto,
    required this.onTap,
  });

  final String texto;
  final IconData icono;
  final Color color;
  final Color colorTexto;
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
          foregroundColor: colorTexto,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}