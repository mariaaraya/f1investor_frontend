import 'package:equatable/equatable.dart';

import '../entidades.dart';

class ActivoMercado extends Equatable {
  const ActivoMercado({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.valorMercado,
    required this.media,
    this.equipo,
    this.codigo,
    this.nacionalidad,
    this.imagen,
    this.porcentajeVariacion = 0,
  });

  final int id;
  final String nombre;
  final TipoActivoMercado tipo;
  final double valorMercado;
  final double media;
  final String? equipo;
  final String? codigo;
  final String? nacionalidad;
  final String? imagen;
  final double porcentajeVariacion;

  @override
  List<Object?> get props => <Object?>[
        id,
        nombre,
        tipo,
        valorMercado,
        media,
        equipo,
        codigo,
        nacionalidad,
        imagen,
        porcentajeVariacion,
      ];
}