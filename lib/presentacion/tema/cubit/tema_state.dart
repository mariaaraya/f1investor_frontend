part of 'tema_cubit.dart';

class TemaState extends Equatable {
  const TemaState({
    this.tema = TemaAplicacion.sistema,
    this.cargando = true,
  });

  final TemaAplicacion tema;
  final bool cargando;

  TemaState copyWith({
    TemaAplicacion? tema,
    bool? cargando,
  }) {
    return TemaState(
      tema: tema ?? this.tema,
      cargando: cargando ?? this.cargando,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        tema,
        cargando,
      ];
}