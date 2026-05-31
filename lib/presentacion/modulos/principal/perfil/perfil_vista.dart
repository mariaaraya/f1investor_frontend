import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../dominio/entidades/entidades.dart';
import '../../autenticacion/inicio_sesion/inicio_sesion_vista.dart';
import '../../autenticacion/recuperar_password/recuperar_password_vista.dart';

class PerfilVista extends StatelessWidget {
  const PerfilVista({
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

    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Perfil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tu información de usuario',
                style: TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),

              _TarjetaUsuario(
                nombre: usuario.nombre,
                correo: usuario.correo,
              ),

              const SizedBox(height: 26),
              const _TituloSeccion(titulo: 'Datos de simulación'),
              const SizedBox(height: 12),

              _TarjetaDatosSimulacion(
                capitalInicial: _formatearMonto(usuario.capitalInicial),
                capitalActual: _formatearMonto(usuario.capital),
                valorCartera: _formatearMonto(usuario.valorPortfolio),
                patrimonioTotal: _formatearMonto(usuario.patrimonioTotal),
              ),

              const SizedBox(height: 26),
              const _TituloSeccion(titulo: 'Opciones de cuenta'),
              const SizedBox(height: 12),

              _OpcionPerfil(
                icono: Icons.lock_outline,
                titulo: 'Cambiar contraseña',
                subtitulo: 'Actualiza tu contraseña',
                onTap: () {
                  context.pushNamed(
                    RecuperarPasswordVista.nombre,
                    extra: true,
                  );
                },
              ),
              const SizedBox(height: 12),
              _OpcionPerfil(
                icono: Icons.logout,
                titulo: 'Cerrar sesión',
                subtitulo: 'Salir de tu cuenta',
                colorIcono: const Color(0xFFE60000),
                colorTexto: const Color(0xFFE60000),
                onTap: () {
                  context.goNamed(InicioSesionVista.nombre);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TarjetaUsuario extends StatelessWidget {
  const _TarjetaUsuario({
    required this.nombre,
    required this.correo,
  });

  final String nombre;
  final String correo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Column(
        children: <Widget>[
          const CircleAvatar(
            radius: 34,
            backgroundColor: Color(0xFF4A1111),
            child: Icon(
              Icons.person_outline,
              color: Color(0xFFE60000),
              size: 42,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            nombre,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            correo,
            style: const TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaDatosSimulacion extends StatelessWidget {
  const _TarjetaDatosSimulacion({
    required this.capitalInicial,
    required this.capitalActual,
    required this.valorCartera,
    required this.patrimonioTotal,
  });

  final String capitalInicial;
  final String capitalActual;
  final String valorCartera;
  final String patrimonioTotal;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Column(
        children: <Widget>[
          _FilaDatoSimulacion(
            icono: Icons.attach_money,
            titulo: 'Capital inicial',
            valor: capitalInicial,
          ),
          const _Separador(),
          _FilaDatoSimulacion(
            icono: Icons.account_balance_wallet_outlined,
            titulo: 'Capital actual',
            valor: capitalActual,
          ),
          const _Separador(),
          _FilaDatoSimulacion(
            icono: Icons.trending_up,
            titulo: 'Valor de cartera',
            valor: valorCartera,
          ),
          const _Separador(),
          _FilaDatoSimulacion(
            icono: Icons.savings_outlined,
            titulo: 'Patrimonio total',
            valor: patrimonioTotal,
          ),
        ],
      ),
    );
  }
}

class _FilaDatoSimulacion extends StatelessWidget {
  const _FilaDatoSimulacion({
    required this.icono,
    required this.titulo,
    required this.valor,
  });

  final IconData icono;
  final String titulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF4A1111),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icono,
              color: const Color(0xFFE60000),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                titulo,
                style: const TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                valor,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OpcionPerfil extends StatelessWidget {
  const _OpcionPerfil({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
    this.colorIcono = Colors.white70,
    this.colorTexto = Colors.white,
  });

  final IconData icono;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;
  final Color colorIcono;
  final Color colorTexto;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: const Color(0xFF333333)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icono,
                color: colorIcono,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  titulo,
                  style: TextStyle(
                    color: colorTexto,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitulo,
                  style: const TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TituloSeccion extends StatelessWidget {
  const _TituloSeccion({
    required this.titulo,
  });

  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Text(
      titulo,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _Separador extends StatelessWidget {
  const _Separador();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      color: Color(0xFF333333),
    );
  }
}