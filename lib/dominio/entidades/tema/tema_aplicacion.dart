import 'package:flutter/material.dart';

enum TemaAplicacion {
  sistema,
  claro,
  oscuro,
}

extension TemaAplicacionExtension on TemaAplicacion {
  ThemeMode get themeMode {
    switch (this) {
      case TemaAplicacion.claro:
        return ThemeMode.light;
      case TemaAplicacion.oscuro:
        return ThemeMode.dark;
      case TemaAplicacion.sistema:
        return ThemeMode.system;
    }
  }

  String get etiqueta {
    switch (this) {
      case TemaAplicacion.sistema:
        return 'Sistema';
      case TemaAplicacion.claro:
        return 'Claro';
      case TemaAplicacion.oscuro:
        return 'Oscuro';
    }
  }
}