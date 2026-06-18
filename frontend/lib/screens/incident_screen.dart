import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class IncidentScreen extends StatefulWidget {
  final User user;

  const IncidentScreen({super.key, required this.user});

  @override
  State<IncidentScreen> createState() => _IncidentScreenState();
}

class _IncidentScreenState extends State<IncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();
  final _eventNameController = TextEditingController();
  final _pointsController = TextEditingController();

  String _selectedType = 'COMPORTAMIENTO';
  bool _isLoading = false;
  String _result = '';

  final List<String> _types = ['COMPORTAMIENTO', 'RESIDUO', 'OTRO'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestionar Incidencias"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Registrar Nueva Incidencia",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: "Título",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingresa un título";
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingresa una descripción";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email del Usuario",
                        border: OutlineInputBorder(),
                        hintText: "ejemplo@email.com",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingresa el email del usuario";
                        }
                        if (!value.contains('@')) {
                          return "Ingresa un email válido";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _eventNameController,
                      decoration: const InputDecoration(
                        labelText: "Nombre del Evento",
                        border: OutlineInputBorder(),
                        hintText: "Ej: Concierto Dua Lipa",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingresa el nombre del evento";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: const InputDecoration(
                        labelText: "Tipo de Incidencia",
                        border: OutlineInputBorder(),
                      ),
                      items: _types.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedType = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _pointsController,
                      decoration: const InputDecoration(
                        labelText: "Penalización (puntos)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createIncident,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Registrar Incidencia"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_result.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _result.contains("✅") 
                              ? Colors.green[50] 
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _result.contains("✅") 
                                ? Colors.green 
                                : Colors.red,
                          ),
                        ),
                        child: Text(
                          _result,
                          style: TextStyle(
                            fontSize: 16,
                            color: _result.contains("✅") 
                                ? Colors.green[800] 
                                : Colors.red[800],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createIncident() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _result = '';
      });

      try {
        final incident = await ApiService().createIncident(
          _emailController.text,
          widget.user.id,
          _eventNameController.text,
          _titleController.text,
          _descriptionController.text,
          _selectedType,
          int.tryParse(_pointsController.text) ?? 0,
        );

        setState(() {
          _result = "Incidencia registrada correctamente\n"
                    "ID: ${incident.id}\n"
                    "Título: ${incident.title}\n"
                    "Estado: ${incident.status}";
        });

        _titleController.clear();
        _descriptionController.clear();
        _emailController.clear();
        _eventNameController.clear();
        _pointsController.clear();

      } catch (e) {
        setState(() {
          _result = " ${e.toString()}";
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _eventNameController.dispose();
    _pointsController.dispose();
    super.dispose();
  }
}