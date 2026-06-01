import 'package:equatable/equatable.dart';

class ItemCartera extends Equatable {
  const ItemCartera({
    required this.id,
    required this.tipoActivo,
    required this.activoId,
    required this.nombreActivo,
    required this.cantidad,
    required this.valorPromedioCompra,
    required this.valorActual,
    required this.valorInvertidoTotal,
    required this.valorActualTotal,
    required this.gananciaPerdida,
    required this.porcentajeRendimiento,
    required this.activo,
  });

  final int id;
  final String tipoActivo;
  final int activoId;
  final String nombreActivo;
  final double cantidad;
  final double valorPromedioCompra;
  final double valorActual;
  final double valorInvertidoTotal;
  final double valorActualTotal;
  final double gananciaPerdida;
  final double porcentajeRendimiento;
  final bool activo;

  @override
  List<Object?> get props => <Object?>[
        id,
        tipoActivo,
        activoId,
        nombreActivo,
        cantidad,
        valorPromedioCompra,
        valorActual,
        valorInvertidoTotal,
        valorActualTotal,
        gananciaPerdida,
        porcentajeRendimiento,
        activo,
      ];
}