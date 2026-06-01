import 'package:f1investor_frontend/dominio/casos_uso/cartera/obtener_cartera_caso_uso.dart';
import 'package:f1investor_frontend/dominio/casos_uso/cartera/vender_activo_caso_uso.dart';
import 'package:f1investor_frontend/infraestructura/dependencias/inyeccion_dependencias.dart';
import 'package:f1investor_frontend/presentacion/modulos/principal/cartera/cubit/cartera_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  late final CarteraCubit _carteraCubit;

  int _mercadoRefreshKey = 0;
  int _carteraRefreshKey = 0;
  int _inicioRefreshKey = 0;
  int _resultadosRefreshKey = 0;

  @override
  void initState() {
    super.initState();

    _resultadoAutenticacion = widget.resultadoAutenticacion;

    _carteraCubit = CarteraCubit(
      obtenerCarteraCasoUso: sl<ObtenerCarteraCasoUso>(),
      venderActivoCasoUso: sl<VenderActivoCasoUso>(),
    );

    _cargarCartera();
  }

  @override
  void dispose() {
    _carteraCubit.close();
    super.dispose();
  }

  void _cargarCartera() {
    _carteraCubit.cargarCartera(
      token: _resultadoAutenticacion.token,
    );
  }

  void _refrescarDatosDespuesDeSimulacion() {
    _cargarCartera();

    setState(() {
      _mercadoRefreshKey++;
      _carteraRefreshKey++;
      _inicioRefreshKey++;
      _resultadosRefreshKey++;
    });
  }

  void _cambiarVista(int indice) {
    setState(() {
      _indiceSeleccionado = indice;
    });

    if (indice == 1) {
      setState(() {
        _mercadoRefreshKey++;
      });
    }

    if (indice == 2) {
      _cargarCartera();

      setState(() {
        _carteraRefreshKey++;
      });
    }

    if (indice == 3) {
      setState(() {
        _resultadosRefreshKey++;
      });
    }
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

      _carteraRefreshKey++;
      _inicioRefreshKey++;
    });

    _cargarCartera();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> vistas = <Widget>[
      InicioVista(
        key: ValueKey<int>(_inicioRefreshKey),
        resultadoAutenticacion: _resultadoAutenticacion,
        onCarreraSimulada: _refrescarDatosDespuesDeSimulacion,
      ),
      MercadoVista(
        key: ValueKey<int>(_mercadoRefreshKey),
        resultadoAutenticacion: _resultadoAutenticacion,
        onCompraRealizada: _actualizarUsuarioPorCompra,
      ),
      BlocProvider<CarteraCubit>.value(
        key: ValueKey<int>(_carteraRefreshKey),
        value: _carteraCubit,
        child: CarteraVista(resultadoAutenticacion: _resultadoAutenticacion),
      ),
      ResultadosVista(
        key: ValueKey<int>(_resultadosRefreshKey),
        resultadoAutenticacion: _resultadoAutenticacion,
      ),
      PerfilVista(resultadoAutenticacion: _resultadoAutenticacion),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _indiceSeleccionado,
        children: vistas,
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