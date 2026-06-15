import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final nameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final addressController =
      TextEditingController();

  final postalCodeController =
      TextEditingController();

  final cityController =
      TextEditingController();

  final ageController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Registro"),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(

          child: Column(

            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              TextField(

                controller: nameController,

                decoration: const InputDecoration(
                  labelText: "Nombre",
                ),
              ),

              const SizedBox(height: 20),

              TextField(

                controller: emailController,

                decoration: const InputDecoration(
                  labelText: "Email",
                ),
              ),

              const SizedBox(height: 20),

              TextField(

                controller: passwordController,

                obscureText: true,

                decoration: const InputDecoration(
                  labelText: "Contraseña",
                ),
              ),

              const SizedBox(height: 20),

              TextField(

                controller: addressController,

                decoration: const InputDecoration(
                  labelText: "Dirección",
                ),
              ),

              const SizedBox(height: 20),

              TextField(

                controller: postalCodeController,

                decoration: const InputDecoration(
                  labelText: "Código postal",
                ),
              ),

              const SizedBox(height: 20),

              TextField(

                controller: cityController,

                decoration: const InputDecoration(
                  labelText: "Ciudad",
                ),
              ),

              const SizedBox(height: 20),

              TextField(

                controller: ageController,

                keyboardType:
                    TextInputType.number,

                decoration: const InputDecoration(
                  labelText: "Edad",
                ),
              ),

              const SizedBox(height: 20),

              TextField(

                controller: phoneController,

                keyboardType:
                    TextInputType.phone,

                decoration: const InputDecoration(
                  labelText: "Teléfono",
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,

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
                                    .register(

                              nameController.text,
                              emailController.text,
                              passwordController.text,

                              addressController.text,
                              postalCodeController.text,
                              cityController.text,

                              int.tryParse(
                                    ageController.text,
                                  ) ??
                                  0,

                              phoneController.text,
                            );

                            Navigator.pushReplacement(

                              context,

                              MaterialPageRoute(
                                builder: (_) =>
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

                          } finally {

                            setState(() {
                              loading = false;
                            });
                          }
                        },

                  child: loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Registrarse",
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