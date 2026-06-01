import 'package:f1investor_frontend/presentacion/comun/dialogos/dialogo_mensaje.dart';
import 'package:f1investor_frontend/presentacion/modulos/autenticacion/recuperar_password/cubit/recuperar_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../inicio_sesion/inicio_sesion_vista.dart';

class RecuperarPasswordVista extends StatelessWidget {
  const RecuperarPasswordVista({
    super.key,
    this.vieneDesdePerfil = false,
  });

  final bool vieneDesdePerfil;

  static const String nombre = 'recuperarPassword';
  static const String ruta = '/recuperar-password';

  void _volver(BuildContext context) {
    if (vieneDesdePerfil && context.canPop()) {
      context.pop();
      return;
    }

    context.goNamed(InicioSesionVista.nombre);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecuperarPasswordCubit, RecuperarPasswordState>(
      listener: (BuildContext context, RecuperarPasswordState state) async {
        if (state.mensajeError != null) {
          await mostrarDialogoMensaje(
            context: context,
            titulo: 'No se pudo actualizar',
            mensaje: state.mensajeError!,
            icono: Icons.error_outline,
            colorIcono: const Color(0xFFE60000),
          );
        }

        if (state.mensajeExito != null) {
          await mostrarDialogoMensaje(
            context: context,
            titulo: 'Contraseña actualizada',
            mensaje: state.mensajeExito!,
            icono: Icons.check_circle_outline,
            colorIcono: Colors.green,
          );

          if (context.mounted) {
            _volver(context);
          }
        }
      },
      builder: (BuildContext context, RecuperarPasswordState state) {
        return _ContenidoRecuperarPassword(
          vieneDesdePerfil: vieneDesdePerfil,
          onVolver: () {
            _volver(context);
          },
        );
      },
    );
  }
}

class _ContenidoRecuperarPassword extends StatelessWidget {
  const _ContenidoRecuperarPassword({
    required this.vieneDesdePerfil,
    required this.onVolver,
  });

  final bool vieneDesdePerfil;
  final VoidCallback onVolver;

  @override
  Widget build(BuildContext context) {
    final RecuperarPasswordState state = context
        .watch<RecuperarPasswordCubit>()
        .state;

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
                      onPressed: state.cargando ? null : onVolver,
                      icon: const Icon(Icons.arrow_back, color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 54),
                  const _LogoRecuperarPassword(),
                  const SizedBox(height: 22),
                  const Text(
                    'Cambiar contraseña',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Ingresa tu correo y define una nueva contraseña.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFE0E0E0),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 44),
                  _CampoRecuperarPassword(
                    etiqueta: 'Correo electrónico',
                    hint: 'correo@ejemplo.com',
                    tipoTeclado: TextInputType.emailAddress,
                    onChanged: context
                        .read<RecuperarPasswordCubit>()
                        .actualizarCorreo,
                  ),
                  const SizedBox(height: 22),
                  _CampoRecuperarPassword(
                    etiqueta: 'Nueva contraseña',
                    hint: '••••••••',
                    obscureText: true,
                    onChanged: context
                        .read<RecuperarPasswordCubit>()
                        .actualizarNuevoPassword,
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
                  _CampoRecuperarPassword(
                    etiqueta: 'Confirmar contraseña',
                    hint: '••••••••',
                    obscureText: true,
                    onChanged: context
                        .read<RecuperarPasswordCubit>()
                        .actualizarConfirmarPassword,
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state.formularioValido && !state.cargando
                          ? context
                              .read<RecuperarPasswordCubit>()
                              .recuperarPassword
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
                              'Actualizar contraseña',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 34),
                  TextButton(
                    onPressed: state.cargando ? null : onVolver,
                    child: Text(
                      vieneDesdePerfil
                          ? 'Volver al perfil'
                          : 'Volver al inicio de sesión',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
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

class _LogoRecuperarPassword extends StatelessWidget {
  const _LogoRecuperarPassword();

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

class _CampoRecuperarPassword extends StatefulWidget {
  const _CampoRecuperarPassword({
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
  State<_CampoRecuperarPassword> createState() =>
      _CampoRecuperarPasswordState();
}

class _CampoRecuperarPasswordState extends State<_CampoRecuperarPassword> {
  bool _mostrarTexto = false;

  void _cambiarVisibilidad() {
    setState(() {
      _mostrarTexto = !_mostrarTexto;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool ocultarTexto = widget.obscureText && !_mostrarTexto;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.etiqueta,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          onChanged: widget.onChanged,
          obscureText: ocultarTexto,
          keyboardType: widget.tipoTeclado,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          cursorColor: const Color(0xFFE60000),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 14,
            ),
            filled: true,
            fillColor: const Color(0xFF1C1C1C),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
                    onPressed: _cambiarVisibilidad,
                    icon: Icon(
                      _mostrarTexto
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white70,
                    ),
                  )
                : null,
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