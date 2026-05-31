import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../dominio/casos_uso/mercado/consultar_detalle_activo_mercado_caso_uso.dart';
import '../../../../../../dominio/casos_uso/mercado/consultar_historial_activo_mercado_caso_uso.dart';
import '../../../../../../dominio/entidades/entidades.dart';

part 'detalle_activo_mercado_state.dart';

class DetalleActivoMercadoCubit extends Cubit<DetalleActivoMercadoState> {
  DetalleActivoMercadoCubit({
    required ConsultarDetalleActivoMercadoCasoUso consultarDetalleActivoCasoUso,
    required ConsultarHistorialActivoMercadoCasoUso consultarHistorialCasoUso,
  })  : _consultarDetalleActivoCasoUso = consultarDetalleActivoCasoUso,
        _consultarHistorialCasoUso = consultarHistorialCasoUso,
        super(const DetalleActivoMercadoState());

  final ConsultarDetalleActivoMercadoCasoUso _consultarDetalleActivoCasoUso;
  final ConsultarHistorialActivoMercadoCasoUso _consultarHistorialCasoUso;

  Future<void> cargarDetalle({
    required ActivoMercado activoInicial,
    required String token,
  }) async {
    emit(
      state.copyWith(
        cargando: true,
        limpiarMensajeError: true,
        activo: activoInicial,
      ),
    );

    try {
      final ActivoMercado activo = await _consultarDetalleActivoCasoUso(
        tipo: activoInicial.tipo,
        activoId: activoInicial.id,
        token: token,
      );

      final List<HistorialMercado> historial =
          await _consultarHistorialCasoUso(
        tipo: activoInicial.tipo,
        activoId: activoInicial.id,
        token: token,
      );

      emit(
        state.copyWith(
          cargando: false,
          activo: activo,
          historial: historial,
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
}