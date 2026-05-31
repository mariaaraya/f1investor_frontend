import 'package:f1investor_frontend/datos/repositorios/mercado/mercado_repositorio_impl.dart';
import 'package:f1investor_frontend/datos/repositorios/sesiones/autenticacion_repositorio_impl.dart';
import 'package:f1investor_frontend/datos/servicios/api/api_servicio.dart';
import 'package:f1investor_frontend/datos/servicios/mercado/mercado_servicio.dart';
import 'package:f1investor_frontend/datos/servicios/sesiones/autenticacion_servicio.dart';
import 'package:f1investor_frontend/dominio/casos_uso/mercado/consultar_detalle_activo_mercado_caso_uso.dart';
import 'package:f1investor_frontend/dominio/casos_uso/mercado/consultar_historial_activo_mercado_caso_uso.dart';
import 'package:f1investor_frontend/dominio/casos_uso/mercado/consultar_mercado_caso_uso.dart';
import 'package:f1investor_frontend/dominio/casos_uso/sesiones/iniciar_sesion_caso_uso.dart';
import 'package:f1investor_frontend/dominio/casos_uso/sesiones/recuperar_password_caso_uso.dart';
import 'package:f1investor_frontend/dominio/casos_uso/sesiones/registrar_usuario_caso_uso.dart';
import 'package:f1investor_frontend/dominio/repositorios/mercado/mercado_repositorio.dart';
import 'package:f1investor_frontend/dominio/repositorios/sesiones/autenticacion_repositorio.dart';
import 'package:get_it/get_it.dart';

import '../../dominio/casos_uso/mercado/comprar_activo_caso_uso.dart';

final GetIt sl = GetIt.instance;

Future<void> configurarDependencias() async {
  sl.registerLazySingleton<ApiServicio>(() => ApiServicio());

  sl.registerLazySingleton<AutenticacionServicio>(
    () => AutenticacionServicio(apiServicio: sl<ApiServicio>()),
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

  sl.registerLazySingleton<RecuperarPasswordCasoUso>(
    () => RecuperarPasswordCasoUso(
      autenticacionRepositorio: sl<AutenticacionRepositorio>(),
    ),
  );

  sl.registerLazySingleton<MercadoServicio>(
    () => MercadoServicio(apiServicio: sl<ApiServicio>()),
  );

  sl.registerLazySingleton<MercadoRepositorio>(
    () => MercadoRepositorioImplementacion(
      mercadoServicio: sl<MercadoServicio>(),
    ),
  );

  sl.registerLazySingleton<ConsultarMercadoCasoUso>(
    () => ConsultarMercadoCasoUso(mercadoRepositorio: sl<MercadoRepositorio>()),
  );

  sl.registerLazySingleton<ConsultarDetalleActivoMercadoCasoUso>(
    () => ConsultarDetalleActivoMercadoCasoUso(
      mercadoRepositorio: sl<MercadoRepositorio>(),
    ),
  );

  sl.registerLazySingleton<ConsultarHistorialActivoMercadoCasoUso>(
    () => ConsultarHistorialActivoMercadoCasoUso(
      mercadoRepositorio: sl<MercadoRepositorio>(),
    ),
  );

  sl.registerLazySingleton<ComprarActivoCasoUso>(
    () => ComprarActivoCasoUso(mercadoRepositorio: sl<MercadoRepositorio>()),
  );
}
