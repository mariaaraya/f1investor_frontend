part of 'mercado_cubit.dart';

class MercadoState extends Equatable {
  const MercadoState({
    this.cargando = false,
    this.mensajeError,
    this.pilotos = const <ActivoMercado>[],
    this.equipos = const <ActivoMercado>[],
  });

  final bool cargando;
  final String? mensajeError;
  final List<ActivoMercado> pilotos;
  final List<ActivoMercado> equipos;

  MercadoState copyWith({
    bool? cargando,
    String? mensajeError,
    bool limpiarMensajeError = false,
    List<ActivoMercado>? pilotos,
    List<ActivoMercado>? equipos,
  }) {
    return MercadoState(
      cargando: cargando ?? this.cargando,
      mensajeError: limpiarMensajeError
          ? null
          : mensajeError ?? this.mensajeError,
      pilotos: pilotos ?? this.pilotos,
      equipos: equipos ?? this.equipos,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        cargando,
        mensajeError,
        pilotos,
        equipos,
      ];
}