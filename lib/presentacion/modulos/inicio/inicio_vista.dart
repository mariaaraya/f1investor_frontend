import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../dominio/entidades/entidades.dart';
import '../autenticacion/inicio_sesion/inicio_sesion_vista.dart';

class InicioVista extends StatelessWidget {
  const InicioVista({
    required this.resultadoAutenticacion,
    super.key,
  });

  static const String nombre = 'inicio';
  static const String ruta = '/inicio';

  final ResultadoAutenticacion resultadoAutenticacion;

  @override
  Widget build(BuildContext context) {
    final Usuario usuario = resultadoAutenticacion.usuario;

    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      appBar: AppBar(
        backgroundColor: const Color(0xFF080808),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'F1 Investor',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.goNamed(InicioSesionVista.nombre);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                maxWidth: 420,
              ),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF2A2A2A),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.sports_motorsports,
                    color: Color(0xFFE60000),
                    size: 52,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Bienvenido, ${usuario.nombre}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    usuario.correo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Inicio de F1 Investor',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Placeholder temporal del dashboard principal.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _DatoUsuario(
                    etiqueta: 'Rol',
                    valor: usuario.rol,
                  ),
                  const SizedBox(height: 10),
                  _DatoUsuario(
                    etiqueta: 'Capital',
                    valor: usuario.capital.toStringAsFixed(2),
                  ),
                  const SizedBox(height: 10),
                  _DatoUsuario(
                    etiqueta: 'Patrimonio total',
                    valor: usuario.patrimonioTotal.toStringAsFixed(2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DatoUsuario extends StatelessWidget {
  const _DatoUsuario({
    required this.etiqueta,
    required this.valor,
  });

  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF333333),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              etiqueta,
              style: const TextStyle(
                color: Color(0xFFBDBDBD),
                fontSize: 13,
              ),
            ),
          ),
          Text(
            valor,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}