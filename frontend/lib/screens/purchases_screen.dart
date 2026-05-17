import 'package:flutter/material.dart';
import '../models/purchase.dart';
import '../services/api_service.dart';
import 'purchase_detail_screen.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({super.key});

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  late Future<List<Purchase>> purchases;

  @override
  void initState() {
    super.initState();
    purchases = ApiService().getPurchases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis compras"),
      ),

      body: FutureBuilder<List<Purchase>>(
        future: purchases,

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {

            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,

            itemBuilder: (context, index) {

              final purchase = data[index];

              return Card(
                margin: const EdgeInsets.all(12),

                child: ListTile(
                  leading: const Icon(Icons.shopping_cart),

                  title: Text(purchase.productName),

                  subtitle: Text("${purchase.price} €"),
                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) => PurchaseDetailScreen(
                          purchase: purchase,
                        ),
                      ),
                    );
                  }
                ),
              );
            },
          );
        },
      ),
    );
  }
}