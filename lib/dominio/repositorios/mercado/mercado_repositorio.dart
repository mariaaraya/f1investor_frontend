import '../../entidades/entidades.dart';

abstract class MercadoRepositorio {
  Future<MercadoRespuesta> consultarMercado({
    required String token,
  });

  Future<ActivoMercado> consultarDetalleActivo({
    required TipoActivoMercado tipo,
    required int activoId,
    required String token,
  });

  Future<List<HistorialMercado>> consultarHistorialActivo({
    required TipoActivoMercado tipo,
    required int activoId,
    required String token,
  });

  Future<CompraActivoRespuesta> comprarActivo({
    required TipoActivoMercado tipo,
    required int activoId,
    required double cantidad,
    required String token,
  });
}