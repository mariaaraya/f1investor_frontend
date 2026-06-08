import 'package:flutter/material.dart';

extension ContextoExtensiones on BuildContext {
  bool get esTemaOscuro {
    return Theme.of(this).brightness == Brightness.dark;
  }

  Color get colorFondo {
    return esTemaOscuro ? const Color(0xFF080808) : const Color(0xFFF7F7F7);
  }

  Color get colorTarjeta {
    return esTemaOscuro ? const Color(0xFF1C1C1C) : Colors.white;
  }

  Color get colorTarjetaSecundaria {
    return esTemaOscuro ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0);
  }

  Color get colorTextoPrincipal {
    return esTemaOscuro ? Colors.white : const Color(0xFF181818);
  }

  Color get colorTextoSecundario {
    return esTemaOscuro ? const Color(0xFFBDBDBD) : const Color(0xFF555555);
  }

  Color get colorBorde {
    return esTemaOscuro ? const Color(0xFF333333) : const Color(0xFFE0E0E0);
  }

  Color get colorPrimarioApp {
    return const Color(0xFFE60000);
  }

  Color get colorCampo {
    return esTemaOscuro ? const Color(0xFF1C1C1C) : Colors.white;
  }

  Color get colorHint {
    return esTemaOscuro ? const Color(0xFF9E9E9E) : const Color(0xFF777777);
  }
}