part of 'compra_activo_mercado_cubit.dart';

class CompraActivoMercadoState extends Equatable {
  const CompraActivoMercadoState({
    this.cargando = false,
    this.mensajeError,
    this.mensajeExito,
    this.compraRealizada = false,
    this.capitalRestante = 0,
  });

  final bool cargando;
  final String? mensajeError;
  final String? mensajeExito;
  final bool compraRealizada;
  final double capitalRestante;

  CompraActivoMercadoState copyWith({
    bool? cargando,
    String? mensajeError,
    String? mensajeExito,
    bool limpiarMensajeError = false,
    bool limpiarMensajeExito = false,
    bool? compraRealizada,
    double? capitalRestante,
  }) {
    return CompraActivoMercadoState(
      cargando: cargando ?? this.cargando,
      mensajeError: limpiarMensajeError
          ? null
          : mensajeError ?? this.mensajeError,
      mensajeExito: limpiarMensajeExito
          ? null
          : mensajeExito ?? this.mensajeExito,
      compraRealizada: compraRealizada ?? this.compraRealizada,
      capitalRestante: capitalRestante ?? this.capitalRestante,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        cargando,
        mensajeError,
        mensajeExito,
        compraRealizada,
        capitalRestante,
      ];
}