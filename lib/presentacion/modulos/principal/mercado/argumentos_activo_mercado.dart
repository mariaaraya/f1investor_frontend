import '../../../../dominio/entidades/entidades.dart';

class ArgumentosActivoMercado {
  const ArgumentosActivoMercado({
    required this.activo,
    required this.resultadoAutenticacion,
  });

  final ActivoMercado activo;
  final ResultadoAutenticacion resultadoAutenticacion;
}