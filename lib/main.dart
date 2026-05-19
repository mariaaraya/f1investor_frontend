import 'package:flutter/material.dart';

import 'datos/servicios/api_servicio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiServicio = ApiServicio();

  try {
    final respuesta = await apiServicio.get('/');
    debugPrint('Conexión backend exitosa: $respuesta');
  } catch (error) {
    debugPrint('Error conectando con backend: $error');
  }

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