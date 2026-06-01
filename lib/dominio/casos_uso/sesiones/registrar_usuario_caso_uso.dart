
import '../../entidades/entidades.dart';
import '../../repositorios/sesiones/autenticacion_repositorio.dart';

class RegistrarUsuarioCasoUso {
  RegistrarUsuarioCasoUso({
    required AutenticacionRepositorio autenticacionRepositorio,
  }) : _autenticacionRepositorio = autenticacionRepositorio;

  final AutenticacionRepositorio _autenticacionRepositorio;

  Future<ResultadoAutenticacion> call({
    required String nombre,
    required String correo,
    required String password,
    String? username,
    double? capitalInicial,
  }) {
    return _autenticacionRepositorio.registrarUsuario(
      nombre: nombre,
      correo: correo,
      password: password,
      username: username,
      capitalInicial: capitalInicial,
    );
  }
}