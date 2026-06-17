import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/api_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'event_management_screen.dart';
import 'admin_screen.dart';
import 'role_selection_screen.dart';
import '../services/session_service.dart';
import 'staff_screen.dart'; 

class LoginScreen extends StatefulWidget {
  final String role;

  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {

    // Verificar si el rol es asistente para mostrar el botón de registro
    bool showRegister = widget.role == 'asistente';

    return Scaffold(

      appBar: AppBar(
        title: const Text("Iniciar sesión"),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

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
              controller: passwordController,
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
                onPressed: loading ? null : () async {
                  setState(() {
                    loading = true;
                  });

                  try {
                    User user = await ApiService().login(
                      emailController.text,
                      passwordController.text,
                    );
                    await SessionService().saveUserId(user.id);

                    if (context.mounted) {
                      _navigateByRole(context, user);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
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
                    : const Text(
                        "Iniciar sesión",
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),

            const SizedBox(height: 15),

            // Mostrar "Registrarse" solo si es asistente
            if (showRegister)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegisterScreen(role: widget.role),
                    ),
                  );
                },
                child: const Text("Registrarse"),
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
    );
  }

  void _navigateByRole(BuildContext context, User user) {
    switch (widget.role) {
      case 'asistente':
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
      case 'staff':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StaffScreen(user: user),
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