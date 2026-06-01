import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:f1investor_frontend/presentacion/comun/validadores/validadores_formulario.dart';

import '../../../../../dominio/casos_uso/sesiones/recuperar_password_caso_uso.dart';

part 'recuperar_password_state.dart';

class RecuperarPasswordCubit extends Cubit<RecuperarPasswordState> {
  RecuperarPasswordCubit({
    required RecuperarPasswordCasoUso recuperarPasswordCasoUso,
  })  : _recuperarPasswordCasoUso = recuperarPasswordCasoUso,
        super(const RecuperarPasswordState());

  final RecuperarPasswordCasoUso _recuperarPasswordCasoUso;

  void actualizarCorreo(String valor) {
    emit(
      state.copyWith(
        correo: valor,
        limpiarMensajeError: true,
        limpiarMensajeExito: true,
      ),
    );
  }

  void actualizarNuevoPassword(String valor) {
    emit(
      state.copyWith(
        nuevoPassword: valor,
        limpiarMensajeError: true,
        limpiarMensajeExito: true,
      ),
    );
  }

  void actualizarConfirmarPassword(String valor) {
    emit(
      state.copyWith(
        confirmarPassword: valor,
        limpiarMensajeError: true,
        limpiarMensajeExito: true,
      ),
    );
  }

  Future<void> recuperarPassword() async {
    if (state.cargando) {
      return;
    }

    if (!state.correoValido) {
      emit(
        state.copyWith(
          mensajeError: 'Ingrese un correo electrónico válido',
          limpiarMensajeExito: true,
        ),
      );
      return;
    }

    if (!state.passwordValida) {
      emit(
        state.copyWith(
          mensajeError:
              'La contraseña debe tener mínimo 8 caracteres, una mayúscula, una minúscula, un número y un símbolo',
          limpiarMensajeExito: true,
        ),
      );
      return;
    }

    if (!state.passwordsCoinciden) {
      emit(
        state.copyWith(
          mensajeError: 'Las contraseñas no coinciden',
          limpiarMensajeExito: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        cargando: true,
        limpiarMensajeError: true,
        limpiarMensajeExito: true,
      ),
    );

    try {
      final String mensaje = await _recuperarPasswordCasoUso.call(
        correo: state.correo.trim(),
        nuevoPassword: state.nuevoPassword,
      );

      emit(
        state.copyWith(
          cargando: false,
          mensajeExito: mensaje.isNotEmpty
              ? mensaje
              : 'Contraseña actualizada correctamente',
        ),
      );
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

    if (mensajeMinuscula.contains('no existe') ||
        mensajeMinuscula.contains('not found')) {
      return 'No existe una cuenta registrada con ese correo electrónico.';
    }

    if (mensajeMinuscula.contains('conexión') ||
        mensajeMinuscula.contains('connection') ||
        mensajeMinuscula.contains('servidor') ||
        mensajeMinuscula.contains('server')) {
      return 'No pudimos actualizar la contraseña. Intente nuevamente.';
    }

    return mensaje;
  }
}