import 'package:equatable/equatable.dart';

class Usuario extends Equatable {
  const Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.capitalInicial,
    required this.capital,
    required this.valorPortfolio,
    required this.patrimonioTotal,
    required this.rol,
    required this.activo,
    this.username,
    this.creadoEn,
    this.ultimoAcceso,
  });

  final int id;
  final String nombre;
  final String? username;
  final String correo;

  final double capitalInicial;
  final double capital;
  final double valorPortfolio;
  final double patrimonioTotal;

  final String rol;
  final bool activo;

  final DateTime? creadoEn;
  final DateTime? ultimoAcceso;

  @override
  List<Object?> get props => <Object?>[
        id,
        nombre,
        username,
        correo,
        capitalInicial,
        capital,
        valorPortfolio,
        patrimonioTotal,
        rol,
        activo,
        creadoEn,
        ultimoAcceso,
      ];
}