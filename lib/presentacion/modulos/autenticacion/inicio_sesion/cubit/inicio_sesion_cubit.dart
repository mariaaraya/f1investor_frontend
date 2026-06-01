import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:f1investor_frontend/presentacion/comun/validadores/validadores_formulario.dart';

import '../../../../../dominio/casos_uso/sesiones/iniciar_sesion_caso_uso.dart';
import '../../../../../dominio/entidades/entidades.dart';

part 'inicio_sesion_state.dart';

class InicioSesionCubit extends Cubit<InicioSesionState> {
  InicioSesionCubit({required IniciarSesionCasoUso iniciarSesionCasoUso})
    : _iniciarSesionCasoUso = iniciarSesionCasoUso,
      super(const InicioSesionState());

  final IniciarSesionCasoUso _iniciarSesionCasoUso;

  void actualizarCorreo(String valor) {
    emit(
      state.copyWith(
        correo: valor,
        limpiarMensajeError: true,
        limpiarResultadoAutenticacion: true,
      ),
    );
  }

  void actualizarPassword(String valor) {
    emit(
      state.copyWith(
        password: valor,
        limpiarMensajeError: true,
        limpiarResultadoAutenticacion: true,
      ),
    );
  }

  Future<void> iniciarSesion() async {
    if (state.cargando) {
      return;
    }

    if (!state.correoValido) {
      emit(
        state.copyWith(
          mensajeError: 'Ingrese un correo electrónico válido',
          limpiarResultadoAutenticacion: true,
        ),
      );
      return;
    }

    if (state.password.trim().isEmpty) {
      emit(
        state.copyWith(
          mensajeError: 'Ingrese la contraseña',
          limpiarResultadoAutenticacion: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        cargando: true,
        limpiarMensajeError: true,
        limpiarResultadoAutenticacion: true,
      ),
    );

    try {
      final ResultadoAutenticacion resultado = await _iniciarSesionCasoUso.call(
        correo: state.correo.trim(),
        password: state.password,
      );

      emit(state.copyWith(cargando: false, resultadoAutenticacion: resultado));
    } catch (error) {
      emit(
        state.copyWith(
          cargando: false,
          mensajeError: _limpiarMensajeError(error),
        ),
      );
    }
  }

  String _limpiarMensajeError(Object error) {
    final String mensaje = error.toString().replaceFirst('Exception: ', '');
    final String mensajeMinuscula = mensaje.toLowerCase();

    if (mensajeMinuscula.contains('credenciales') ||
        mensajeMinuscula.contains('incorrect') ||
        mensajeMinuscula.contains('invalid') ||
        mensajeMinuscula.contains('no encontrado') ||
        mensajeMinuscula.contains('not found')) {
      return 'El correo o la contraseña son incorrectos.';
    }

    if (mensajeMinuscula.contains('conexión') ||
        mensajeMinuscula.contains('connection') ||
        mensajeMinuscula.contains('servidor') ||
        mensajeMinuscula.contains('server')) {
      return 'No pudimos conectar con el servidor. Intente nuevamente.';
    }

    return mensaje;
  }
}
