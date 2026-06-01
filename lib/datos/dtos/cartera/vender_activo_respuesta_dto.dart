class VenderActivoRespuestaDto {
  const VenderActivoRespuestaDto({
    required this.mensaje,
    required this.capitalActual,
  });

  final String mensaje;
  final double capitalActual;

  factory VenderActivoRespuestaDto.fromJson(Map<String, dynamic> json) {
    return VenderActivoRespuestaDto(
      mensaje: json['mensaje'] as String? ?? '',
      capitalActual: (json['capital_actual'] as num?)?.toDouble() ?? 0,
    );
  }
}