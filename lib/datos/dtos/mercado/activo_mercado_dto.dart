import '../../../dominio/entidades/entidades.dart';

class ActivoMercadoDto {
  const ActivoMercadoDto({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.valorMercado,
    required this.media,
    required this.porcentajeVariacion,
    this.equipo,
    this.codigo,
    this.nacionalidad,
    this.imagen,
  });

  final int id;
  final String nombre;
  final TipoActivoMercado tipo;
  final double valorMercado;
  final double media;
  final double porcentajeVariacion;
  final String? equipo;
  final String? codigo;
  final String? nacionalidad;
  final String? imagen;

  factory ActivoMercadoDto.fromJson(
    Map<String, dynamic> json, {
    required TipoActivoMercado tipo,
  }) {
    return ActivoMercadoDto(
      id: json['id'] as int? ?? 0,
      nombre: json['nombre'] as String? ?? '',
      tipo: tipo,
      valorMercado: (json['valor_mercado'] as num? ?? 0).toDouble(),
      media: (json['media'] as num? ?? 0).toDouble(),
      porcentajeVariacion:
          (json['porcentaje_variacion'] as num? ?? 0).toDouble(),
      equipo: json['equipo'] as String?,
      codigo: json['codigo'] as String?,
      nacionalidad: json['nacionalidad'] as String?,
      imagen: tipo == TipoActivoMercado.equipo
          ? json['imagen'] as String?
          : json['foto'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'nombre': nombre,
      'tipo': tipo.name,
      'valor_mercado': valorMercado,
      'media': media,
      'porcentaje_variacion': porcentajeVariacion,
      'equipo': equipo,
      'codigo': codigo,
      'nacionalidad': nacionalidad,
      'imagen': imagen,
    };
  }

  ActivoMercado toEntity() {
    return ActivoMercado(
      id: id,
      nombre: nombre,
      tipo: tipo,
      valorMercado: valorMercado,
      media: media,
      porcentajeVariacion: porcentajeVariacion,
      equipo: equipo,
      codigo: codigo,
      nacionalidad: nacionalidad,
      imagen: imagen,
    );
  }
}