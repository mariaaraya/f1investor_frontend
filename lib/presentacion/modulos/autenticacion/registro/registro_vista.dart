import 'package:f1investor_frontend/presentacion/comun/dialogos/dialogo_mensaje.dart';
import 'package:f1investor_frontend/presentacion/modulos/autenticacion/registro/cubit/registro_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../infraestructura/extenciones/contexto_extensiones.dart';
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
            colorIcono: context.colorPrimarioApp,
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
      backgroundColor: context.colorFondo,
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
                      icon: Icon(
                        Icons.arrow_back,
                        color: context.colorTextoSecundario,
                      ),
                    ),
                  ),
                  const SizedBox(height: 54),
                  const _LogoRegistro(),
                  const SizedBox(height: 22),
                  Text(
                    'Crear cuenta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.colorTextoPrincipal,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Únete a F1 Investor',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.colorTextoSecundario,
                      fontSize: 14,
                    ),
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
                  Text(
                    'Debe tener mínimo 8 caracteres, una mayúscula, una minúscula, un número y un símbolo.',
                    style: TextStyle(
                      color: context.colorTextoSecundario,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _CampoRegistro(
                    etiqueta: 'Confirmar contraseña',
                    hint: '••••••••',
                    obscureText: true,
                    onChanged:
                        context.read<RegistroCubit>().actualizarConfirmarPassword,
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state.formularioValido && !state.cargando
                          ? context.read<RegistroCubit>().registrarUsuario
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colorPrimarioApp,
                        disabledBackgroundColor:
                            context.colorPrimarioApp.withOpacity(0.60),
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
                    child: Text(
                      '¿Ya tienes cuenta? Inicia sesión',
                      style: TextStyle(
                        color: context.colorTextoPrincipal,
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

class _LogoRegistro extends StatelessWidget {
  const _LogoRegistro();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/imagenes/f1_logo.png',
        height: 42,
        fit: BoxFit.contain,
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return Text(
            'F1',
            style: TextStyle(
              color: context.colorPrimarioApp,
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

class _CampoRegistro extends StatefulWidget {
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
  State<_CampoRegistro> createState() => _CampoRegistroState();
}

class _CampoRegistroState extends State<_CampoRegistro> {
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
          style: TextStyle(
            color: context.colorTextoPrincipal,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          onChanged: widget.onChanged,
          obscureText: ocultarTexto,
          keyboardType: widget.tipoTeclado,
          style: TextStyle(
            color: context.colorTextoPrincipal,
            fontSize: 14,
          ),
          cursorColor: context.colorPrimarioApp,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: context.colorHint,
              fontSize: 14,
            ),
            filled: true,
            fillColor: context.colorCampo,
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
                      color: context.colorTextoSecundario,
                    ),
                  )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(color: context.colorBorde),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                color: context.colorPrimarioApp,
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}