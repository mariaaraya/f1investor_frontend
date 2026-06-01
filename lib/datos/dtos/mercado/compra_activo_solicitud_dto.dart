class CompraActivoSolicitudDto {
  const CompraActivoSolicitudDto({
    required this.tipoActivo,
    required this.activoId,
    required this.cantidad,
  });

  final String tipoActivo;
  final int activoId;
  final double cantidad;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'tipo_activo': tipoActivo,
      'activo_id': activoId,
      'cantidad': cantidad,
    };
  }
}