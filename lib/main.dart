import 'package:flutter/material.dart';

import 'infraestructura/dependencias/inyeccion_dependencias.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configurarDependencias();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('F1 INVESTOR! mi rama'),
        ),
      ),
    );
  }
}