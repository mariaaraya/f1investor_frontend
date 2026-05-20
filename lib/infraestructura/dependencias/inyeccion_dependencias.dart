import 'package:f1investor_frontend/datos/repositorios/sesiones/autenticacion_repositorio_impl.dart';
import 'package:f1investor_frontend/datos/servicios/api/api_servicio.dart';
import 'package:f1investor_frontend/datos/servicios/sesiones/autenticacion_servicio.dart';
import 'package:f1investor_frontend/dominio/casos_uso/sesiones/iniciar_sesion_caso_uso.dart';
import 'package:f1investor_frontend/dominio/casos_uso/sesiones/registrar_usuario_caso_uso.dart';
import 'package:f1investor_frontend/dominio/repositorios/sesiones/autenticacion_repositorio.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> configurarDependencias() async {
  sl.registerLazySingleton<ApiServicio>(
    () => ApiServicio(),
  );

  sl.registerLazySingleton<AutenticacionServicio>(
    () => AutenticacionServicio(
      apiServicio: sl<ApiServicio>(),
    ),
  );

  sl.registerLazySingleton<AutenticacionRepositorio>(
    () => AutenticacionRepositorioImplementacion(
      autenticacionServicio: sl<AutenticacionServicio>(),
    ),
  );

  sl.registerLazySingleton<IniciarSesionCasoUso>(
    () => IniciarSesionCasoUso(
      autenticacionRepositorio: sl<AutenticacionRepositorio>(),
    ),
  );

  sl.registerLazySingleton<RegistrarUsuarioCasoUso>(
    () => RegistrarUsuarioCasoUso(
      autenticacionRepositorio: sl<AutenticacionRepositorio>(),
    ),
  );
}