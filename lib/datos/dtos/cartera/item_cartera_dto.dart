import '../../../dominio/entidades/entidades.dart';

class ItemCarteraDto {
  const ItemCarteraDto({
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

  factory ItemCarteraDto.fromJson(Map<String, dynamic> json) {
    return ItemCarteraDto(
      id: json['id'] as int? ?? 0,
      tipoActivo: json['tipo_activo'] as String? ?? '',
      activoId: json['activo_id'] as int? ?? 0,
      nombreActivo: json['nombre_activo'] as String? ?? '',
      cantidad: (json['cantidad'] as num?)?.toDouble() ?? 0,
      valorPromedioCompra:
          (json['valor_promedio_compra'] as num?)?.toDouble() ?? 0,
      valorActual: (json['valor_actual'] as num?)?.toDouble() ?? 0,
      valorInvertidoTotal:
          (json['valor_invertido_total'] as num?)?.toDouble() ?? 0,
      valorActualTotal:
          (json['valor_actual_total'] as num?)?.toDouble() ?? 0,
      gananciaPerdida: (json['ganancia_perdida'] as num?)?.toDouble() ?? 0,
      porcentajeRendimiento:
          (json['porcentaje_rendimiento'] as num?)?.toDouble() ?? 0,
      activo: json['activo'] as bool? ?? false,
    );
  }

  ItemCartera toEntity() {
    return ItemCartera(
      id: id,
      tipoActivo: tipoActivo,
      activoId: activoId,
      nombreActivo: nombreActivo,
      cantidad: cantidad,
      valorPromedioCompra: valorPromedioCompra,
      valorActual: valorActual,
      valorInvertidoTotal: valorInvertidoTotal,
      valorActualTotal: valorActualTotal,
      gananciaPerdida: gananciaPerdida,
      porcentajeRendimiento: porcentajeRendimiento,
      activo: activo,
    );
  }
}