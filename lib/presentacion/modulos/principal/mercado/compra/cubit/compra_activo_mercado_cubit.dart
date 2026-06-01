import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../dominio/casos_uso/mercado/comprar_activo_caso_uso.dart';
import '../../../../../../dominio/entidades/entidades.dart';

part 'compra_activo_mercado_state.dart';

class CompraActivoMercadoCubit extends Cubit<CompraActivoMercadoState> {
  CompraActivoMercadoCubit({
    required ComprarActivoCasoUso comprarActivoCasoUso,
  })  : _comprarActivoCasoUso = comprarActivoCasoUso,
        super(const CompraActivoMercadoState());

  final ComprarActivoCasoUso _comprarActivoCasoUso;

  Future<void> comprarActivo({
    required ActivoMercado activo,
    required double cantidad,
    required double capitalDisponible,
    required String token,
  }) async {
    if (state.cargando) {
      return;
    }

    if (cantidad <= 0) {
      emit(
        state.copyWith(
          mensajeError: 'La cantidad debe ser mayor a cero',
          limpiarMensajeExito: true,
        ),
      );
      return;
    }

    final double total = activo.valorMercado * cantidad;

    if (total > capitalDisponible) {
      emit(
        state.copyWith(
          mensajeError: 'Capital insuficiente para realizar la compra',
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
        compraRealizada: false,
      ),
    );

    try {
      final CompraActivoRespuesta respuesta = await _comprarActivoCasoUso(
        tipo: activo.tipo,
        activoId: activo.id,
        cantidad: cantidad,
        token: token,
      );

      emit(
        state.copyWith(
          cargando: false,
          compraRealizada: true,
          mensajeExito: respuesta.mensaje.isNotEmpty
              ? respuesta.mensaje
              : 'Compra realizada correctamente',
          capitalRestante: respuesta.capitalRestante,
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
    emit(state.copyWith(limpiarMensajeError: true));
  }

  void limpiarMensajeExito() {
    emit(
      state.copyWith(
        limpiarMensajeExito: true,
        compraRealizada: false,
      ),
    );
  }
}