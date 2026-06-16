import 'package:flutter/material.dart';
import '../models/purchase.dart';
import '../services/api_service.dart';
import '../services/session_service.dart';
import 'purchase_detail_screen.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({super.key});

  @override
  State createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  late Future<List<Purchase>> purchases;

  @override
  void initState() {
    super.initState();
    loadPurchases();
  }

  Future<void> loadPurchases() async {
    final userId = await SessionService().getUserId();
    if (userId != null) {
      purchases = ApiService().getPurchasesByUser(userId);
    } else {
      purchases = Future.value([]);
    }
    setState(() {});
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

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data ?? [];

          final tickets =
              data.where((p) => p.ticket != null).toList();

          final products =
              data.where((p) => p.ticket == null).toList();

          return DefaultTabController(
            length: 2,
            child: Column(
              children: [

                const TabBar(
                  tabs: [
                    Tab(text: "Entradas"),
                    Tab(text: "Productos"),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                    children: [

                      // Entradas
                      tickets.isEmpty
                          ? const Center(child: Text("No has comprado entradas"))
                          : ListView.builder(
                            itemCount: tickets.length,
                            itemBuilder: (context, index) {
                              final purchase = tickets[index];

                              return Card(
                                child: ListTile(
                                  title: Text(purchase.productName),
                                  subtitle: Text("${purchase.price.toStringAsFixed(2)} €"),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PurchaseDetailScreen(
                                          purchase: purchase,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),

                      // Productos
                      products.isEmpty
                          ? const Center(child: Text("No has comprado productos"))
                          : ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final purchase = products[index];

                              return Card(
                                child: ListTile(
                                  title: Text(purchase.productName),
                                  subtitle: Text("${purchase.price.toStringAsFixed(2)} €"),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PurchaseDetailScreen(
                                          purchase: purchase,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}