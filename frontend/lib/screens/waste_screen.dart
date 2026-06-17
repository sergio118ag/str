import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class WasteScreen extends StatefulWidget {
  final User user;

  const WasteScreen({super.key, required this.user});

  @override
  State<WasteScreen> createState() => _WasteScreenState();
}

class _WasteScreenState extends State<WasteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _eventIdController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedType = 'PLÁSTICO';
  bool _isLoading = false;
  String _result = '';

  final List<String> _types = ['PLÁSTICO', 'VIDRIO', 'PAPEL', 'ORGÁNICO', 'OTRO'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trazabilidad de Residuos"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Registrar Residuo",
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
                      controller: _userIdController,
                      decoration: const InputDecoration(
                        labelText: "ID del Usuario",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingresa el ID del usuario";
                        }
                        if (int.tryParse(value) == null) {
                          return "Ingresa un número válido";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _eventIdController,
                      decoration: const InputDecoration(
                        labelText: "ID del Evento",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingresa el ID del evento";
                        }
                        if (int.tryParse(value) == null) {
                          return "Ingresa un número válido";
                        }
                        return null;
                      },
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
                          return "Ingresa la ubicación";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: const InputDecoration(
                        labelText: "Tipo de Residuo",
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
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createWaste,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Registrar Residuo"),
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

  Future<void> _createWaste() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _result = '';
      });

      try {
        final waste = await ApiService().createWaste(
          int.parse(_userIdController.text),
          int.parse(_eventIdController.text),
          _locationController.text,
          _selectedType,
        );

        setState(() {
          _result = "✅ Residuo registrado correctamente\n"
                    "ID: ${waste.id}\n"
                    "Tipo: ${waste.type}\n"
                    "Código QR: ${waste.qrCode}";
        });

        _userIdController.clear();
        _eventIdController.clear();
        _locationController.clear();

      } catch (e) {
        setState(() {
          _result = "❌ ${e.toString()}";
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
    _userIdController.dispose();
    _eventIdController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}