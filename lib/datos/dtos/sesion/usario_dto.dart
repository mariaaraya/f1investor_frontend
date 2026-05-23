
import '../../../dominio/entidades/entidades.dart';

class UsuarioDto {
  const UsuarioDto({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.capitalInicial,
    required this.capital,
    required this.valorPortfolio,
    required this.patrimonioTotal,
    required this.rol,
    required this.activo,
    this.username,
    this.creadoEn,
    this.ultimoAcceso,
  });

  final int id;
  final String nombre;
  final String? username;
  final String correo;

  final double capitalInicial;
  final double capital;
  final double valorPortfolio;
  final double patrimonioTotal;

  final String rol;
  final bool activo;

  final DateTime? creadoEn;
  final DateTime? ultimoAcceso;

  factory UsuarioDto.fromJson(Map<String, dynamic> json) {
    return UsuarioDto(
      id: json['id'] as int,
      nombre: json['nombre'] as String? ?? '',
      username: json['username'] as String?,
      correo: json['correo'] as String? ?? '',
      capitalInicial: (json['capital_inicial'] as num? ?? 0).toDouble(),
      capital: (json['capital'] as num? ?? 0).toDouble(),
      valorPortfolio: (json['valor_portfolio'] as num? ?? 0).toDouble(),
      patrimonioTotal: (json['patrimonio_total'] as num? ?? 0).toDouble(),
      rol: json['rol'] as String? ?? '',
      activo: json['activo'] as bool? ?? false,
      creadoEn: json['creado_en'] != null
          ? DateTime.tryParse(json['creado_en'].toString())
          : null,
      ultimoAcceso: json['ultimo_acceso'] != null
          ? DateTime.tryParse(json['ultimo_acceso'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'nombre': nombre,
      'username': username,
      'correo': correo,
      'capital_inicial': capitalInicial,
      'capital': capital,
      'valor_portfolio': valorPortfolio,
      'patrimonio_total': patrimonioTotal,
      'rol': rol,
      'activo': activo,
      'creado_en': creadoEn?.toIso8601String(),
      'ultimo_acceso': ultimoAcceso?.toIso8601String(),
    };
  }

  Usuario toEntity() {
    return Usuario(
      id: id,
      nombre: nombre,
      username: username,
      correo: correo,
      capitalInicial: capitalInicial,
      capital: capital,
      valorPortfolio: valorPortfolio,
      patrimonioTotal: patrimonioTotal,
      rol: rol,
      activo: activo,
      creadoEn: creadoEn,
      ultimoAcceso: ultimoAcceso,
    );
  }
}