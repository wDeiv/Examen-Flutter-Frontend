import 'cliente_model.dart';
import 'plato_model.dart';

class Pedido {
  final int id;
  final int numeromesa;
  final Cliente? cliente;
  final Plato? plato;

  Pedido({
    required this.id,
    required this.numeromesa,
    this.cliente,
    this.plato,
  });
  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      numeromesa: json['numeromesa'],
      cliente: json['cliente'] != null
          ? Cliente.fromJson(json['cliente'])
          : null,
      plato: json['plato'] != null ? Plato.fromJson(json['plato']) : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numeromesa': numeromesa,
      if (cliente != null) 'cliente': {'id': cliente!.id},
      if (plato != null) 'plato': {'id': plato!.id},
    };
  }
}
