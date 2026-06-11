import 'package:flutter/material.dart';
import '../models/purchase.dart';

class PurchaseDetailScreen extends StatelessWidget {

  final Purchase purchase;

  const PurchaseDetailScreen({
    super.key,
    required this.purchase,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Detalle de compra"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              purchase.productName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Precio: ${purchase.price} €",
              style: const TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 20),

            const Text(
              "Código QR",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Image.network(
                "http://localhost:8080/purchases/qr-image/${purchase.id}",
                height: 250,
              ),
            ),
          ],
        ),
      ),
    );
  }
}