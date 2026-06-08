import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dominio/entidades/entidades.dart';
import '../../../../infraestructura/extenciones/contexto_extensiones.dart';
import 'cubit/cartera_cubit.dart';

class CarteraVista extends StatelessWidget {
  const CarteraVista({
    super.key,
    required this.resultadoAutenticacion,
  });

  final ResultadoAutenticacion resultadoAutenticacion;

  Future<bool> _mostrarConfirmacionVenta({
    required BuildContext context,
    required ItemCartera item,
  }) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: context.colorTarjeta,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Confirmar venta',
            style: TextStyle(
              color: context.colorTextoPrincipal,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '¿Deseas vender esta inversión?',
                style: TextStyle(
                  color: context.colorTextoSecundario,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              _DatoConfirmacionVenta(
                etiqueta: 'Activo',
                valor: item.nombreActivo.isNotEmpty
                    ? item.nombreActivo
                    : 'Activo sin nombre',
              ),
              const SizedBox(height: 8),
              _DatoConfirmacionVenta(
                etiqueta: 'Cantidad',
                valor: '${item.cantidad.toStringAsFixed(0)} participaciones',
              ),
              const SizedBox(height: 8),
              _DatoConfirmacionVenta(
                etiqueta: 'Valor actual',
                valor: '\$${item.valorActualTotal.toStringAsFixed(0)}',
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: context.colorTextoSecundario,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorPrimarioApp,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text(
                'Vender',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );

    return confirmar ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorFondo,
      body: SafeArea(
        child: BlocConsumer<CarteraCubit, CarteraState>(
          listener: (BuildContext context, CarteraState state) {
            if (state.mensajeError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: context.colorTarjeta,
                  content: Text(
                    state.mensajeError!,
                    style: TextStyle(
                      color: context.colorTextoPrincipal,
                    ),
                  ),
                ),
              );

              context.read<CarteraCubit>().limpiarMensajeError();
            }
          },
          builder: (BuildContext context, CarteraState state) {
            if (state.cargando && state.cartera == null) {
              return Center(
                child: CircularProgressIndicator(
                  color: context.colorPrimarioApp,
                ),
              );
            }

            final Cartera? cartera = state.cartera;

            if (cartera == null) {
              return _MensajeCartera(
                mensaje: 'No se pudo cargar la cartera',
                onReintentar: () {
                  context.read<CarteraCubit>().cargarCartera(
                        token: resultadoAutenticacion.token,
                      );
                },
              );
            }

            return RefreshIndicator(
              onRefresh: () {
                return context.read<CarteraCubit>().cargarCartera(
                      token: resultadoAutenticacion.token,
                    );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Mi cartera',
                      style: TextStyle(
                        color: context.colorTextoPrincipal,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tus inversiones actuales',
                      style: TextStyle(
                        color: context.colorTextoSecundario,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 22),
                    _ResumenCartera(
                      capitalDisponible: cartera.capital,
                      valorInvertido: cartera.valorTotal,
                      gananciaPerdidaTotal: cartera.gananciaTotal,
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Mis inversiones',
                            style: TextStyle(
                              color: context.colorTextoPrincipal,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (state.cargando)
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: context.colorPrimarioApp,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (cartera.portfolio.isEmpty)
                      const _CarteraVacia()
                    else
                      ...cartera.portfolio.map(
                        (ItemCartera item) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _TarjetaInversion(
                            item: item,
                            vendiendo: state.vendiendo,
                            onVender: () async {
                              final bool confirmar =
                                  await _mostrarConfirmacionVenta(
                                context: context,
                                item: item,
                              );

                              if (!confirmar || !context.mounted) {
                                return;
                              }

                              context.read<CarteraCubit>().venderActivo(
                                    token: resultadoAutenticacion.token,
                                    item: item,
                                  );
                            },
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

class _ResumenCartera extends StatelessWidget {
  const _ResumenCartera({
    required this.capitalDisponible,
    required this.valorInvertido,
    required this.gananciaPerdidaTotal,
  });

  final double capitalDisponible;
  final double valorInvertido;
  final double gananciaPerdidaTotal;

  @override
  Widget build(BuildContext context) {
    final bool esGanancia = gananciaPerdidaTotal >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.colorTarjeta,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: context.colorBorde,
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _DatoResumen(
                  titulo: 'Capital disponible',
                  valor: '\$${capitalDisponible.toStringAsFixed(0)}',
                ),
              ),
              Expanded(
                child: _DatoResumen(
                  titulo: 'Valor invertido',
                  valor: '\$${valorInvertido.toStringAsFixed(0)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            color: context.colorBorde,
            height: 1,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: _DatoResumen(
              titulo: 'Ganancia/Pérdida total',
              valor:
                  '${esGanancia ? '+' : '-'} \$${gananciaPerdidaTotal.abs().toStringAsFixed(0)}',
              colorValor: esGanancia ? Colors.green : Colors.redAccent,
              icono: esGanancia ? Icons.trending_up : Icons.trending_down,
            ),
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
    this.colorValor,
    this.icono,
  });

  final String titulo;
  final String valor;
  final Color? colorValor;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    final Color valorColor = colorValor ?? context.colorTextoPrincipal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          titulo,
          style: TextStyle(
            color: context.colorTextoSecundario,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icono != null) ...<Widget>[
              Icon(
                icono,
                size: 18,
                color: valorColor,
              ),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                valor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: valorColor,
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TarjetaInversion extends StatelessWidget {
  const _TarjetaInversion({
    required this.item,
    required this.vendiendo,
    required this.onVender,
  });

  final ItemCartera item;
  final bool vendiendo;
  final VoidCallback onVender;

  @override
  Widget build(BuildContext context) {
    final bool esGanancia = item.gananciaPerdida >= 0;
    final Color colorGanancia = esGanancia ? Colors.green : Colors.redAccent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: context.colorTarjeta,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: context.colorBorde,
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _obtenerColorActivo(context, item.tipoActivo),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  item.tipoActivo == 'piloto'
                      ? Icons.sports_motorsports
                      : Icons.flag,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.nombreActivo.isNotEmpty
                          ? item.nombreActivo
                          : 'Activo sin nombre',
                      style: TextStyle(
                        color: context.colorTextoPrincipal,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${item.cantidad.toStringAsFixed(0)} participaciones',
                      style: TextStyle(
                        color: context.colorTextoSecundario,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Divider(
            color: context.colorBorde,
            height: 1,
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _DatoInversion(
                  titulo: 'Valor actual',
                  valor: '\$${item.valorActualTotal.toStringAsFixed(0)}',
                ),
              ),
              Expanded(
                child: _DatoInversion(
                  titulo: 'Ganancia/Pérdida',
                  valor:
                      '${esGanancia ? '+' : '-'}\$${item.gananciaPerdida.abs().toStringAsFixed(0)} '
                      '(${esGanancia ? '+' : '-'}${item.porcentajeRendimiento.abs().toStringAsFixed(1)}%)',
                  colorValor: colorGanancia,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              onPressed: vendiendo ? null : onVender,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorTarjetaSecundaria,
                foregroundColor: context.colorTextoPrincipal,
                disabledBackgroundColor: context.colorTarjetaSecundaria,
                disabledForegroundColor: context.colorTextoSecundario,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(
                vendiendo ? 'Vendiendo...' : 'Vender',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _obtenerColorActivo(BuildContext context, String tipoActivo) {
    if (tipoActivo == 'piloto') {
      return context.colorPrimarioApp;
    }

    if (tipoActivo == 'equipo') {
      return context.esTemaOscuro
          ? const Color(0xFFD9D9D9)
          : const Color(0xFF555555);
    }

    return const Color(0xFF777777);
  }
}

class _DatoInversion extends StatelessWidget {
  const _DatoInversion({
    required this.titulo,
    required this.valor,
    this.colorValor,
  });

  final String titulo;
  final String valor;
  final Color? colorValor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          titulo,
          style: TextStyle(
            color: context.colorTextoSecundario,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          valor,
          style: TextStyle(
            color: colorValor ?? context.colorTextoPrincipal,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _DatoConfirmacionVenta extends StatelessWidget {
  const _DatoConfirmacionVenta({
    required this.etiqueta,
    required this.valor,
  });

  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            etiqueta,
            style: TextStyle(
              color: context.colorTextoSecundario,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            valor,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: context.colorTextoPrincipal,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _CarteraVacia extends StatelessWidget {
  const _CarteraVacia();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.colorTarjeta,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: context.colorBorde,
        ),
      ),
      child: Text(
        'Todavía no tienes inversiones activas.',
        style: TextStyle(
          color: context.colorTextoSecundario,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _MensajeCartera extends StatelessWidget {
  const _MensajeCartera({
    required this.mensaje,
    required this.onReintentar,
  });

  final String mensaje;
  final VoidCallback onReintentar;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colorTextoPrincipal,
                fontSize: 14,
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
      ),
    );
  }
}