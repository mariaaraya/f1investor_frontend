import 'package:f1investor_frontend/dominio/repositorios/sesiones/autenticacion_repositorio.dart';
import '../../entidades/entidades.dart';

class RegistrarUsuarioCasoUso {
  RegistrarUsuarioCasoUso({
    required AutenticacionRepositorio autenticacionRepositorio,
  }) : _autenticacionRepositorio = autenticacionRepositorio;

  final AutenticacionRepositorio _autenticacionRepositorio;

  Future<ResultadoAutenticacion> call({
    required String nombre,
    required String correo,
    required String password,
  }) {
    return _autenticacionRepositorio.registrarUsuario(
      nombre: nombre,
      correo: correo,
      password: password,
    );
  }
}