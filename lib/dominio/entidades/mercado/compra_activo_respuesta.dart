import 'package:equatable/equatable.dart';

class CompraActivoRespuesta extends Equatable {
  const CompraActivoRespuesta({
    required this.mensaje,
    required this.capitalRestante,
  });

  final String mensaje;
  final double capitalRestante;

  @override
  List<Object?> get props => <Object?>[
        mensaje,
        capitalRestante,
      ];
}