import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dominio/entidades/entidades.dart';
import '../../../infraestructura/preferencias/tema_preferencias.dart';

part 'tema_state.dart';

class TemaCubit extends Cubit<TemaState> {
  TemaCubit({
    required TemaPreferencias temaPreferencias,
  })  : _temaPreferencias = temaPreferencias,
        super(const TemaState());

  final TemaPreferencias _temaPreferencias;

  Future<void> cargarTema() async {
    final TemaAplicacion tema = await _temaPreferencias.obtenerTema();

    emit(
      state.copyWith(
        tema: tema,
        cargando: false,
      ),
    );
  }

  Future<void> cambiarTema(TemaAplicacion tema) async {
    await _temaPreferencias.guardarTema(tema);

    emit(
      state.copyWith(
        tema: tema,
      ),
    );
  }
}