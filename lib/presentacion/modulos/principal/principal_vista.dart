import 'package:flutter/material.dart';

import '../../../dominio/entidades/entidades.dart';
import 'cartera/carerta_vista.dart';
import 'inicio/inicio_vista.dart';
import 'mercado/mercado_vista.dart';
import 'mercado/resultado_compra_mercado.dart';
import 'resultados/resultados_vista.dart';
import 'perfil/perfil_vista.dart';

class PrincipalVista extends StatefulWidget {
  const PrincipalVista({super.key, required this.resultadoAutenticacion});

  static const String nombre = 'principal';
  static const String ruta = '/principal';

  final ResultadoAutenticacion resultadoAutenticacion;

  @override
  State<PrincipalVista> createState() => _PrincipalVistaState();
}

class _PrincipalVistaState extends State<PrincipalVista> {
  int _indiceSeleccionado = 0;

  late ResultadoAutenticacion _resultadoAutenticacion;

  @override
  void initState() {
    super.initState();
    _resultadoAutenticacion = widget.resultadoAutenticacion;
  }

  void _cambiarVista(int indice) {
    setState(() {
      _indiceSeleccionado = indice;
    });
  }

  void _actualizarUsuarioPorCompra(ResultadoCompraMercado resultadoCompra) {
    final Usuario usuarioActual = _resultadoAutenticacion.usuario;

    final double nuevoValorCartera =
        usuarioActual.valorPortfolio + resultadoCompra.totalCompra;

    final double nuevoPatrimonioTotal =
        resultadoCompra.capitalRestante + nuevoValorCartera;

    final Usuario usuarioActualizado = Usuario(
      id: usuarioActual.id,
      nombre: usuarioActual.nombre,
      username: usuarioActual.username,
      correo: usuarioActual.correo,
      capitalInicial: usuarioActual.capitalInicial,
      capital: resultadoCompra.capitalRestante,
      valorPortfolio: nuevoValorCartera,
      patrimonioTotal: nuevoPatrimonioTotal,
      rol: usuarioActual.rol,
      activo: usuarioActual.activo,
      creadoEn: usuarioActual.creadoEn,
      ultimoAcceso: usuarioActual.ultimoAcceso,
    );

    setState(() {
      _resultadoAutenticacion = ResultadoAutenticacion(
        exitoso: _resultadoAutenticacion.exitoso,
        mensaje: _resultadoAutenticacion.mensaje,
        token: _resultadoAutenticacion.token,
        usuario: usuarioActualizado,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> vistas = <Widget>[
      InicioVista(resultadoAutenticacion: _resultadoAutenticacion),
      MercadoVista(
        resultadoAutenticacion: _resultadoAutenticacion,
        onCompraRealizada: _actualizarUsuarioPorCompra,
      ),
      const CarteraVista(),
      const ResultadosVista(),
      PerfilVista(resultadoAutenticacion: _resultadoAutenticacion),
    ];

    return Scaffold(
      body: IndexedStack(index: _indiceSeleccionado, children: vistas),
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