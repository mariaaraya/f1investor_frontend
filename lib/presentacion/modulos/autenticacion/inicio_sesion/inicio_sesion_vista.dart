import 'package:f1investor_frontend/presentacion/comun/dialogos/dialogo_mensaje.dart';
import 'package:f1investor_frontend/presentacion/modulos/autenticacion/recuperar_password/recuperar_password_vista.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../dominio/entidades/entidades.dart';
import '../../../../infraestructura/extenciones/contexto_extensiones.dart';
import '../../principal/principal_vista.dart';
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
          context.goNamed(PrincipalVista.nombre, extra: resultado);
        }

        if (state.mensajeError != null) {
          await mostrarDialogoMensaje(
            context: context,
            titulo: 'No se pudo iniciar sesión',
            mensaje: state.mensajeError!,
            icono: Icons.error_outline,
            colorIcono: context.colorPrimarioApp,
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
                  const SizedBox(height: 70),
                  const _LogoInicioSesion(),
                  const SizedBox(height: 28),
                  Text(
                    'F1 Investor',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.colorTextoPrincipal,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 72),
                  _CampoInicioSesion(
                    etiqueta: 'Correo electrónico',
                    hint: 'correo@ejemplo.com',
                    tipoTeclado: TextInputType.emailAddress,
                    onChanged: context.read<InicioSesionCubit>().actualizarCorreo,
                  ),
                  const SizedBox(height: 26),
                  _CampoInicioSesion(
                    etiqueta: 'Contraseña',
                    hint: '••••••••',
                    obscureText: true,
                    onChanged: context.read<InicioSesionCubit>().actualizarPassword,
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state.formularioValido && !state.cargando
                          ? context.read<InicioSesionCubit>().iniciarSesion
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
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        color: context.colorTextoPrincipal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  TextButton(
                    onPressed: state.cargando
                        ? null
                        : () {
                            context.goNamed(RegistroVista.nombre);
                          },
                    child: Text(
                      'Crear cuenta',
                      style: TextStyle(
                        color: context.colorPrimarioApp,
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
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return Text(
            'F1',
            style: TextStyle(
              color: context.colorPrimarioApp,
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

class _CampoInicioSesion extends StatefulWidget {
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
  State<_CampoInicioSesion> createState() => _CampoInicioSesionState();
}

class _CampoInicioSesionState extends State<_CampoInicioSesion> {
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