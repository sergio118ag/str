import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class EventProductsScreen extends StatefulWidget {
  final Event event;

  const EventProductsScreen({super.key, required this.event});

  @override
  State<EventProductsScreen> createState() => _EventProductsScreenState();
}

class _EventProductsScreenState extends State<EventProductsScreen> {
  late Future<List<Product>> products;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() {
    setState(() {
      products = ApiService().getProductsByEvent(widget.event.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos - ${widget.event.name}"),
      ),
      body: FutureBuilder<List<Product>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    "No hay productos asociados",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Presiona el botón + para añadir uno",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final product = data[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.description),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            "${product.price} €",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            "Stock: ${product.stock}",
                            style: TextStyle(
                              color: product.stock > 0 ? Colors.blue : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditDialog(product);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Confirmar eliminación"),
                              content: Text("¿Seguro que quieres eliminar ${product.name}?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text("Cancelar"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Eliminar"),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            try {
                              await ApiService().deleteProduct(product.id);
                              loadProducts();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Producto eliminado correctamente"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _stockController.clear();
    _categoryController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Añadir Producto"),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Nombre"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingresa un nombre";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Descripción"),
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: "Precio (€)"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingresa un precio";
                    }
                    if (double.tryParse(value) == null) {
                      return "Ingresa un número válido";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _stockController,
                  decoration: const InputDecoration(labelText: "Stock"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingresa un stock";
                    }
                    if (int.tryParse(value) == null) {
                      return "Ingresa un número válido";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: "Categoría"),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: _createProduct,
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  void _createProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ApiService().createProduct(
          {
            'name': _nameController.text,
            'description': _descriptionController.text,
            'price': double.parse(_priceController.text),
            'stock': int.parse(_stockController.text),
            'category': _categoryController.text,
          },
          widget.event.id,
        );
        Navigator.pop(context);
        loadProducts();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Producto creado correctamente"),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showEditDialog(Product product) {
    _nameController.text = product.name;
    _descriptionController.text = product.description;
    _priceController.text = product.price.toString();
    _stockController.text = product.stock.toString();
    _categoryController.text = product.category;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Producto"),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Nombre"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingresa un nombre";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Descripción"),
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: "Precio (€)"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingresa un precio";
                    }
                    if (double.tryParse(value) == null) {
                      return "Ingresa un número válido";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _stockController,
                  decoration: const InputDecoration(labelText: "Stock"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingresa un stock";
                    }
                    if (int.tryParse(value) == null) {
                      return "Ingresa un número válido";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: "Categoría"),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => _updateProduct(product.id),
            child: const Text("Actualizar"),
          ),
        ],
      ),
    );
  }

  void _updateProduct(int productId) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ApiService().updateProduct(
          productId,
          {
            'name': _nameController.text,
            'description': _descriptionController.text,
            'price': double.parse(_priceController.text),
            'stock': int.parse(_stockController.text),
            'category': _categoryController.text,
          },
        );
        Navigator.pop(context);
        loadProducts();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Producto actualizado correctamente"),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}