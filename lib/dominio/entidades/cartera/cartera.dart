import 'package:equatable/equatable.dart';

import 'item_cartera.dart';

class Cartera extends Equatable {
  const Cartera({
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
  final List<ItemCartera> portfolio;

  @override
  List<Object?> get props => <Object?>[
        capital,
        valorTotal,
        gananciaTotal,
        patrimonio,
        portfolio,
      ];
}