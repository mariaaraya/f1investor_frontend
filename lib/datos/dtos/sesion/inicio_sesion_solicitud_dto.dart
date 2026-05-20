class InicioSesionSolicitudDto {
  const InicioSesionSolicitudDto({
    required this.correo,
    required this.password,
  });

  final String correo;
  final String password;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'correo': correo,
      'password': password,
    };
  }
}