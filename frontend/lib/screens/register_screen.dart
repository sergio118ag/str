import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/api_service.dart';
import '../services/session_service.dart';
import 'home_screen.dart';
import 'event_management_screen.dart';
import 'admin_screen.dart';
import 'role_selection_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  final String role;

  const RegisterScreen({super.key, required this.role});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final postalCodeController = TextEditingController();
  final cityController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
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
            mainAxisAlignment: MainAxisAlignment.center,
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
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Edad",
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Teléfono",
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : () async {
                    setState(() {
                      loading = true;
                    });

                    try {
                      User user = await ApiService().register(
                        nameController.text,
                        emailController.text,
                        passwordController.text,
                        addressController.text,
                        postalCodeController.text,
                        cityController.text,
                        int.tryParse(ageController.text) ?? 0,
                        phoneController.text,
                      );

                      await SessionService().saveUserId(user.id);

                      if (context.mounted) {
                        _navigateByRole(context, user);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    } finally {
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Registrarse"),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(role: widget.role),
                    ),
                  );
                },
                child: const Text("¿Ya tienes cuenta? Inicia sesión"),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RoleSelectionScreen(),
                    ),
                  );
                },
                child: const Text("Volver a seleccionar rol"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateByRole(BuildContext context, User user) {
    switch (widget.role) {
      case 'user':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(user: user),
          ),
        );
        break;
      case 'event_manager':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EventManagementScreen(user: user),
          ),
        );
        break;
      case 'admin':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminScreen(user: user),
          ),
        );
        break;
      default:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(user: user),
          ),
        );
    }
  }
}