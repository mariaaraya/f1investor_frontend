part of 'recuperar_password_cubit.dart';

class RecuperarPasswordState extends Equatable {
  const RecuperarPasswordState({
    this.correo = '',
    this.nuevoPassword = '',
    this.confirmarPassword = '',
    this.cargando = false,
    this.mensajeError,
    this.mensajeExito,
  });

  final String correo;
  final String nuevoPassword;
  final String confirmarPassword;
  final bool cargando;
  final String? mensajeError;
  final String? mensajeExito;

  bool get correoValido {
    return ValidadoresFormulario.correoValido(correo);
  }

  bool get passwordValida {
    return ValidadoresFormulario.passwordFuerte(nuevoPassword);
  }

  bool get passwordsCoinciden {
    return nuevoPassword == confirmarPassword;
  }

  bool get formularioValido {
    return correoValido &&
        passwordValida &&
        confirmarPassword.trim().isNotEmpty &&
        passwordsCoinciden;
  }

  RecuperarPasswordState copyWith({
    String? correo,
    String? nuevoPassword,
    String? confirmarPassword,
    bool? cargando,
    String? mensajeError,
    bool limpiarMensajeError = false,
    String? mensajeExito,
    bool limpiarMensajeExito = false,
  }) {
    return RecuperarPasswordState(
      correo: correo ?? this.correo,
      nuevoPassword: nuevoPassword ?? this.nuevoPassword,
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
        correo,
        nuevoPassword,
        confirmarPassword,
        cargando,
        mensajeError,
        mensajeExito,
      ];
}