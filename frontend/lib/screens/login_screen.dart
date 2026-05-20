import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Iniciar sesión"),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.person,
              size: 100,
              color: Colors.purple,
            ),

            const SizedBox(height: 30),

            TextField(

              controller: emailController,

              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(

              controller:
                  passwordController,

              obscureText: true,

              decoration: const InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,
              height: 55,

              child: ElevatedButton(

                onPressed: loading
                    ? null
                    : () async {

                        setState(() {
                          loading = true;
                        });

                        try {

                          User user =
                              await ApiService()
                                  .login(

                            emailController.text,
                            passwordController.text,
                          );

                          Navigator.pushReplacement(

                            context,

                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      HomeScreen(
                                user: user,
                              ),
                            ),
                          );

                        } catch (e) {

                          ScaffoldMessenger.of(
                                  context)
                              .showSnackBar(

                            SnackBar(
                              content: Text(
                                e.toString(),
                              ),
                            ),
                          );
                        }

                        setState(() {
                          loading = false;
                        });
                      },

                child: loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Entrar",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}