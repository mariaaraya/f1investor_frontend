import 'package:f1investor_frontend/datos/servicios/api/api_servicio.dart';

import '../../dtos/dtos.dart';

class CarteraServicio {
  CarteraServicio({
    required ApiServicio apiServicio,
  }) : _apiServicio = apiServicio;

  final ApiServicio _apiServicio;

  Future<CarteraDto> obtenerCartera({
    required String token,
  }) async {
    final Map<String, dynamic> respuesta = await _apiServicio.get(
      '/api/inversiones/portfolio',
      token: token,
    );

    return CarteraDto.fromJson(respuesta);
  }

  Future<VenderActivoRespuestaDto> venderActivo({
    required String token,
    required VenderActivoSolicitudDto solicitud,
  }) async {
    final Map<String, dynamic> respuesta = await _apiServicio.post(
      '/api/inversiones/vender',
      token: token,
      body: solicitud.toJson(),
    );

    return VenderActivoRespuestaDto.fromJson(respuesta);
  }
}