import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../dominio/entidades/entidades.dart';
import '../../../../infraestructura/extenciones/contexto_extensiones.dart';
import '../../../tema/cubit/tema_cubit.dart';
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

  void _mostrarSelectorTema(BuildContext context) {
    final TemaAplicacion temaActual = context.read<TemaCubit>().state.tema;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colorTarjeta,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18),
        ),
      ),
      builder: (BuildContext modalContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tema de la aplicación',
                    style: TextStyle(
                      color: context.colorTextoPrincipal,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Selecciona cómo quieres ver la app',
                    style: TextStyle(
                      color: context.colorTextoSecundario,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _OpcionTema(
                  icono: Icons.phone_android_outlined,
                  titulo: 'Sistema',
                  subtitulo: 'Usar el tema configurado en el teléfono',
                  seleccionado: temaActual == TemaAplicacion.sistema,
                  onTap: () {
                    context
                        .read<TemaCubit>()
                        .cambiarTema(TemaAplicacion.sistema);
                    Navigator.of(modalContext).pop();
                  },
                ),
                const SizedBox(height: 10),
                _OpcionTema(
                  icono: Icons.light_mode_outlined,
                  titulo: 'Claro',
                  subtitulo: 'Usar siempre el tema claro',
                  seleccionado: temaActual == TemaAplicacion.claro,
                  onTap: () {
                    context.read<TemaCubit>().cambiarTema(TemaAplicacion.claro);
                    Navigator.of(modalContext).pop();
                  },
                ),
                const SizedBox(height: 10),
                _OpcionTema(
                  icono: Icons.dark_mode_outlined,
                  titulo: 'Oscuro',
                  subtitulo: 'Usar siempre el tema oscuro',
                  seleccionado: temaActual == TemaAplicacion.oscuro,
                  onTap: () {
                    context
                        .read<TemaCubit>()
                        .cambiarTema(TemaAplicacion.oscuro);
                    Navigator.of(modalContext).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Usuario usuario = resultadoAutenticacion.usuario;

    return Scaffold(
      backgroundColor: context.colorFondo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Perfil',
                style: TextStyle(
                  color: context.colorTextoPrincipal,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tu información de usuario',
                style: TextStyle(
                  color: context.colorTextoSecundario,
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
              const _TituloSeccion(titulo: 'Preferencias'),
              const SizedBox(height: 12),
              BlocBuilder<TemaCubit, TemaState>(
                builder: (BuildContext context, TemaState state) {
                  return _OpcionPerfil(
                    icono: Icons.palette_outlined,
                    titulo: 'Tema',
                    subtitulo: state.tema.etiqueta,
                    onTap: () => _mostrarSelectorTema(context),
                  );
                },
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
                colorIcono: context.colorPrimarioApp,
                colorTexto: context.colorPrimarioApp,
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
        color: context.colorTarjeta,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colorBorde),
      ),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 34,
            backgroundColor: context.esTemaOscuro
                ? const Color(0xFF4A1111)
                : const Color(0xFFFFE5E5),
            child: Icon(
              Icons.person_outline,
              color: context.colorPrimarioApp,
              size: 42,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            nombre,
            style: TextStyle(
              color: context.colorTextoPrincipal,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            correo,
            style: TextStyle(
              color: context.colorTextoSecundario,
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
        color: context.colorTarjeta,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colorBorde),
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
              color: context.esTemaOscuro
                  ? const Color(0xFF4A1111)
                  : const Color(0xFFFFE5E5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icono,
              color: context.colorPrimarioApp,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  titulo,
                  style: TextStyle(
                    color: context.colorTextoSecundario,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  valor,
                  style: TextStyle(
                    color: context.colorTextoPrincipal,
                    fontSize: 14,
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

class _OpcionPerfil extends StatelessWidget {
  const _OpcionPerfil({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
    this.colorIcono,
    this.colorTexto,
  });

  final IconData icono;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;
  final Color? colorIcono;
  final Color? colorTexto;

  @override
  Widget build(BuildContext context) {
    final Color iconoColor = colorIcono ?? context.colorTextoSecundario;
    final Color textoColor = colorTexto ?? context.colorTextoPrincipal;

    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.colorTarjeta,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: context.colorBorde),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: context.colorTarjetaSecundaria,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icono,
                color: iconoColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    titulo,
                    style: TextStyle(
                      color: textoColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitulo,
                    style: TextStyle(
                      color: context.colorTextoSecundario,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: context.colorTextoSecundario,
            ),
          ],
        ),
      ),
    );
  }
}

class _OpcionTema extends StatelessWidget {
  const _OpcionTema({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.seleccionado,
    required this.onTap,
  });

  final IconData icono;
  final String titulo;
  final String subtitulo;
  final bool seleccionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: seleccionado
              ? context.esTemaOscuro
                  ? const Color(0xFF2A0A0A)
                  : const Color(0xFFFFE5E5)
              : context.colorTarjetaSecundaria,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: seleccionado ? context.colorPrimarioApp : context.colorBorde,
          ),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              icono,
              color: seleccionado
                  ? context.colorPrimarioApp
                  : context.colorTextoSecundario,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    titulo,
                    style: TextStyle(
                      color: context.colorTextoPrincipal,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitulo,
                    style: TextStyle(
                      color: context.colorTextoSecundario,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (seleccionado)
              Icon(
                Icons.check_circle,
                color: context.colorPrimarioApp,
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
      style: TextStyle(
        color: context.colorTextoPrincipal,
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
    return Divider(
      height: 1,
      color: context.colorBorde,
    );
  }
}