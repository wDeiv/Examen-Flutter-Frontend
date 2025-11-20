import 'package:flutter/material.dart';
import '../data/api_service.dart';
import '../domain/pedido_model.dart';
import '../domain/cliente_model.dart';
import '../domain/plato_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Pedido>> _pedidosFuture;

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
  }

  void _cargarPedidos() {
    setState(() {
      _pedidosFuture = apiService.getPedidos();
    });
  }

  void _eliminarPedido(int id) async {
    bool exito = await apiService.deletePedido(id);
    if (exito) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Pedido eliminado')));
      _cargarPedidos();
    }
  }

  void _mostrarFormulario({Pedido? pedido}) {
    final mesaController = TextEditingController(
      text: pedido?.numeromesa.toString() ?? '',
    );
    final clienteIdController = TextEditingController(
      text: pedido?.cliente?.id.toString() ?? '',
    );
    final platoIdController = TextEditingController(
      text: pedido?.plato?.id.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(pedido == null ? 'Nuevo Pedido' : 'Editar Pedido'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: mesaController,
                decoration: InputDecoration(labelText: 'Número de Mesa'),
              ),
              TextField(
                controller: clienteIdController,
                decoration: InputDecoration(labelText: 'ID Cliente (ej: 1)'),
              ),
              TextField(
                controller: platoIdController,
                decoration: InputDecoration(labelText: 'ID Plato (ej: 2)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final nuevoPedido = Pedido(
                  id: pedido?.id ?? 0,
                  numeromesa: int.parse(mesaController.text),
                  cliente: Cliente(
                    id: int.parse(clienteIdController.text),
                    nombre: '',
                    telefono: '',
                  ),
                  plato: Plato(
                    id: int.parse(platoIdController.text),
                    nombre: '',
                    descripcion: '',
                    precio: 0,
                  ),
                );

                if (pedido == null) {
                  await apiService.createPedido(nuevoPedido);
                } else {
                  await apiService.updatePedido(pedido.id, nuevoPedido);
                }
                Navigator.pop(context);
                _cargarPedidos();
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Restaurante de Angel :v')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _mostrarFormulario(),
      ),
      body: FutureBuilder<List<Pedido>>(
        future: _pedidosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay pedidos.'));
          }

          final pedidos = snapshot.data!;
          return ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final p = pedidos[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(child: Text("${p.numeromesa}")),
                  title: Text(p.plato?.nombre ?? "Plato ${p.plato?.id}"),
                  subtitle: Text(
                    "Cliente: ${p.cliente?.nombre ?? 'ID ${p.cliente?.id}'}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _mostrarFormulario(pedido: p),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _eliminarPedido(p.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
