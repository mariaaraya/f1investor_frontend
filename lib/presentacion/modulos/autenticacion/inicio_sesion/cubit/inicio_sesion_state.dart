part of 'inicio_sesion_cubit.dart';

class InicioSesionState extends Equatable {
  const InicioSesionState({
    this.correo = '',
    this.password = '',
    this.cargando = false,
    this.mensajeError,
    this.resultadoAutenticacion,
  });

  final String correo;
  final String password;
  final bool cargando;
  final String? mensajeError;
  final ResultadoAutenticacion? resultadoAutenticacion;

  bool get formularioValido {
    return correo.trim().isNotEmpty && password.trim().isNotEmpty;
  }

  InicioSesionState copyWith({
    String? correo,
    String? password,
    bool? cargando,
    String? mensajeError,
    bool limpiarMensajeError = false,
    ResultadoAutenticacion? resultadoAutenticacion,
    bool limpiarResultadoAutenticacion = false,
  }) {
    return InicioSesionState(
      correo: correo ?? this.correo,
      password: password ?? this.password,
      cargando: cargando ?? this.cargando,
      mensajeError: limpiarMensajeError
          ? null
          : mensajeError ?? this.mensajeError,
      resultadoAutenticacion: limpiarResultadoAutenticacion
          ? null
          : resultadoAutenticacion ?? this.resultadoAutenticacion,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        correo,
        password,
        cargando,
        mensajeError,
        resultadoAutenticacion,
      ];
}