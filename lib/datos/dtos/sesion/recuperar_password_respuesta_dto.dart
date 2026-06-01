class RecuperarPasswordRespuestaDto {
  const RecuperarPasswordRespuestaDto({
    required this.mensaje,
  });

  final String mensaje;

  factory RecuperarPasswordRespuestaDto.fromJson(Map<String, dynamic> json) {
    return RecuperarPasswordRespuestaDto(
      mensaje: json['mensaje'] as String? ?? '',
    );
  }
}