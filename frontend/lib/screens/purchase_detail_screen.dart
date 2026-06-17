import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/purchase.dart';

class PurchaseDetailScreen extends StatelessWidget {
  final Purchase purchase;

  const PurchaseDetailScreen({
    super.key,
    required this.purchase,
  });

  String _formatDate(String? date) {
    if (date == null) return "";

    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy HH:mm').format(parsed);
    } catch (e) {
      return date;
    }
  }

  String _formatEventDate(String? date) {
    if (date == null) return "";

    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUsed = purchase.used ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle de compra"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                purchase.productName,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Chip(
                label: Text(
                  purchase.ticket != null
                      ? "Entrada"
                      : "Producto",
                ),
              ),

              const SizedBox(height: 20),

              if (purchase.event != null) ...[
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.event),
                    title: const Text("Evento"),
                    subtitle: Text(
                      purchase.event!.name,
                    ),
                  ),
                ),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.location_on),
                    title: const Text("Ubicación"),
                    subtitle: Text(
                      purchase.event!.location,
                    ),
                  ),
                ),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.calendar_month),
                    title: const Text("Fecha del evento"),
                    subtitle: Text(
                      _formatEventDate(
                        purchase.event!.eventDate,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 10),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text("Compra realizada"),
                  subtitle: Text(
                    _formatDate(
                      purchase.date,
                    ),
                  ),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.confirmation_number,
                  ),
                  title: const Text("Estado"),
                  subtitle: Align(
                    alignment: Alignment.centerLeft,
                    child: Chip(
                      avatar: Icon(
                        isUsed
                            ? Icons.cancel
                            : Icons.check_circle,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: Text(
                        isUsed
                            ? "Utilizada"
                            : "Disponible",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor:
                          isUsed
                              ? Colors.red
                              : Colors.green,
                    ),
                  ),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.euro),
                  title: const Text("Precio"),
                  subtitle: Text(
                    "${purchase.price.toStringAsFixed(2)} €",
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Código QR",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // IMAGEN QR
                      Image.network(
                        "http://localhost:8080/purchases/qr-image/${purchase.id}",
                        height: 220,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 220,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Text(
                                "No se pudo cargar el QR",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      // TEXTO DEL CÓDIGO QR
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.qr_code,
                              color: Colors.purple,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SelectableText(
                                purchase.qrCode ?? 'Sin código QR',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Muestra este código al staff para validar tu compra",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}