import '../../../dominio/entidades/entidades.dart';
import '../dtos.dart';

class AutenticacionRespuestaDto {
  const AutenticacionRespuestaDto({
    required this.exitoso,
    required this.mensaje,
    required this.token,
    required this.usuario,
  });

  final bool exitoso;
  final String mensaje;
  final String token;
  final UsuarioDto usuario;

  factory AutenticacionRespuestaDto.fromJson(Map<String, dynamic> json) {
    return AutenticacionRespuestaDto(
      exitoso: json['exitoso'] as bool? ?? true,
      mensaje: json['mensaje'] as String? ?? '',
      token: json['token'] as String? ?? '',
      usuario: UsuarioDto.fromJson(
        json['usuario'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'exitoso': exitoso,
      'mensaje': mensaje,
      'token': token,
      'usuario': usuario.toJson(),
    };
  }

  ResultadoAutenticacion toEntity() {
    return ResultadoAutenticacion(
      exitoso: exitoso,
      mensaje: mensaje,
      token: token,
      usuario: usuario.toEntity(),
    );
  }
}