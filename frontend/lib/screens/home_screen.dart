import 'package:flutter/material.dart';
import '../models/purchase.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
        title: const Text("STR Eventos"),
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

              return ListTile(
                title: Text(purchase.productName),
                subtitle: Text("${purchase.price} €"),
              );
            },
          );
        },
      ),
    );
  }
}