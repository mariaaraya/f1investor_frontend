import 'package:f1investor_frontend/presentacion/comun/dialogos/dialogo_mensaje.dart';
import 'package:f1investor_frontend/presentacion/modulos/autenticacion/recuperar_password/recuperar_password_vista.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../dominio/entidades/entidades.dart';
import '../../inicio/inicio_vista.dart';
import '../registro/registro_vista.dart';
import 'cubit/inicio_sesion_cubit.dart';

class InicioSesionVista extends StatelessWidget {
  const InicioSesionVista({super.key});

  static const String nombre = 'inicioSesion';
  static const String ruta = '/login';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InicioSesionCubit, InicioSesionState>(
      listener: (BuildContext context, InicioSesionState state) async {
        final ResultadoAutenticacion? resultado = state.resultadoAutenticacion;

        if (resultado != null) {
          context.goNamed(InicioVista.nombre, extra: resultado);
        }

        if (state.mensajeError != null) {
          await mostrarDialogoMensaje(
            context: context,
            titulo: 'No se pudo iniciar sesión',
            mensaje: state.mensajeError!,
            icono: Icons.error_outline,
            colorIcono: const Color(0xFFE60000),
          );
        }
      },
      builder: (BuildContext context, InicioSesionState state) {
        return const _ContenidoInicioSesion();
      },
    );
  }
}

class _ContenidoInicioSesion extends StatelessWidget {
  const _ContenidoInicioSesion();

  @override
  Widget build(BuildContext context) {
    final InicioSesionState state = context.watch<InicioSesionCubit>().state;

    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 70),
                  const _LogoInicioSesion(),
                  const SizedBox(height: 28),
                  const Text(
                    'F1 Investor',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 72),
                  _CampoInicioSesion(
                    etiqueta: 'Correo electrónico',
                    hint: 'correo@ejemplo.com',
                    tipoTeclado: TextInputType.emailAddress,
                    onChanged: context
                        .read<InicioSesionCubit>()
                        .actualizarCorreo,
                  ),
                  const SizedBox(height: 26),
                  _CampoInicioSesion(
                    etiqueta: 'Contraseña',
                    hint: '••••••••',
                    obscureText: true,
                    onChanged: context
                        .read<InicioSesionCubit>()
                        .actualizarPassword,
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state.formularioValido && !state.cargando
                          ? context.read<InicioSesionCubit>().iniciarSesion
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE60000),
                        disabledBackgroundColor: const Color(
                          0xFFE60000,
                        ).withOpacity(0.60),
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.white70,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: state.cargando
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Iniciar sesión',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 58),
                  TextButton(
                    onPressed: state.cargando
                        ? null
                        : () {
                            context.goNamed(RecuperarPasswordVista.nombre);
                          },
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 28),
                  TextButton(
                    onPressed: state.cargando
                        ? null
                        : () {
                            context.goNamed(RegistroVista.nombre);
                          },
                    child: const Text(
                      'Crear cuenta',
                      style: TextStyle(
                        color: Color(0xFFE60000),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoInicioSesion extends StatelessWidget {
  const _LogoInicioSesion();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/imagenes/f1_logo.png',
        height: 46,
        fit: BoxFit.contain,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
              return const Text(
                'F1',
                style: TextStyle(
                  color: Color(0xFFE60000),
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              );
            },
      ),
    );
  }
}

class _CampoInicioSesion extends StatelessWidget {
  const _CampoInicioSesion({
    required this.etiqueta,
    required this.hint,
    required this.onChanged,
    this.obscureText = false,
    this.tipoTeclado,
  });

  final String etiqueta;
  final String hint;
  final bool obscureText;
  final TextInputType? tipoTeclado;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          etiqueta,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: tipoTeclado,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          cursorColor: const Color(0xFFE60000),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
            filled: true,
            fillColor: const Color(0xFF1C1C1C),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Color(0xFF333333)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(
                color: Color(0xFFE60000),
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
