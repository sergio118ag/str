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
  final _qrController = TextEditingController();
  final _userIdController = TextEditingController();
  final _eventIdController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedType = 'PLÁSTICO';
  bool _isLoading = false;
  bool _isScanning = false;
  String _result = '';
  String _scannedProduct = '';

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

              // QR Scanner
              Card(
                elevation: 4,
                color: Colors.purple[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _qrController,
                              decoration: const InputDecoration(
                                labelText: "Código QR del producto",
                                border: OutlineInputBorder(),
                                hintText: "Ej: ticket-1234567890",
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: _isScanning ? null : _scanQR,
                            icon: const Icon(Icons.qr_code_scanner),
                            label: Text(_isScanning ? "Buscando..." : "Escanear"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      if (_scannedProduct.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Producto: $_scannedProduct",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Divider(thickness: 1),
              const SizedBox(height: 20),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _userIdController,
                      decoration: const InputDecoration(
                        labelText: "ID del Usuario (autocompletado)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _eventIdController,
                      decoration: const InputDecoration(
                        labelText: "ID del Evento (autocompletado)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: "Ubicación del residuo",
                        border: OutlineInputBorder(),
                        hintText: "Ej: Zona A, entrada principal",
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

  Future<void> _scanQR() async {
    final qrCode = _qrController.text.trim();
    if (qrCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Introduce un código QR"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isScanning = true;
      _result = '';
    });

    try {
      final info = await ApiService().getPurchaseInfoByQR(qrCode);

      setState(() {
        _userIdController.text = info['userId'].toString();
        _eventIdController.text = info['eventId'].toString();
        _scannedProduct = "${info['productName']} (${info['price']}€) - ${info['userName']}";
        _result = " Producto identificado: ${info['productName']}\n"
                  "Usuario: ${info['userName']}\n"
                  "Evento: ${info['eventName']}";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("QR escaneado correctamente"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _result = " ${e.toString()}";
        _scannedProduct = '';
      });
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
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

        _locationController.clear();
        _qrController.clear();
        _scannedProduct = '';
        _userIdController.clear();
        _eventIdController.clear();

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
    _qrController.dispose();
    _userIdController.dispose();
    _eventIdController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}