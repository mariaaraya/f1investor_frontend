import '../../entidades/entidades.dart';
import '../../repositorios/mercado/mercado_repositorio.dart';

class ComprarActivoCasoUso {
  ComprarActivoCasoUso({
    required MercadoRepositorio mercadoRepositorio,
  }) : _mercadoRepositorio = mercadoRepositorio;

  final MercadoRepositorio _mercadoRepositorio;

  Future<CompraActivoRespuesta> call({
    required TipoActivoMercado tipo,
    required int activoId,
    required double cantidad,
    required String token,
  }) {
    return _mercadoRepositorio.comprarActivo(
      tipo: tipo,
      activoId: activoId,
      cantidad: cantidad,
      token: token,
    );
  }
}