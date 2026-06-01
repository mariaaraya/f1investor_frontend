import '../../entidades/entidades.dart';
import '../../repositorios/mercado/mercado_repositorio.dart';

class ConsultarHistorialActivoMercadoCasoUso {
  ConsultarHistorialActivoMercadoCasoUso({
    required MercadoRepositorio mercadoRepositorio,
  }) : _mercadoRepositorio = mercadoRepositorio;

  final MercadoRepositorio _mercadoRepositorio;

  Future<List<HistorialMercado>> call({
    required TipoActivoMercado tipo,
    required int activoId,
    required String token,
  }) {
    return _mercadoRepositorio.consultarHistorialActivo(
      tipo: tipo,
      activoId: activoId,
      token: token,
    );
  }
}