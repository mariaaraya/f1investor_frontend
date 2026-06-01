class RegistroUsuarioSolicitudDto {
  const RegistroUsuarioSolicitudDto({
    required this.nombre,
    required this.correo,
    required this.password,
    this.username,
    this.capitalInicial,
  });

  final String nombre;
  final String correo;
  final String password;
  final String? username;
  final double? capitalInicial;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'nombre': nombre,
      'correo': correo,
      'password': password,
      if (username != null && username!.isNotEmpty) 'username': username,
      if (capitalInicial != null) 'capital_inicial': capitalInicial,
    };
  }
}