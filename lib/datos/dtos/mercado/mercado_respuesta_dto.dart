import '../../../dominio/entidades/entidades.dart';
import '../dtos.dart';

class MercadoRespuestaDto {
  const MercadoRespuestaDto({
    required this.pilotos,
    required this.equipos,
  });

  final List<ActivoMercadoDto> pilotos;
  final List<ActivoMercadoDto> equipos;

  factory MercadoRespuestaDto.fromJson(Map<String, dynamic> json) {
    final List<dynamic> pilotosJson =
        json['pilotos_top'] as List<dynamic>? ?? <dynamic>[];

    final List<dynamic> equiposJson =
        json['equipos_top'] as List<dynamic>? ?? <dynamic>[];

    return MercadoRespuestaDto(
      pilotos: pilotosJson
          .whereType<Map<dynamic, dynamic>>()
          .map(
            (Map<dynamic, dynamic> item) => ActivoMercadoDto.fromJson(
              Map<String, dynamic>.from(item),
              tipo: TipoActivoMercado.piloto,
            ),
          )
          .toList(),
      equipos: equiposJson
          .whereType<Map<dynamic, dynamic>>()
          .map(
            (Map<dynamic, dynamic> item) => ActivoMercadoDto.fromJson(
              Map<String, dynamic>.from(item),
              tipo: TipoActivoMercado.equipo,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'pilotos_top': pilotos
          .map((ActivoMercadoDto piloto) => piloto.toJson())
          .toList(),
      'equipos_top': equipos
          .map((ActivoMercadoDto equipo) => equipo.toJson())
          .toList(),
    };
  }

  MercadoRespuesta toEntity() {
    return MercadoRespuesta(
      pilotos: pilotos
          .map((ActivoMercadoDto piloto) => piloto.toEntity())
          .toList(),
      equipos: equipos
          .map((ActivoMercadoDto equipo) => equipo.toEntity())
          .toList(),
    );
  }
}