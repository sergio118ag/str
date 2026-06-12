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

              const SizedBox(height: 20),

              if (purchase.event != null) ...[

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.event),
                    title: const Text("Evento"),
                    subtitle: Text(purchase.event!.name),
                  ),
                ),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.location_on),
                    title: const Text("Ubicación"),
                    subtitle: Text(purchase.event!.location),
                  ),
                ),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.calendar_month),
                    title: const Text("Fecha del evento"),
                    subtitle: Text(purchase.event!.eventDate),
                  ),
                ),

              ],

              const SizedBox(height: 10),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text("Compra realizada"),
                  subtitle: Text(_formatDate(purchase.date)),
                ),
              ),

              Card(
                child: ListTile(
                  leading: Icon(
                    isUsed ? Icons.cancel : Icons.check_circle,
                    color: isUsed ? Colors.red : Colors.green,
                  ),
                  title: const Text("Estado"),
                  subtitle: Text(
                    isUsed ? "Utilizada" : "Disponible",
                  ),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.euro),
                  title: const Text("Precio"),
                  subtitle: Text("${purchase.price} €"),
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

                  child: Center(
                    child: Image.network(
                      "http://localhost:8080/purchases/qr-image/${purchase.id}",
                      height: 220,
                    ),
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