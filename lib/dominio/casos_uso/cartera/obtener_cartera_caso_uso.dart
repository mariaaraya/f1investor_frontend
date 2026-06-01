import '../../entidades/entidades.dart';
import '../../repositorios/cartera/cartera_repositorio.dart';

class ObtenerCarteraCasoUso {
  const ObtenerCarteraCasoUso({
    required CarteraRepositorio carteraRepositorio,
  }) : _carteraRepositorio = carteraRepositorio;

  final CarteraRepositorio _carteraRepositorio;

  Future<Cartera> call({
    required String token,
  }) {
    return _carteraRepositorio.obtenerCartera(
      token: token,
    );
  }
}