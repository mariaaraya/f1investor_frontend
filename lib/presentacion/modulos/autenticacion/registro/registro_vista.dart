import 'package:f1investor_frontend/presentacion/comun/dialogos/dialogo_mensaje.dart';
import 'package:f1investor_frontend/presentacion/modulos/autenticacion/registro/cubit/registro_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../inicio_sesion/inicio_sesion_vista.dart';

class RegistroVista extends StatelessWidget {
  const RegistroVista({super.key});

  static const String nombre = 'registro';
  static const String ruta = '/registro';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegistroCubit, RegistroState>(
      listener: (BuildContext context, RegistroState state) async {
        if (state.mensajeError != null) {
          await mostrarDialogoMensaje(
            context: context,
            titulo: 'No se pudo registrar',
            mensaje: state.mensajeError!,
            icono: Icons.error_outline,
            colorIcono: const Color(0xFFE60000),
          );
        }

        if (state.mensajeExito != null) {
          await mostrarDialogoMensaje(
            context: context,
            titulo: 'Registro exitoso',
            mensaje: state.mensajeExito!,
            icono: Icons.check_circle_outline,
            colorIcono: Colors.green,
          );

          if (context.mounted) {
            context.goNamed(InicioSesionVista.nombre);
          }
        }
      },
      builder: (BuildContext context, RegistroState state) {
        return const _ContenidoRegistro();
      },
    );
  }
}

class _ContenidoRegistro extends StatelessWidget {
  const _ContenidoRegistro();

  @override
  Widget build(BuildContext context) {
    final RegistroState state = context.watch<RegistroCubit>().state;

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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: state.cargando
                          ? null
                          : () {
                              context.goNamed(InicioSesionVista.nombre);
                            },
                      icon: const Icon(Icons.arrow_back, color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 54),
                  const _LogoRegistro(),
                  const SizedBox(height: 22),
                  const Text(
                    'Crear cuenta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Únete a F1 Investor',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 14),
                  ),
                  const SizedBox(height: 44),
                  _CampoRegistro(
                    etiqueta: 'Nombre',
                    hint: 'Tu nombre',
                    onChanged: context.read<RegistroCubit>().actualizarNombre,
                  ),
                  const SizedBox(height: 22),
                  _CampoRegistro(
                    etiqueta: 'Correo electrónico',
                    hint: 'correo@ejemplo.com',
                    tipoTeclado: TextInputType.emailAddress,
                    onChanged: context.read<RegistroCubit>().actualizarCorreo,
                  ),
                  const SizedBox(height: 22),
                  _CampoRegistro(
                    etiqueta: 'Contraseña',
                    hint: '••••••••',
                    obscureText: true,
                    onChanged: context.read<RegistroCubit>().actualizarPassword,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Debe tener mínimo 8 caracteres, una mayúscula, una minúscula, un número y un símbolo.',
                    style: TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _CampoRegistro(
                    etiqueta: 'Confirmar contraseña',
                    hint: '••••••••',
                    obscureText: true,
                    onChanged: context
                        .read<RegistroCubit>()
                        .actualizarConfirmarPassword,
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state.formularioValido && !state.cargando
                          ? context.read<RegistroCubit>().registrarUsuario
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
                              'Registrarme',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 34),
                  TextButton(
                    onPressed: state.cargando
                        ? null
                        : () {
                            context.goNamed(InicioSesionVista.nombre);
                          },
                    child: const Text(
                      '¿Ya tienes cuenta? Inicia sesión',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoRegistro extends StatelessWidget {
  const _LogoRegistro();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/imagenes/f1_logo.png',
        height: 42,
        fit: BoxFit.contain,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
              return const Text(
                'F1',
                style: TextStyle(
                  color: Color(0xFFE60000),
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              );
            },
      ),
    );
  }
}

class _CampoRegistro extends StatelessWidget {
  const _CampoRegistro({
    required this.etiqueta,
    required this.hint,
    required this.onChanged,
    this.obscureText = false,
    this.tipoTeclado,
  });

  final String etiqueta;
  final String hint;
  final ValueChanged<String> onChanged;
  final bool obscureText;
  final TextInputType? tipoTeclado;

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
