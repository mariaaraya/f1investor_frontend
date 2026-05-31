import 'package:equatable/equatable.dart';

class HistorialMercado extends Equatable {
  const HistorialMercado({
    required this.id,
    required this.tipoActivo,
    required this.activoId,
    required this.nombreActivo,
    required this.valorAnterior,
    required this.valorNuevo,
    required this.variacion,
    required this.porcentajeVariacion,
    required this.motivo,
    this.fecha,
  });

  final int id;
  final String tipoActivo;
  final int activoId;
  final String nombreActivo;
  final double valorAnterior;
  final double valorNuevo;
  final double variacion;
  final double porcentajeVariacion;
  final String motivo;
  final DateTime? fecha;

  @override
  List<Object?> get props => <Object?>[
        id,
        tipoActivo,
        activoId,
        nombreActivo,
        valorAnterior,
        valorNuevo,
        variacion,
        porcentajeVariacion,
        motivo,
        fecha,
      ];
}