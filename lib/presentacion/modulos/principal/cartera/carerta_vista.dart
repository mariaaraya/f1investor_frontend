import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dominio/entidades/entidades.dart';
import 'cubit/cartera_cubit.dart';

class CarteraVista extends StatelessWidget {
  const CarteraVista({
    super.key,
    required this.resultadoAutenticacion,
  });

  final ResultadoAutenticacion resultadoAutenticacion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: SafeArea(
        child: BlocConsumer<CarteraCubit, CarteraState>(
          listener: (BuildContext context, CarteraState state) {
            if (state.mensajeError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.mensajeError!),
                ),
              );

              context.read<CarteraCubit>().limpiarMensajeError();
            }
          },
          builder: (BuildContext context, CarteraState state) {
            if (state.cargando && state.cartera == null) {
              return const Center(
                child: CircularProgressIndicator(),
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
                    const Text(
                      'Mi cartera',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tus inversiones actuales',
                      style: TextStyle(
                        color: Color(0xFFBDBDBD),
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
                        const Expanded(
                          child: Text(
                            'Mis inversiones',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (state.cargando)
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
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
                            onVender: () {
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF303030),
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
          const Divider(
            color: Color(0xFF303030),
            height: 1,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: _DatoResumen(
              titulo: 'Ganancia/Pérdida total',
              valor:
                  '${gananciaPerdidaTotal >= 0 ? '+' : '-'} \$${gananciaPerdidaTotal.abs().toStringAsFixed(0)}',
              colorValor: gananciaPerdidaTotal >= 0
                  ? const Color(0xFF00E676)
                  : const Color(0xFFFF5252),
              icono: gananciaPerdidaTotal >= 0
                  ? Icons.trending_up
                  : Icons.trending_down,
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
    this.colorValor = Colors.white,
    this.icono,
  });

  final String titulo;
  final String valor;
  final Color colorValor;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          titulo,
          style: const TextStyle(
            color: Color(0xFFBDBDBD),
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
                color: colorValor,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              valor,
              style: TextStyle(
                color: colorValor,
                fontSize: 19,
                fontWeight: FontWeight.w500,
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
    final Color colorGanancia = esGanancia
        ? const Color(0xFF00E676)
        : const Color(0xFFFF5252);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFF303030),
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
                  color: _obtenerColorActivo(item.tipoActivo),
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${item.cantidad.toStringAsFixed(0)} participaciones',
                      style: const TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          const Divider(
            color: Color(0xFF303030),
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
                backgroundColor: const Color(0xFF2C2C2C),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFF202020),
                disabledForegroundColor: const Color(0xFF777777),
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

  Color _obtenerColorActivo(String tipoActivo) {
    if (tipoActivo == 'piloto') {
      return const Color(0xFFE10600);
    }

    if (tipoActivo == 'equipo') {
      return const Color(0xFFD9D9D9);
    }

    return const Color(0xFF555555);
  }
}

class _DatoInversion extends StatelessWidget {
  const _DatoInversion({
    required this.titulo,
    required this.valor,
    this.colorValor = Colors.white,
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
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          valor,
          style: TextStyle(
            color: colorValor,
            fontSize: 12,
            fontWeight: FontWeight.w800,
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
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFF303030),
        ),
      ),
      child: const Text(
        'Todavía no tienes inversiones activas.',
        style: TextStyle(
          color: Color(0xFFBDBDBD),
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onReintentar,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE10600),
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