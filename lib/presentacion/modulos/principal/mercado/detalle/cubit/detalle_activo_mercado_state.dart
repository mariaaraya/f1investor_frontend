part of 'detalle_activo_mercado_cubit.dart';

class DetalleActivoMercadoState extends Equatable {
  const DetalleActivoMercadoState({
    this.cargando = false,
    this.mensajeError,
    this.activo,
    this.historial = const <HistorialMercado>[],
  });

  final bool cargando;
  final String? mensajeError;
  final ActivoMercado? activo;
  final List<HistorialMercado> historial;

  DetalleActivoMercadoState copyWith({
    bool? cargando,
    String? mensajeError,
    bool limpiarMensajeError = false,
    ActivoMercado? activo,
    List<HistorialMercado>? historial,
  }) {
    return DetalleActivoMercadoState(
      cargando: cargando ?? this.cargando,
      mensajeError: limpiarMensajeError
          ? null
          : mensajeError ?? this.mensajeError,
      activo: activo ?? this.activo,
      historial: historial ?? this.historial,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        cargando,
        mensajeError,
        activo,
        historial,
      ];
}