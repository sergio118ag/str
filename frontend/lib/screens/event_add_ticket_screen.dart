import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/api_service.dart';

class EventAddTicketScreen extends StatefulWidget {
  final Event event;

  const EventAddTicketScreen({super.key, required this.event});

  @override
  State<EventAddTicketScreen> createState() => _EventAddTicketScreenState();
}

class _EventAddTicketScreenState extends State<EventAddTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _availableController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Añadir Entrada - ${widget.event.name}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nombre de la entrada",
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
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: "Precio (€)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
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
              const SizedBox(height: 20),
              TextFormField(
                controller: _availableController,
                decoration: const InputDecoration(
                  labelText: "Cantidad disponible",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingresa una cantidad";
                  }
                  if (int.tryParse(value) == null) {
                    return "Ingresa un número válido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addTicket,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Añadir Entrada"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addTicket() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        await ApiService().createTicket(
          eventId: widget.event.id,
          name: _nameController.text,
          price: double.parse(_priceController.text),
          available: int.parse(_availableController.text),
        );

        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Entrada añadida correctamente"),
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
    _priceController.dispose();
    _availableController.dispose();
    super.dispose();
  }
}