import 'package:flutter/material.dart';

import '../models/user.dart';

import 'events_screen.dart';
import 'purchases_screen.dart';
import 'profile_screen.dart';
import 'rewards_screen.dart';
import 'my_rewards_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {

  final User user;

  const HomeScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "STR Eventos",
        ),

        centerTitle: true,

        actions: [

          IconButton(

            onPressed: () {

              Navigator.pushReplacement(

                context,

                MaterialPageRoute(
                  builder: (context) =>
                      const LoginScreen(),
                ),
              );
            },

            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Text(

              "Bienvenido ${user.name}",

              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(

              "Gestiona tus eventos, compras y recompensas",

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(

              width: double.infinity,
              height: 70,

              child: ElevatedButton.icon(

                icon: const Icon(
                  Icons.event,
                ),

                label: const Text(
                  "Ver eventos",

                  style: TextStyle(
                    fontSize: 20,
                  ),
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

                icon: const Icon(
                  Icons.shopping_cart,
                ),

                label: const Text(
                  "Mis compras",

                  style: TextStyle(
                    fontSize: 20,
                  ),
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

                icon: const Icon(
                  Icons.person,
                ),

                label: const Text(
                  "Mi perfil",

                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                onPressed: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(
                        user: user,
                      ),
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

                icon: const Icon(
                  Icons.card_giftcard,
                ),

                label: const Text(
                  "Recompensas",

                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                onPressed: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(
                      builder: (context) =>
                          RewardsScreen(
                        user: user,
                      ),
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

                icon: const Icon(
                  Icons.redeem,
                ),

                label: const Text(
                  "Mis recompensas",

                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                onPressed: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(
                      builder: (context) =>
                          MyRewardsScreen(
                        user: user,
                      ),
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