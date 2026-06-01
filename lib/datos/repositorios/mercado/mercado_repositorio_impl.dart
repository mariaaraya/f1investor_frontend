import '../../../dominio/entidades/entidades.dart';
import '../../../dominio/repositorios/mercado/mercado_repositorio.dart';
import '../../dtos/dtos.dart';
import '../../servicios/mercado/mercado_servicio.dart';

class MercadoRepositorioImplementacion implements MercadoRepositorio {
  MercadoRepositorioImplementacion({
    required MercadoServicio mercadoServicio,
  }) : _mercadoServicio = mercadoServicio;

  final MercadoServicio _mercadoServicio;

  @override
  Future<MercadoRespuesta> consultarMercado({
    required String token,
  }) async {
    final MercadoRespuestaDto respuesta =
        await _mercadoServicio.consultarMercado(token: token);

    return respuesta.toEntity();
  }

  @override
  Future<ActivoMercado> consultarDetalleActivo({
    required TipoActivoMercado tipo,
    required int activoId,
    required String token,
  }) async {
    final ActivoMercadoDto respuesta;

    if (tipo == TipoActivoMercado.equipo) {
      respuesta = await _mercadoServicio.consultarDetalleEquipo(
        id: activoId,
        token: token,
      );
    } else {
      respuesta = await _mercadoServicio.consultarDetallePiloto(
        id: activoId,
        token: token,
      );
    }

    return respuesta.toEntity();
  }

  @override
  Future<List<HistorialMercado>> consultarHistorialActivo({
    required TipoActivoMercado tipo,
    required int activoId,
    required String token,
  }) async {
    final List<HistorialMercadoDto> respuesta =
        await _mercadoServicio.consultarHistorialActivo(
      tipoActivo: _tipoActivoToBackend(tipo),
      activoId: activoId,
      token: token,
    );

    return respuesta
        .map((HistorialMercadoDto historial) => historial.toEntity())
        .toList();
  }

  @override
  Future<CompraActivoRespuesta> comprarActivo({
    required TipoActivoMercado tipo,
    required int activoId,
    required double cantidad,
    required String token,
  }) async {
    final CompraActivoSolicitudDto solicitud = CompraActivoSolicitudDto(
      tipoActivo: _tipoActivoToBackend(tipo),
      activoId: activoId,
      cantidad: cantidad,
    );

    final CompraActivoRespuestaDto respuesta =
        await _mercadoServicio.comprarActivo(
      solicitud: solicitud,
      token: token,
    );

    return respuesta.toEntity();
  }

  String _tipoActivoToBackend(TipoActivoMercado tipo) {
    if (tipo == TipoActivoMercado.equipo) {
      return 'equipo';
    }

    return 'piloto';
  }
}