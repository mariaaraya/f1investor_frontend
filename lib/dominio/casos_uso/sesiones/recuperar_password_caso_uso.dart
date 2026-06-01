import '../../repositorios/sesiones/autenticacion_repositorio.dart';

class RecuperarPasswordCasoUso {
  RecuperarPasswordCasoUso({
    required AutenticacionRepositorio autenticacionRepositorio,
  }) : _autenticacionRepositorio = autenticacionRepositorio;

  final AutenticacionRepositorio _autenticacionRepositorio;

  Future<String> call({required String correo, required String nuevoPassword}) {
    return _autenticacionRepositorio.recuperarPassword(
      correo: correo,
      nuevoPassword: nuevoPassword,
    );
  }
}
