import 'package:flutter/material.dart';

import 'cartera/carerta_vista.dart';
import 'inicio/inicio_vista.dart';
import 'mercado/mercado_vista.dart';
import 'resultados/resultados_vista.dart';
import 'perfil/perfil_vista.dart';

class PrincipalVista extends StatefulWidget {
  const PrincipalVista({super.key});

  static const String nombre = 'principal';
  static const String ruta = '/principal';

  @override
  State<PrincipalVista> createState() => _PrincipalVistaState();
}

class _PrincipalVistaState extends State<PrincipalVista> {
  int _indiceSeleccionado = 0;

  final List<Widget> _vistas = const <Widget>[
    InicioVista(),
    MercadoVista(),
    CarteraVista(),
    ResultadosVista(),
    PerfilVista(),
  ];

  void _cambiarVista(int indice) {
    setState(() {
      _indiceSeleccionado = indice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indiceSeleccionado,
        children: _vistas,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceSeleccionado,
        onTap: _cambiarVista,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            activeIcon: Icon(Icons.storefront),
            label: 'Mercado',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Cartera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            activeIcon: Icon(Icons.emoji_events),
            label: 'Resultados',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}