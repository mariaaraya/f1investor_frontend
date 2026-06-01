import '../../../dominio/entidades/entidades.dart';

class HistorialMercadoDto {
  const HistorialMercadoDto({
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

  factory HistorialMercadoDto.fromJson(Map<String, dynamic> json) {
    return HistorialMercadoDto(
      id: json['id'] as int? ?? 0,
      tipoActivo: json['tipo_activo'] as String? ?? '',
      activoId: json['activo_id'] as int? ?? 0,
      nombreActivo: json['nombre_activo'] as String? ?? '',
      valorAnterior: (json['valor_anterior'] as num? ?? 0).toDouble(),
      valorNuevo: (json['valor_nuevo'] as num? ?? 0).toDouble(),
      variacion: (json['variacion'] as num? ?? 0).toDouble(),
      porcentajeVariacion:
          (json['porcentaje_variacion'] as num? ?? 0).toDouble(),
      motivo: json['motivo'] as String? ?? '',
      fecha: json['fecha'] != null
          ? DateTime.tryParse(json['fecha'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'tipo_activo': tipoActivo,
      'activo_id': activoId,
      'nombre_activo': nombreActivo,
      'valor_anterior': valorAnterior,
      'valor_nuevo': valorNuevo,
      'variacion': variacion,
      'porcentaje_variacion': porcentajeVariacion,
      'motivo': motivo,
      'fecha': fecha?.toIso8601String(),
    };
  }

  HistorialMercado toEntity() {
    return HistorialMercado(
      id: id,
      tipoActivo: tipoActivo,
      activoId: activoId,
      nombreActivo: nombreActivo,
      valorAnterior: valorAnterior,
      valorNuevo: valorNuevo,
      variacion: variacion,
      porcentajeVariacion: porcentajeVariacion,
      motivo: motivo,
      fecha: fecha,
    );
  }
}