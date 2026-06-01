import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dominio/casos_uso/cartera/obtener_cartera_caso_uso.dart';
import '../../../../../dominio/casos_uso/cartera/vender_activo_caso_uso.dart';
import '../../../../../dominio/entidades/entidades.dart';

part 'cartera_state.dart';

class CarteraCubit extends Cubit<CarteraState> {
  CarteraCubit({
    required ObtenerCarteraCasoUso obtenerCarteraCasoUso,
    required VenderActivoCasoUso venderActivoCasoUso,
  })  : _obtenerCarteraCasoUso = obtenerCarteraCasoUso,
        _venderActivoCasoUso = venderActivoCasoUso,
        super(const CarteraState());

  final ObtenerCarteraCasoUso _obtenerCarteraCasoUso;
  final VenderActivoCasoUso _venderActivoCasoUso;

  Future<void> cargarCartera({
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
      final Cartera cartera = await _obtenerCarteraCasoUso(
        token: token,
      );

      emit(
        state.copyWith(
          cargando: false,
          cartera: cartera,
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

  Future<void> venderActivo({
    required String token,
    required ItemCartera item,
  }) async {
    if (state.vendiendo) {
      return;
    }

    emit(
      state.copyWith(
        vendiendo: true,
        limpiarMensajeError: true,
      ),
    );

    try {
      await _venderActivoCasoUso(
        token: token,
        tipoActivo: item.tipoActivo,
        activoId: item.activoId,
        cantidad: item.cantidad,
      );

      final Cartera cartera = await _obtenerCarteraCasoUso(
        token: token,
      );

      emit(
        state.copyWith(
          vendiendo: false,
          cartera: cartera,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          vendiendo: false,
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