import 'package:f1investor_frontend/presentacion/comun/dialogos/dialogo_mensaje.dart';
import 'package:f1investor_frontend/presentacion/modulos/principal/mercado/resultado_compra_mercado.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dominio/casos_uso/mercado/comprar_activo_caso_uso.dart';
import '../../../../../dominio/entidades/entidades.dart';
import '../../../../../infraestructura/dependencias/inyeccion_dependencias.dart';
import '../argumentos_activo_mercado.dart';
import 'cubit/compra_activo_mercado_cubit.dart';

class CompraActivoMercadoVista extends StatefulWidget {
  const CompraActivoMercadoVista({super.key, required this.argumentos});

  static const String nombre = 'compraActivoMercado';
  static const String ruta = '/compra-activo-mercado';

  final ArgumentosActivoMercado argumentos;

  @override
  State<CompraActivoMercadoVista> createState() =>
      _CompraActivoMercadoVistaState();
}

class _CompraActivoMercadoVistaState extends State<CompraActivoMercadoVista> {
  final TextEditingController _cantidadController = TextEditingController(
    text: '1',
  );

  double get _cantidad {
    final String texto = _cantidadController.text.trim().replaceAll(',', '.');
    return double.tryParse(texto) ?? 0;
  }

  double get _totalEstimado {
    return widget.argumentos.activo.valorMercado * _cantidad;
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ActivoMercado activo = widget.argumentos.activo;
    final ResultadoAutenticacion resultado =
        widget.argumentos.resultadoAutenticacion;

    return BlocProvider<CompraActivoMercadoCubit>(
      create: (_) => CompraActivoMercadoCubit(
        comprarActivoCasoUso: sl<ComprarActivoCasoUso>(),
      ),
      child: BlocConsumer<CompraActivoMercadoCubit, CompraActivoMercadoState>(
        listener: (BuildContext context, CompraActivoMercadoState state) async {
          if (state.mensajeError != null) {
            await mostrarDialogoMensaje(
              context: context,
              titulo: 'No se pudo realizar la compra',
              mensaje: state.mensajeError!,
              icono: Icons.error_outline,
              colorIcono: const Color(0xFFE60000),
            );

            if (context.mounted) {
              context.read<CompraActivoMercadoCubit>().limpiarMensajeError();
            }
          }

          if (state.compraRealizada) {
            await mostrarDialogoMensaje(
              context: context,
              titulo: 'Compra realizada',
              mensaje: state.mensajeExito?.isNotEmpty == true
                  ? state.mensajeExito!
                  : 'La compra se realizó correctamente.',
              icono: Icons.check_circle_outline,
              colorIcono: Colors.green,
            );

            if (context.mounted) {
              context.read<CompraActivoMercadoCubit>().limpiarMensajeExito();
              Navigator.of(context).pop(
                ResultadoCompraMercado(
                  capitalRestante: state.capitalRestante,
                  totalCompra: _totalEstimado,
                ),
              );
            }
          }
        },
        builder: (BuildContext context, CompraActivoMercadoState state) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              title: const Text('Comprar participaciones'),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B1B1B),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              _IconoCompraActivo(activo: activo),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      activo.nombre,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '\$${activo.valorMercado.toStringAsFixed(0)} por participación',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 28, color: Colors.white12),
                          _FilaCompra(
                            etiqueta: 'Capital disponible',
                            valor:
                                '\$${resultado.usuario.capital.toStringAsFixed(0)}',
                          ),
                          const SizedBox(height: 18),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Cantidad de participaciones',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _cantidadController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF171717),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white12,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                          const Divider(height: 28, color: Colors.white12),
                          _FilaCompra(
                            etiqueta: 'Total estimado',
                            valor: '\$${_totalEstimado.toStringAsFixed(0)}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              onPressed: state.cargando
                                  ? null
                                  : () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2A2A2A),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Cancelar'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              onPressed: state.cargando
                                  ? null
                                  : () {
                                      context
                                          .read<CompraActivoMercadoCubit>()
                                          .comprarActivo(
                                            activo: activo,
                                            cantidad: _cantidad,
                                            capitalDisponible:
                                                resultado.usuario.capital,
                                            token: resultado.token,
                                          );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: state.cargando
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Confirmar'),
                            ),
                          ),
                        ),
                      ],
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

class _FilaCompra extends StatelessWidget {
  const _FilaCompra({required this.etiqueta, required this.valor});

  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          etiqueta,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        Text(valor, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }
}

class _IconoCompraActivo extends StatelessWidget {
  const _IconoCompraActivo({required this.activo});

  final ActivoMercado activo;

  @override
  Widget build(BuildContext context) {
    if (activo.tipo == TipoActivoMercado.equipo) {
      return Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(6),
        ),
      );
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: const Color(0xFF451414),
      child: Text(
        activo.codigo?.isNotEmpty == true
            ? activo.codigo!
            : activo.nombre.substring(0, 1).toUpperCase(),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
