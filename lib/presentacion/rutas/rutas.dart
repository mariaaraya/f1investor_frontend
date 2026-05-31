import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../dominio/casos_uso/sesiones/iniciar_sesion_caso_uso.dart';
import '../../dominio/casos_uso/sesiones/recuperar_password_caso_uso.dart';
import '../../dominio/casos_uso/sesiones/registrar_usuario_caso_uso.dart';
import '../../dominio/entidades/entidades.dart';
import '../../infraestructura/dependencias/inyeccion_dependencias.dart';
import '../modulos/autenticacion/inicio_sesion/cubit/inicio_sesion_cubit.dart';
import '../modulos/autenticacion/inicio_sesion/inicio_sesion_vista.dart';
import '../modulos/autenticacion/recuperar_password/cubit/recuperar_password_cubit.dart';
import '../modulos/autenticacion/recuperar_password/recuperar_password_vista.dart';
import '../modulos/autenticacion/registro/cubit/registro_cubit.dart';
import '../modulos/autenticacion/registro/registro_vista.dart';
import '../modulos/principal/principal_vista.dart';

class Rutas {
  Rutas._();

  static final GoRouter router = GoRouter(
    initialLocation: InicioSesionVista.ruta,
    routes: <RouteBase>[
      GoRoute(
        name: InicioSesionVista.nombre,
        path: InicioSesionVista.ruta,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider<InicioSesionCubit>(
            create: (_) => InicioSesionCubit(
              iniciarSesionCasoUso: sl<IniciarSesionCasoUso>(),
            ),
            child: const InicioSesionVista(),
          );
        },
      ),
      GoRoute(
        name: RegistroVista.nombre,
        path: RegistroVista.ruta,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider<RegistroCubit>(
            create: (_) => RegistroCubit(
              registrarUsuarioCasoUso: sl<RegistrarUsuarioCasoUso>(),
            ),
            child: const RegistroVista(),
          );
        },
      ),
      GoRoute(
        name: RecuperarPasswordVista.nombre,
        path: RecuperarPasswordVista.ruta,
        builder: (BuildContext context, GoRouterState state) {
          final bool vieneDesdePerfil = state.extra == true;

          return BlocProvider<RecuperarPasswordCubit>(
            create: (_) => RecuperarPasswordCubit(
              recuperarPasswordCasoUso: sl<RecuperarPasswordCasoUso>(),
            ),
            child: RecuperarPasswordVista(vieneDesdePerfil: vieneDesdePerfil),
          );
        },
      ),
      GoRoute(
        name: PrincipalVista.nombre,
        path: PrincipalVista.ruta,
        builder: (BuildContext context, GoRouterState state) {
          final Object? extra = state.extra;

          if (extra is! ResultadoAutenticacion) {
            return BlocProvider<InicioSesionCubit>(
              create: (_) => InicioSesionCubit(
                iniciarSesionCasoUso: sl<IniciarSesionCasoUso>(),
              ),
              child: const InicioSesionVista(),
            );
          }

          return PrincipalVista(resultadoAutenticacion: extra);
        },
      ),
    ],
  );
}
