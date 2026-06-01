import '../../entidades/entidades.dart';

abstract class AutenticacionRepositorio {
  Future<ResultadoAutenticacion> iniciarSesion({
    required String correo,
    required String password,
  });

  Future<ResultadoAutenticacion> registrarUsuario({
    required String nombre,
    required String correo,
    required String password,
    String? username,
    double? capitalInicial,
  });

  Future<String> recuperarPassword({
    required String correo,
    required String nuevoPassword,
  });
}
