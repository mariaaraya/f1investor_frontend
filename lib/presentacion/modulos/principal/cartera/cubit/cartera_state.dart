part of 'cartera_cubit.dart';

class CarteraState extends Equatable {
  const CarteraState({
    this.cargando = false,
    this.vendiendo = false,
    this.mensajeError,
    this.cartera,
  });

  final bool cargando;
  final bool vendiendo;
  final String? mensajeError;
  final Cartera? cartera;

  CarteraState copyWith({
    bool? cargando,
    bool? vendiendo,
    String? mensajeError,
    bool limpiarMensajeError = false,
    Cartera? cartera,
  }) {
    return CarteraState(
      cargando: cargando ?? this.cargando,
      vendiendo: vendiendo ?? this.vendiendo,
      mensajeError: limpiarMensajeError
          ? null
          : mensajeError ?? this.mensajeError,
      cartera: cartera ?? this.cartera,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        cargando,
        vendiendo,
        mensajeError,
        cartera,
      ];
}