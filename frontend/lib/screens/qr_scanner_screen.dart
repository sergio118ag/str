import 'package:flutter/material.dart';
import '../services/api_service.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final TextEditingController _qrController = TextEditingController();
  bool _isLoading = false;
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Escanear QR"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.qr_code_scanner,
              size: 100,
              color: Colors.purple,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _qrController,
              decoration: const InputDecoration(
                labelText: "Código QR",
                border: OutlineInputBorder(),
                hintText: "Ej: ticket-1234567890",
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _validateQR,
                icon: const Icon(Icons.check_circle),
                label: Text(
                  _isLoading ? "Validando..." : "Validar QR",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 30),
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
    );
  }

  Future<void> _validateQR() async {
    final qrCode = _qrController.text.trim();
    if (qrCode.isEmpty) {
      setState(() {
        _result = "⚠️ Introduce un código QR";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final purchase = await ApiService().validateQR(qrCode);
      setState(() {
        _result = "✅ QR válido\n"
                  "Producto: ${purchase.productName}\n"
                  "Precio: ${purchase.price} €\n"
                  "Entrada validada correctamente";
      });
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