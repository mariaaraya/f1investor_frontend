import 'package:f1investor_frontend/dominio/repositorios/sesiones/autenticacion_repositorio.dart';
import '../../entidades/entidades.dart';

class IniciarSesionCasoUso {
  IniciarSesionCasoUso({
    required AutenticacionRepositorio autenticacionRepositorio,
  }) : _autenticacionRepositorio = autenticacionRepositorio;

  final AutenticacionRepositorio _autenticacionRepositorio;

  Future<ResultadoAutenticacion> call({
    required String correo,
    required String password,
  }) {
    return _autenticacionRepositorio.iniciarSesion(
      correo: correo,
      password: password,
    );
  }
}