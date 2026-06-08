import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:f1investor_frontend/presentacion/modulos/principal/mercado/resultado_compra_mercado.dart';

import '../../../../../dominio/casos_uso/mercado/consultar_detalle_activo_mercado_caso_uso.dart';
import '../../../../../dominio/casos_uso/mercado/consultar_historial_activo_mercado_caso_uso.dart';
import '../../../../../dominio/entidades/entidades.dart';
import '../../../../../infraestructura/dependencias/inyeccion_dependencias.dart';
import '../../../../../infraestructura/extenciones/contexto_extensiones.dart';
import '../argumentos_activo_mercado.dart';
import '../compra/compra_activo_mercado_vista.dart';
import 'cubit/detalle_activo_mercado_cubit.dart';

class DetalleActivoMercadoVista extends StatelessWidget {
  const DetalleActivoMercadoVista({super.key, required this.argumentos});

  static const String nombre = 'detalleActivoMercado';
  static const String ruta = '/detalle-activo-mercado';

  final ArgumentosActivoMercado argumentos;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DetalleActivoMercadoCubit>(
      create: (_) =>
          DetalleActivoMercadoCubit(
            consultarDetalleActivoCasoUso:
                sl<ConsultarDetalleActivoMercadoCasoUso>(),
            consultarHistorialCasoUso:
                sl<ConsultarHistorialActivoMercadoCasoUso>(),
          )..cargarDetalle(
              activoInicial: argumentos.activo,
              token: argumentos.resultadoAutenticacion.token,
            ),
      child: Scaffold(
        backgroundColor: context.colorFondo,
        appBar: AppBar(
          backgroundColor: context.colorFondo,
          foregroundColor: context.colorTextoPrincipal,
          elevation: 0,
          title: Text(
            argumentos.activo.tipo == TipoActivoMercado.equipo
                ? 'Detalle de escudería'
                : 'Detalle de piloto',
          ),
        ),
        body: BlocBuilder<DetalleActivoMercadoCubit, DetalleActivoMercadoState>(
          builder: (BuildContext context, DetalleActivoMercadoState state) {
            final ActivoMercado activo = state.activo ?? argumentos.activo;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    if (state.cargando)
                      LinearProgressIndicator(
                        color: context.colorPrimarioApp,
                        backgroundColor: context.colorTarjetaSecundaria,
                      ),

                    if (state.mensajeError != null) ...<Widget>[
                      const SizedBox(height: 12),
                      Text(
                        state.mensajeError!,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ],

                    const SizedBox(height: 12),

                    _TarjetaDetalleActivo(activo: activo),

                    const SizedBox(height: 22),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Historial reciente',
                        style: TextStyle(
                          color: context.colorTextoPrincipal,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Expanded(
                      child: _ListaHistorialMercado(historial: state.historial),
                    ),

                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final ResultadoCompraMercado? resultadoCompra =
                              await context.pushNamed<ResultadoCompraMercado>(
                            CompraActivoMercadoVista.nombre,
                            extra: ArgumentosActivoMercado(
                              activo: activo,
                              resultadoAutenticacion:
                                  argumentos.resultadoAutenticacion,
                            ),
                          );

                          if (resultadoCompra != null && context.mounted) {
                            context.pop(resultadoCompra);
                          }
                        },
                        icon: const Icon(Icons.shopping_cart_outlined),
                        label: const Text('Comprar participaciones'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colorPrimarioApp,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TarjetaDetalleActivo extends StatelessWidget {
  const _TarjetaDetalleActivo({required this.activo});

  final ActivoMercado activo;

  @override
  Widget build(BuildContext context) {
    final bool variacionPositiva = activo.porcentajeVariacion > 0;
    final bool mostrarVariacion = activo.porcentajeVariacion != 0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.colorTarjeta,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colorBorde),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _IconoActivoMercado(activo: activo),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      activo.nombre,
                      style: TextStyle(
                        color: context.colorTextoPrincipal,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _obtenerDetalle(activo),
                      style: TextStyle(
                        color: context.colorTextoSecundario,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            height: 28,
            color: context.colorBorde,
          ),
          _FilaDetalle(
            etiqueta: 'Valor actual',
            valor: '\$${activo.valorMercado.toStringAsFixed(0)}',
          ),
          if (mostrarVariacion) ...<Widget>[
            const SizedBox(height: 10),
            _FilaDetalle(
              etiqueta: 'Variación reciente',
              valor:
                  '${variacionPositiva ? '+' : ''}${activo.porcentajeVariacion.toStringAsFixed(1)}%',
              colorValor: variacionPositiva ? Colors.green : Colors.redAccent,
            ),
          ],
          const SizedBox(height: 10),
          _FilaDetalle(
            etiqueta: activo.tipo == TipoActivoMercado.equipo
                ? 'Nacionalidad'
                : 'Escudería',
            valor: activo.tipo == TipoActivoMercado.equipo
                ? activo.nacionalidad ?? 'No indicada'
                : activo.equipo ?? 'Sin escudería',
          ),
        ],
      ),
    );
  }

  String _obtenerDetalle(ActivoMercado activo) {
    if (activo.tipo == TipoActivoMercado.piloto) {
      return activo.equipo ?? 'Sin escudería';
    }

    return activo.nacionalidad ?? 'Escudería';
  }
}

class _FilaDetalle extends StatelessWidget {
  const _FilaDetalle({
    required this.etiqueta,
    required this.valor,
    this.colorValor,
  });

  final String etiqueta;
  final String valor;
  final Color? colorValor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          etiqueta,
          style: TextStyle(
            color: context.colorTextoSecundario,
            fontSize: 13,
          ),
        ),
        Text(
          valor,
          style: TextStyle(
            color: colorValor ?? context.colorTextoPrincipal,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ListaHistorialMercado extends StatelessWidget {
  const _ListaHistorialMercado({required this.historial});

  final List<HistorialMercado> historial;

  @override
  Widget build(BuildContext context) {
    if (historial.isEmpty) {
      //TODO: Mostrar historial cuando ya hayan eventos o carreras
      return Center(
        child: Text(
          'No hay historial disponible.',
          style: TextStyle(
            color: context.colorTextoSecundario,
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: historial.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) {
        final HistorialMercado item = historial[index];
        final bool positivo = item.porcentajeVariacion > 0;

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: context.colorTarjeta,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: context.colorBorde),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  item.motivo.isNotEmpty ? item.motivo : 'Cambio de mercado',
                  style: TextStyle(
                    color: context.colorTextoPrincipal,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                '${positivo ? '+' : ''}${item.porcentajeVariacion.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: positivo ? Colors.green : Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _IconoActivoMercado extends StatelessWidget {
  const _IconoActivoMercado({required this.activo});

  final ActivoMercado activo;

  @override
  Widget build(BuildContext context) {
    if (activo.tipo == TipoActivoMercado.equipo) {
      return Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: context.colorPrimarioApp,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(
          Icons.flag,
          color: Colors.white,
          size: 26,
        ),
      );
    }

    return CircleAvatar(
      radius: 26,
      backgroundColor: context.esTemaOscuro
          ? const Color(0xFF451414)
          : const Color(0xFFFFE5E5),
      child: Text(
        activo.codigo?.isNotEmpty == true
            ? activo.codigo!
            : activo.nombre.substring(0, 1).toUpperCase(),
        style: TextStyle(
          color: context.esTemaOscuro ? Colors.white : context.colorPrimarioApp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}