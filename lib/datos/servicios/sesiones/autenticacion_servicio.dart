import 'package:f1investor_frontend/datos/servicios/api/api_servicio.dart';

import '../../dtos/dtos.dart';

class AutenticacionServicio {
  AutenticacionServicio({
    required ApiServicio apiServicio,
  }) : _apiServicio = apiServicio;

  final ApiServicio _apiServicio;

  Future<AutenticacionRespuestaDto> iniciarSesion(
    InicioSesionSolicitudDto solicitud,
  ) async {
    final Map<String, dynamic> respuesta = await _apiServicio.post(
      '/api/usuarios/login',
      body: solicitud.toJson(),
    );

    return AutenticacionRespuestaDto.fromJson(respuesta);
  }

  Future<AutenticacionRespuestaDto> registrarUsuario(
    RegistroUsuarioSolicitudDto solicitud,
  ) async {
    final Map<String, dynamic> respuesta = await _apiServicio.post(
      '/api/usuarios/registro',
      body: solicitud.toJson(),
    );

    return AutenticacionRespuestaDto.fromJson(respuesta);
  }

  Future<RecuperarPasswordRespuestaDto> recuperarPassword(
  RecuperarPasswordSolicitudDto solicitud,
) async {
  final Map<String, dynamic> respuesta = await _apiServicio.patch(
    '/api/usuarios/recuperar-password',
    body: solicitud.toJson(),
  );

  return RecuperarPasswordRespuestaDto.fromJson(respuesta);
}
}