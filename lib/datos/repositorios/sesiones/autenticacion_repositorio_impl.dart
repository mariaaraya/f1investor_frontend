import 'package:f1investor_frontend/datos/servicios/sesiones/autenticacion_servicio.dart';
import 'package:f1investor_frontend/dominio/repositorios/sesiones/autenticacion_repositorio.dart';

import '../../../dominio/entidades/entidades.dart';
import '../../dtos/dtos.dart';

class AutenticacionRepositorioImplementacion
    implements AutenticacionRepositorio {
  AutenticacionRepositorioImplementacion({
    required AutenticacionServicio autenticacionServicio,
  }) : _autenticacionServicio = autenticacionServicio;

  final AutenticacionServicio _autenticacionServicio;

  @override
  Future<ResultadoAutenticacion> iniciarSesion({
    required String correo,
    required String password,
  }) async {
    final InicioSesionSolicitudDto solicitud = InicioSesionSolicitudDto(
      correo: correo,
      password: password,
    );

    final respuesta = await _autenticacionServicio.iniciarSesion(solicitud);

    return respuesta.toEntity();
  }

  @override
  Future<ResultadoAutenticacion> registrarUsuario({
    required String nombre,
    required String correo,
    required String password,
    String? username,
    double? capitalInicial,
  }) async {
    final RegistroUsuarioSolicitudDto solicitud = RegistroUsuarioSolicitudDto(
      nombre: nombre,
      correo: correo,
      password: password,
      username: username,
      capitalInicial: capitalInicial,
    );

    final respuesta = await _autenticacionServicio.registrarUsuario(solicitud);

    return respuesta.toEntity();
  }

  @override
  Future<String> recuperarPassword({
    required String correo,
    required String nuevoPassword,
  }) async {
    final RecuperarPasswordSolicitudDto solicitud =
        RecuperarPasswordSolicitudDto(
          correo: correo,
          nuevoPassword: nuevoPassword,
        );

    final respuesta = await _autenticacionServicio.recuperarPassword(solicitud);

    return respuesta.mensaje;
  }
}
