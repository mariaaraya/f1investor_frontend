import '../../../dominio/entidades/entidades.dart';

class CompraActivoRespuestaDto {
  const CompraActivoRespuestaDto({
    required this.mensaje,
    required this.capitalRestante,
  });

  final String mensaje;
  final double capitalRestante;

  factory CompraActivoRespuestaDto.fromJson(Map<String, dynamic> json) {
    return CompraActivoRespuestaDto(
      mensaje: json['mensaje'] as String? ?? '',
      capitalRestante: (json['capital_restante'] as num? ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'mensaje': mensaje,
      'capital_restante': capitalRestante,
    };
  }

  CompraActivoRespuesta toEntity() {
    return CompraActivoRespuesta(
      mensaje: mensaje,
      capitalRestante: capitalRestante,
    );
  }
}