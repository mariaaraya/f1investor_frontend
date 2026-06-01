import 'package:flutter/material.dart';

import 'infraestructura/dependencias/inyeccion_dependencias.dart';
import 'presentacion/rutas/rutas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configurarDependencias();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'F1 Investor',
      routerConfig: Rutas.router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
        ),
        useMaterial3: true,
      ),
    );
  }
}