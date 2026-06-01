import '../../entidades/entidades.dart';

abstract class CarteraRepositorio {
  Future<Cartera> obtenerCartera({
    required String token,
  });

  Future<void> venderActivo({
    required String token,
    required String tipoActivo,
    required int activoId,
    required double cantidad,
  });
}