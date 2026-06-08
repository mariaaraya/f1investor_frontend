import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dominio/entidades/entidades.dart';
import 'infraestructura/dependencias/inyeccion_dependencias.dart';
import 'presentacion/rutas/rutas.dart';
import 'presentacion/tema/cubit/tema_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configurarDependencias();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TemaCubit>(
      create: (_) => sl<TemaCubit>()..cargarTema(),
      child: BlocBuilder<TemaCubit, TemaState>(
        builder: (BuildContext context, TemaState state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'F1 Investor',
            routerConfig: Rutas.router,
            themeMode: state.tema.themeMode,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.red,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.red,
                brightness: Brightness.dark,
              ),
              scaffoldBackgroundColor: const Color(0xFF080808),
              useMaterial3: true,
            ),
          );
        },
      ),
    );
  }
}