import 'package:equatable/equatable.dart';

import 'activo_mercado.dart';

class MercadoRespuesta extends Equatable {
  const MercadoRespuesta({
    required this.pilotos,
    required this.equipos,
  });

  final List<ActivoMercado> pilotos;
  final List<ActivoMercado> equipos;

  @override
  List<Object?> get props => <Object?>[
        pilotos,
        equipos,
      ];
}