import 'package:shared_preferences/shared_preferences.dart';

import '../../dominio/entidades/entidades.dart';

class TemaPreferencias {
  static const String _claveTema = 'tema_aplicacion';

  Future<TemaAplicacion> obtenerTema() async {
    final SharedPreferences preferencias =
        await SharedPreferences.getInstance();

    final String? valor = preferencias.getString(_claveTema);

    return TemaAplicacion.values.firstWhere(
      (TemaAplicacion tema) => tema.name == valor,
      orElse: () => TemaAplicacion.sistema,
    );
  }

  Future<void> guardarTema(TemaAplicacion tema) async {
    final SharedPreferences preferencias =
        await SharedPreferences.getInstance();

    await preferencias.setString(_claveTema, tema.name);
  }
}