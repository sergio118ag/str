import 'package:flutter/material.dart';

import 'events_screen.dart';
import 'purchases_screen.dart';
import 'profile_screen.dart';
import 'rewards_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("STR Eventos"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            SizedBox(
              width: double.infinity,
              height: 70,

              child: ElevatedButton.icon(

                icon: const Icon(Icons.event),

                label: const Text(
                  "Ver eventos",
                  style: TextStyle(fontSize: 20),
                ),

                onPressed: () {

                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (context) =>
                          const EventsScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 70,

              child: ElevatedButton.icon(

                icon: const Icon(Icons.shopping_cart),

                label: const Text(
                  "Mis compras",
                  style: TextStyle(fontSize: 20),
                ),

                onPressed: () {

                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (context) =>
                          const PurchasesScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 70,

              child: ElevatedButton.icon(

                icon: const Icon(Icons.person),

                label: const Text(
                  "Mi perfil",
                  style: TextStyle(fontSize: 20),
                ),

                onPressed: () {

                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (context) =>
                          const ProfileScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 70,

              child: ElevatedButton.icon(

                icon: const Icon(Icons.card_giftcard),

                label: const Text(
                  "Recompensas",
                  style: TextStyle(fontSize: 20),
                ),

                onPressed: () {

                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (context) =>
                          const RewardsScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}