part of 'registro_cubit.dart';

class RegistroState extends Equatable {
  const RegistroState({
    this.nombre = '',
    this.correo = '',
    this.password = '',
    this.confirmarPassword = '',
    this.cargando = false,
    this.mensajeError,
    this.mensajeExito,
  });

  final String nombre;
  final String correo;
  final String password;
  final String confirmarPassword;
  final bool cargando;
  final String? mensajeError;
  final String? mensajeExito;

  bool get passwordsCoinciden {
    return password == confirmarPassword;
  }

  bool get formularioValido {
    return nombre.trim().isNotEmpty &&
        correo.trim().isNotEmpty &&
        password.trim().isNotEmpty &&
        confirmarPassword.trim().isNotEmpty &&
        passwordsCoinciden;
  }

  RegistroState copyWith({
    String? nombre,
    String? correo,
    String? password,
    String? confirmarPassword,
    bool? cargando,
    String? mensajeError,
    bool limpiarMensajeError = false,
    String? mensajeExito,
    bool limpiarMensajeExito = false,
  }) {
    return RegistroState(
      nombre: nombre ?? this.nombre,
      correo: correo ?? this.correo,
      password: password ?? this.password,
      confirmarPassword: confirmarPassword ?? this.confirmarPassword,
      cargando: cargando ?? this.cargando,
      mensajeError: limpiarMensajeError
          ? null
          : mensajeError ?? this.mensajeError,
      mensajeExito: limpiarMensajeExito
          ? null
          : mensajeExito ?? this.mensajeExito,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        nombre,
        correo,
        password,
        confirmarPassword,
        cargando,
        mensajeError,
        mensajeExito,
      ];
}