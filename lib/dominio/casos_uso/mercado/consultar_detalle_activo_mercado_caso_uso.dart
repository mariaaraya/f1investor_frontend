import '../../entidades/entidades.dart';
import '../../repositorios/mercado/mercado_repositorio.dart';

class ConsultarDetalleActivoMercadoCasoUso {
  ConsultarDetalleActivoMercadoCasoUso({
    required MercadoRepositorio mercadoRepositorio,
  }) : _mercadoRepositorio = mercadoRepositorio;

  final MercadoRepositorio _mercadoRepositorio;

  Future<ActivoMercado> call({
    required TipoActivoMercado tipo,
    required int activoId,
    required String token,
  }) {
    return _mercadoRepositorio.consultarDetalleActivo(
      tipo: tipo,
      activoId: activoId,
      token: token,
    );
  }
}