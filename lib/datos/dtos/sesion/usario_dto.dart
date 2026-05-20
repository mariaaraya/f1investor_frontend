import '../../../dominio/entidades/sesion/usuario.dart';

class UsuarioDto {
  const UsuarioDto({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.capital,
    this.creadoEn,
  });

  final int id;
  final String nombre;
  final String correo;
  final double capital;
  final DateTime? creadoEn;

  factory UsuarioDto.fromJson(Map<String, dynamic> json) {
    return UsuarioDto(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      correo: json['correo'] as String,
      capital: (json['capital'] as num).toDouble(),
      creadoEn: json['creado_en'] != null
          ? DateTime.tryParse(json['creado_en'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'nombre': nombre,
      'correo': correo,
      'capital': capital,
      'creado_en': creadoEn?.toIso8601String(),
    };
  }

  Usuario toEntity() {
    return Usuario(
      id: id,
      nombre: nombre,
      correo: correo,
      capital: capital,
      creadoEn: creadoEn,
    );
  }
}