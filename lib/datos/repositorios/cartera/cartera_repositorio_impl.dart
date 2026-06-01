import 'package:f1investor_frontend/datos/servicios/cartera/cartera_servicio.dart';
import 'package:f1investor_frontend/dominio/repositorios/cartera/cartera_repositorio.dart';

import '../../../dominio/entidades/entidades.dart';
import '../../dtos/dtos.dart';

class CarteraRepositorioImplementacion implements CarteraRepositorio {
  const CarteraRepositorioImplementacion({
    required CarteraServicio carteraServicio,
  }) : _carteraServicio = carteraServicio;

  final CarteraServicio _carteraServicio;

  @override
  Future<Cartera> obtenerCartera({
    required String token,
  }) async {
    final CarteraDto respuesta = await _carteraServicio.obtenerCartera(
      token: token,
    );

    return respuesta.toEntity();
  }

  @override
  Future<void> venderActivo({
    required String token,
    required String tipoActivo,
    required int activoId,
    required double cantidad,
  }) async {
    final VenderActivoSolicitudDto solicitud = VenderActivoSolicitudDto(
      tipoActivo: tipoActivo,
      activoId: activoId,
      cantidad: cantidad,
    );

    await _carteraServicio.venderActivo(
      token: token,
      solicitud: solicitud,
    );
  }
}