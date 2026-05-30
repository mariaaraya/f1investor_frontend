class RecuperarPasswordSolicitudDto {
  const RecuperarPasswordSolicitudDto({
    required this.correo,
    required this.nuevoPassword,
  });

  final String correo;
  final String nuevoPassword;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'correo': correo,
      'nuevo_password': nuevoPassword,
    };
  }
}