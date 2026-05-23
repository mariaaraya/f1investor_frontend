import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../dominio/casos_uso/sesiones/iniciar_sesion_caso_uso.dart';
import '../../../../../dominio/entidades/entidades.dart';

part 'inicio_sesion_state.dart';

class InicioSesionCubit extends Cubit<InicioSesionState> {
  InicioSesionCubit({
    required IniciarSesionCasoUso iniciarSesionCasoUso,
  })  : _iniciarSesionCasoUso = iniciarSesionCasoUso,
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
    if (!state.formularioValido || state.cargando) {
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
      final ResultadoAutenticacion resultado =
          await _iniciarSesionCasoUso.call(
        correo: state.correo.trim(),
        password: state.password,
      );

      emit(
        state.copyWith(
          cargando: false,
          resultadoAutenticacion: resultado,
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
    return error.toString().replaceFirst('Exception: ', '');
  }
}