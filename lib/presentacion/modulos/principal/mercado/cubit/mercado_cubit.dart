import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dominio/casos_uso/mercado/consultar_mercado_caso_uso.dart';
import '../../../../../dominio/entidades/entidades.dart';

part 'mercado_state.dart';

class MercadoCubit extends Cubit<MercadoState> {
  MercadoCubit({
    required ConsultarMercadoCasoUso consultarMercadoCasoUso,
  })  : _consultarMercadoCasoUso = consultarMercadoCasoUso,
        super(const MercadoState());

  final ConsultarMercadoCasoUso _consultarMercadoCasoUso;

  Future<void> cargarMercado({
    required String token,
  }) async {
    if (state.cargando) {
      return;
    }

    emit(
      state.copyWith(
        cargando: true,
        limpiarMensajeError: true,
      ),
    );

    try {
      final MercadoRespuesta respuesta =
          await _consultarMercadoCasoUso(token: token);

      emit(
        state.copyWith(
          cargando: false,
          pilotos: respuesta.pilotos,
          equipos: respuesta.equipos,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          cargando: false,
          mensajeError: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  void limpiarMensajeError() {
    emit(
      state.copyWith(
        limpiarMensajeError: true,
      ),
    );
  }
}