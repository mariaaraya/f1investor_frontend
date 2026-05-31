import 'package:flutter/material.dart';

import '../../../../dominio/entidades/entidades.dart';

class InicioVista extends StatelessWidget {
  const InicioVista({
    super.key,
    required this.resultadoAutenticacion,
  });

  final ResultadoAutenticacion resultadoAutenticacion;

  String _formatearMonto(double monto) {
    return '\$${monto.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final Usuario usuario = resultadoAutenticacion.usuario;

    final double gananciaPerdida =
        usuario.patrimonioTotal - usuario.capitalInicial;

    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: SafeArea(
        child: SingleChildScrollView(
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
                'Temporada 1 · Carrera 2 de 5', //TODO: Reemplazar con datos reales
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
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow),
                  label: const Text(
                    'Simular siguiente carrera',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE60000),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white70,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
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