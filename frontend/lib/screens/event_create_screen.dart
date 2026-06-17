import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EventCreateScreen extends StatefulWidget {
  final int organizerId;

  const EventCreateScreen({super.key, required this.organizerId});

  @override
  State<EventCreateScreen> createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Datos del evento
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();
  final _eventDateController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageUrlController = TextEditingController();
  
  // Lista de entradas
  List<TicketInput> _tickets = [];
  bool _isLoading = false;
  int _remainingCapacity = 0;

  @override
  void initState() {
    super.initState();
    _addTicket(); // Una entrada por defecto
  }

  void _addTicket() {
    setState(() {
      _tickets.add(TicketInput());
      _updateRemainingCapacity();
    });
  }

  void _removeTicket(int index) {
    setState(() {
      _tickets.removeAt(index);
      _updateRemainingCapacity();
    });
  }

  void _updateRemainingCapacity() {
    int capacity = int.tryParse(_capacityController.text) ?? 0;
    int used = _tickets.fold(0, (sum, ticket) => sum + (ticket.quantity ?? 0));
    _remainingCapacity = capacity - used;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Evento"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // === DATOS DEL EVENTO ===
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Nombre del evento",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingresa un nombre";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Descripción",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: "Ubicación",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingresa una ubicación";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _capacityController,
                        decoration: const InputDecoration(
                          labelText: "Aforo máximo",
                          border: OutlineInputBorder(),
                          hintText: "Ej: 1000",
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _updateRemainingCapacity();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Ingresa un aforo";
                          }
                          if (int.tryParse(value) == null) {
                            return "Número válido";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _eventDateController,
                        decoration: const InputDecoration(
                          labelText: "Fecha (YYYY-MM-DD)",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Ingresa una fecha";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    labelText: "Categoría",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: "URL de la imagen (opcional)",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 30),
                const Divider(thickness: 2),
                const SizedBox(height: 20),

                // === ENTRADAS ===
                Row(
                  children: [
                    const Text(
                      "Tipos de Entrada",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Disponible: $_remainingCapacity",
                      style: TextStyle(
                        fontSize: 16,
                        color: _remainingCapacity >= 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.green, size: 30),
                      onPressed: _remainingCapacity > 0 ? _addTicket : null,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (_tickets.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Añade al menos un tipo de entrada",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),

                ..._tickets.asMap().entries.map((entry) {
                  int index = entry.key;
                  TicketInput ticket = entry.value;
                  return _buildTicketCard(index, ticket);
                }).toList(),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _createEvent,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Crear Evento"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTicketCard(int index, TicketInput ticket) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                initialValue: ticket.name,
                decoration: const InputDecoration(
                  labelText: "Nombre",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                onChanged: (value) {
                  ticket.name = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nombre";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: TextFormField(
                initialValue: ticket.price != null ? ticket.price.toString() : '',
                decoration: const InputDecoration(
                  labelText: "Precio (€)",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  ticket.price = double.tryParse(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Precio";
                  }
                  if (double.tryParse(value) == null) {
                    return "Número";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: TextFormField(
                initialValue: ticket.quantity != null ? ticket.quantity.toString() : '',
                decoration: const InputDecoration(
                  labelText: "Cantidad",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  ticket.quantity = int.tryParse(value);
                  _updateRemainingCapacity();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Cantidad";
                  }
                  if (int.tryParse(value) == null) {
                    return "Número";
                  }
                  int quantity = int.parse(value);
                  if (quantity > _remainingCapacity + (ticket.quantity ?? 0)) {
                    return "Excede aforo";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 5),
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              onPressed: _tickets.length > 1 ? () => _removeTicket(index) : null,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createEvent() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Validar que hay al menos una entrada
      if (_tickets.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Añade al menos un tipo de entrada"),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Validar que la suma de entradas no supere el aforo
      int capacity = int.parse(_capacityController.text);
      int totalTickets = _tickets.fold(0, (sum, t) => sum + (t.quantity ?? 0));
      if (totalTickets > capacity) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("La suma de entradas supera el aforo máximo"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        // 1. Crear el evento
        final eventData = {
          'name': _nameController.text,
          'description': _descriptionController.text,
          'location': _locationController.text,
          'capacity': capacity,
          'ticketPrice': _tickets.first.price ?? 0,
          'eventDate': _eventDateController.text,
          'category': _categoryController.text,
          'imageUrl': _imageUrlController.text,
        };

        final event = await ApiService().createEvent(eventData, widget.organizerId);

        // 2. Crear los tickets
        for (var ticket in _tickets) {
          await ApiService().createTicket(
            eventId: event.id,
            name: ticket.name ?? 'General',
            price: ticket.price ?? 0,
            available: ticket.quantity ?? 0,
          );
        }

        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Evento creado con ${_tickets.length} tipos de entrada",
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    _eventDateController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}

class TicketInput {
  String? name;
  double? price;
  int? quantity;

  TicketInput({this.name = 'General', this.price = 0, this.quantity = 0});
}