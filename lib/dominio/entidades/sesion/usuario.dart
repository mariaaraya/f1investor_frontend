import 'package:equatable/equatable.dart';

class Usuario extends Equatable {
  const Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.capital,
    this.creadoEn,
  });

  final int id;
  final String nombre;
  final String correo;
  final double capital;
  final DateTime? creadoEn;

  @override
  List<Object?> get props => <Object?>[
        id,
        nombre,
        correo,
        capital,
        creadoEn,
      ];
}