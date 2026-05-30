import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:f1investor_frontend/presentacion/comun/validadores/validadores_formulario.dart';

import '../../../../../dominio/casos_uso/sesiones/registrar_usuario_caso_uso.dart';
import '../../../../../dominio/entidades/entidades.dart';

part 'registro_state.dart';

class RegistroCubit extends Cubit<RegistroState> {
  RegistroCubit({required RegistrarUsuarioCasoUso registrarUsuarioCasoUso})
    : _registrarUsuarioCasoUso = registrarUsuarioCasoUso,
      super(const RegistroState());

  final RegistrarUsuarioCasoUso _registrarUsuarioCasoUso;

  void actualizarNombre(String valor) {
    emit(
      state.copyWith(
        nombre: valor,
        limpiarMensajeError: true,
        limpiarMensajeExito: true,
      ),
    );
  }

  void actualizarCorreo(String valor) {
    emit(
      state.copyWith(
        correo: valor,
        limpiarMensajeError: true,
        limpiarMensajeExito: true,
      ),
    );
  }

  void actualizarPassword(String valor) {
    emit(
      state.copyWith(
        password: valor,
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

  Future<void> registrarUsuario() async {
    if (state.cargando) {
      return;
    }

    if (state.nombre.trim().isEmpty) {
      emit(
        state.copyWith(
          mensajeError: 'Ingrese su nombre',
          limpiarMensajeExito: true,
        ),
      );
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
      final ResultadoAutenticacion resultado = await _registrarUsuarioCasoUso
          .call(
            nombre: state.nombre.trim(),
            correo: state.correo.trim(),
            password: state.password,
          );

      emit(
        state.copyWith(
          cargando: false,
          mensajeExito: resultado.mensaje.isNotEmpty
              ? resultado.mensaje
              : 'Usuario registrado correctamente',
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

    if ((mensajeMinuscula.contains('correo') ||
            mensajeMinuscula.contains('email')) &&
        (mensajeMinuscula.contains('registr') ||
            mensajeMinuscula.contains('existe') ||
            mensajeMinuscula.contains('already'))) {
      return 'Ya existe una cuenta registrada con ese correo electrónico.';
    }

    if (mensajeMinuscula.contains('duplicate') ||
        mensajeMinuscula.contains('duplicado')) {
      return 'Ya existe una cuenta registrada con esos datos.';
    }

    if (mensajeMinuscula.contains('conexión') ||
        mensajeMinuscula.contains('connection') ||
        mensajeMinuscula.contains('servidor') ||
        mensajeMinuscula.contains('server')) {
      return 'No pudimos completar el registro. Intente nuevamente.';
    }

    return mensaje;
  }
}
