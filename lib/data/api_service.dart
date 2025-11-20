import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/pedido_model.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8080/api";

  Future<List<Pedido>> getPedidos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pedidos'));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Pedido.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<Pedido?> createPedido(Pedido pedido) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pedidos'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(pedido.toJson()),
    );
    if (response.statusCode == 200) {
      return Pedido.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<Pedido?> updatePedido(int id, Pedido pedido) async {
    final response = await http.put(
      Uri.parse('$baseUrl/pedidos/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(pedido.toJson()),
    );
    if (response.statusCode == 200) {
      return Pedido.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<bool> deletePedido(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/pedidos/$id'));
    return response.statusCode == 204;
  }
}
