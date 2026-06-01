import '../../../dominio/entidades/entidades.dart';
import 'item_cartera_dto.dart';

class CarteraDto {
  const CarteraDto({
    required this.capital,
    required this.valorTotal,
    required this.gananciaTotal,
    required this.patrimonio,
    required this.portfolio,
  });

  final double capital;
  final double valorTotal;
  final double gananciaTotal;
  final double patrimonio;
  final List<ItemCarteraDto> portfolio;

  factory CarteraDto.fromJson(Map<String, dynamic> json) {
    final List<dynamic> portfolioJson =
        json['portfolio'] as List<dynamic>? ?? <dynamic>[];

    return CarteraDto(
      capital: (json['capital'] as num?)?.toDouble() ?? 0,
      valorTotal: (json['valor_total'] as num?)?.toDouble() ?? 0,
      gananciaTotal: (json['ganancia_total'] as num?)?.toDouble() ?? 0,
      patrimonio: (json['patrimonio'] as num?)?.toDouble() ?? 0,
      portfolio: portfolioJson
          .whereType<Map<String, dynamic>>()
          .map(ItemCarteraDto.fromJson)
          .toList(),
    );
  }

  Cartera toEntity() {
    return Cartera(
      capital: capital,
      valorTotal: valorTotal,
      gananciaTotal: gananciaTotal,
      patrimonio: patrimonio,
      portfolio: portfolio
          .map((ItemCarteraDto item) => item.toEntity())
          .toList(),
    );
  }
}