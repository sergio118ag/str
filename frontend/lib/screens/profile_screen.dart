import 'package:flutter/material.dart';

import '../models/user.dart';

class ProfileScreen extends StatelessWidget {

  final User user;

  const ProfileScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Mi perfil"),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            const CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              user.name,

              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              user.email,

              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 30),

            Card(

              elevation: 5,

              child: Padding(

                padding: const EdgeInsets.all(20),

                child: Column(

                  children: [

                    const Text(
                      "Puntos actuales",

                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      "${user.points} puntos",

                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}