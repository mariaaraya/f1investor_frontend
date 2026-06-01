import '../../entidades/entidades.dart';
import '../../repositorios/mercado/mercado_repositorio.dart';

class ConsultarMercadoCasoUso {
  ConsultarMercadoCasoUso({
    required MercadoRepositorio mercadoRepositorio,
  }) : _mercadoRepositorio = mercadoRepositorio;

  final MercadoRepositorio _mercadoRepositorio;

  Future<MercadoRespuesta> call({
    required String token,
  }) {
    return _mercadoRepositorio.consultarMercado(token: token);
  }
}