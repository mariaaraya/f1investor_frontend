import 'package:equatable/equatable.dart';

import 'usuario.dart';

class ResultadoAutenticacion extends Equatable {
  const ResultadoAutenticacion({
    required this.exitoso,
    required this.mensaje,
    required this.token,
    required this.usuario,
  });

  final bool exitoso;
  final String mensaje;
  final String token;
  final Usuario usuario;

  @override
  List<Object?> get props => <Object?>[
        exitoso,
        mensaje,
        token,
        usuario,
      ];
}