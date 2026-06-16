import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/api_service.dart';

class EventEditScreen extends StatefulWidget {
  final Event event;

  const EventEditScreen({super.key, required this.event});

  @override
  State<EventEditScreen> createState() => _EventEditScreenState();
}

class _EventEditScreenState extends State<EventEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _capacityController;
  late TextEditingController _ticketPriceController;
  late TextEditingController _eventDateController;
  late TextEditingController _categoryController;
  late TextEditingController _imageUrlController;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.event.name);
    _descriptionController = TextEditingController(text: widget.event.description);
    _locationController = TextEditingController(text: widget.event.location);
    _capacityController = TextEditingController(text: widget.event.capacity.toString());
    _ticketPriceController = TextEditingController(text: widget.event.ticketPrice.toString());
    _eventDateController = TextEditingController(text: widget.event.eventDate);
    _categoryController = TextEditingController(text: widget.event.category);
    _imageUrlController = TextEditingController(text: widget.event.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Evento"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Nombre del evento",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor ingresa un nombre";
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
                      return "Por favor ingresa una ubicación";
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
                        ),
                        keyboardType: TextInputType.number,
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
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Disponibles",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              "${widget.event.available}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _ticketPriceController,
                  decoration: const InputDecoration(
                    labelText: "Precio entrada (€)",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingresa un precio";
                    }
                    if (double.tryParse(value) == null) {
                      return "Número válido";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _eventDateController,
                  decoration: const InputDecoration(
                    labelText: "Fecha del evento (YYYY-MM-DD)",
                    border: OutlineInputBorder(),
                  ),
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
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _updateEvent,
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text("Actualizar Evento"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: _isLoading ? null : _updateCapacity,
                          child: const Text("Actualizar Aforo"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateEvent() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        final updatedEvent = widget.event.copyWith(
          name: _nameController.text,
          description: _descriptionController.text,
          location: _locationController.text,
          capacity: int.parse(_capacityController.text),
          ticketPrice: double.parse(_ticketPriceController.text),
          eventDate: _eventDateController.text,
          category: _categoryController.text,
          imageUrl: _imageUrlController.text,
        );
        
        await ApiService().updateEvent(widget.event.id, updatedEvent);
        
        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Evento actualizado correctamente"),
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

  Future<void> _updateCapacity() async {
    final newCapacity = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nuevo aforo"),
        content: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Nuevo aforo máximo",
          ),
          onChanged: (value) {
            // No hacemos nada aquí, solo recogemos el valor
          },
          controller: TextEditingController(text: widget.event.capacity.toString()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              final value = int.tryParse(context.findAncestorStateOfType<_EventEditScreenState>()?._capacityController.text ?? '');
              if (value != null && value > 0) {
                Navigator.pop(context, value);
              }
            },
            child: const Text("Actualizar"),
          ),
        ],
      ),
    );

    if (newCapacity != null && mounted) {
      setState(() => _isLoading = true);
      try {
        await ApiService().updateEventCapacity(widget.event.id, newCapacity);
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Aforo actualizado correctamente"),
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
    _ticketPriceController.dispose();
    _eventDateController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}