import 'package:f1investor_frontend/datos/servicios/api/api_servicio.dart';
import '../../../dominio/entidades/entidades.dart';
import '../../dtos/dtos.dart';

class MercadoServicio {
  MercadoServicio({
    required ApiServicio apiServicio,
  }) : _apiServicio = apiServicio;

  final ApiServicio _apiServicio;

  Future<MercadoRespuestaDto> consultarMercado({
    required String token,
  }) async {
    final Map<String, dynamic> respuesta = await _apiServicio.get(
      '/api/dashboard/mercado',
      token: token,
    );

    return MercadoRespuestaDto.fromJson(respuesta);
  }

  Future<ActivoMercadoDto> consultarDetalleEquipo({
    required int id,
    required String token,
  }) async {
    final Map<String, dynamic> respuesta = await _apiServicio.get(
      '/api/equipos/$id',
      token: token,
    );

    return ActivoMercadoDto.fromJson(
      respuesta,
      tipo: TipoActivoMercado.equipo,
    );
  }

  Future<ActivoMercadoDto> consultarDetallePiloto({
    required int id,
    required String token,
  }) async {
    final Map<String, dynamic> respuesta = await _apiServicio.get(
      '/api/pilotos/$id',
      token: token,
    );

    return ActivoMercadoDto.fromJson(
      respuesta,
      tipo: TipoActivoMercado.piloto,
    );
  }

  Future<List<HistorialMercadoDto>> consultarHistorialActivo({
    required String tipoActivo,
    required int activoId,
    required String token,
  }) async {
    final Map<String, dynamic> respuesta = await _apiServicio.get(
      '/api/market-history/activo/$tipoActivo/$activoId',
      token: token,
    );

    final List<dynamic> registros =
        respuesta['registros'] as List<dynamic>? ?? <dynamic>[];

    return registros
        .whereType<Map<dynamic, dynamic>>()
        .map(
          (Map<dynamic, dynamic> item) => HistorialMercadoDto.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<CompraActivoRespuestaDto> comprarActivo({
    required CompraActivoSolicitudDto solicitud,
    required String token,
  }) async {
    final Map<String, dynamic> respuesta = await _apiServicio.post(
      '/api/inversiones/comprar',
      body: solicitud.toJson(),
      token: token,
    );

    return CompraActivoRespuestaDto.fromJson(respuesta);
  }
}