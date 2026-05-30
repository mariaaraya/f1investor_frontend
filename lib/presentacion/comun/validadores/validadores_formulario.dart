class ValidadoresFormulario {
  ValidadoresFormulario._();

  static final RegExp _correoRegex = RegExp(
    r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$',
  );

  static final RegExp _passwordFuerteRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\s]).{8,}$',
  );

  static bool correoValido(String correo) {
    return _correoRegex.hasMatch(correo.trim());
  }

  static bool passwordFuerte(String password) {
    return _passwordFuerteRegex.hasMatch(password);
  }
}