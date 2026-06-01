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

  void _emitirSeguro(RegistroState nuevoEstado) {
    if (!isClosed) {
      emit(nuevoEstado);
    }
  }

  void actualizarNombre(String valor) {
    _emitirSeguro(
      state.copyWith(
        nombre: valor,
        limpiarMensajeError: true,
        limpiarMensajeExito: true,
      ),
    );
  }

  void actualizarCorreo(String valor) {
    _emitirSeguro(
      state.copyWith(
        correo: valor,
        limpiarMensajeError: true,
        limpiarMensajeExito: true,
      ),
    );
  }

  void actualizarPassword(String valor) {
    _emitirSeguro(
      state.copyWith(
        password: valor,
        limpiarMensajeError: true,
        limpiarMensajeExito: true,
      ),
    );
  }

  void actualizarConfirmarPassword(String valor) {
    _emitirSeguro(
      state.copyWith(
        confirmarPassword: valor,
        limpiarMensajeError: true,
        limpiarMensajeExito: true,
      ),
    );
  }

  Future<void> registrarUsuario() async {
    if (isClosed || state.cargando) {
      return;
    }

    if (state.nombre.trim().isEmpty) {
      _emitirSeguro(
        state.copyWith(
          mensajeError: 'Ingrese su nombre',
          limpiarMensajeExito: true,
        ),
      );
      return;
    }

    if (!state.correoValido) {
      _emitirSeguro(
        state.copyWith(
          mensajeError: 'Ingrese un correo electrónico válido',
          limpiarMensajeExito: true,
        ),
      );
      return;
    }

    if (!state.passwordValida) {
      _emitirSeguro(
        state.copyWith(
          mensajeError:
              'La contraseña debe tener mínimo 8 caracteres, una mayúscula, una minúscula, un número y un símbolo',
          limpiarMensajeExito: true,
        ),
      );
      return;
    }

    if (!state.passwordsCoinciden) {
      _emitirSeguro(
        state.copyWith(
          mensajeError: 'Las contraseñas no coinciden',
          limpiarMensajeExito: true,
        ),
      );
      return;
    }

    _emitirSeguro(
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

      if (isClosed) {
        return;
      }

      _emitirSeguro(
        state.copyWith(
          cargando: false,
          mensajeExito: resultado.mensaje.isNotEmpty
              ? resultado.mensaje
              : 'Usuario registrado correctamente',
        ),
      );
    } catch (error) {
      if (isClosed) {
        return;
      }

      _emitirSeguro(
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