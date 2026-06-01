import '../../repositorios/cartera/cartera_repositorio.dart';

class VenderActivoCasoUso {
  const VenderActivoCasoUso({
    required CarteraRepositorio carteraRepositorio,
  }) : _carteraRepositorio = carteraRepositorio;

  final CarteraRepositorio _carteraRepositorio;

  Future<void> call({
    required String token,
    required String tipoActivo,
    required int activoId,
    required double cantidad,
  }) {
    return _carteraRepositorio.venderActivo(
      token: token,
      tipoActivo: tipoActivo,
      activoId: activoId,
      cantidad: cantidad,
    );
  }
}