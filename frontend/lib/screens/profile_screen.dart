import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  late Future<User> user;

  @override
  void initState() {
    super.initState();

    user = ApiService().getUserById(1);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Mi perfil"),
      ),

      body: FutureBuilder<User>(

        future: user,

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

          final user = snapshot.data!;

          return Padding(

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
          );
        },
      ),
    );
  }
}