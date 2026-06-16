import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController postalCodeController;
  late TextEditingController cityController;
  late TextEditingController ageController;
  late TextEditingController phoneController;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.user.name,
    );

    emailController = TextEditingController(
      text: widget.user.email,
    );

    addressController = TextEditingController(
      text: widget.user.address,
    );

    postalCodeController = TextEditingController(
      text: widget.user.postalCode,
    );

    cityController = TextEditingController(
      text: widget.user.city,
    );

    ageController = TextEditingController(
      text: widget.user.age.toString(),
    );

    phoneController = TextEditingController(
      text: widget.user.phone,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi perfil"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    child: Icon(
                      Icons.person,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                            "${widget.user.points} puntos",
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
            const SizedBox(width: 40),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Nombre",
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: "Dirección",
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: postalCodeController,
                    decoration: const InputDecoration(
                      labelText: "Código postal",
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      labelText: "Ciudad",
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Edad",
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: "Teléfono",
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
                                User updatedUser = User(
                                  id: widget.user.id,
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: widget.user.password,
                                  points: widget.user.points,
                                  address: addressController.text,
                                  postalCode: postalCodeController.text,
                                  city: cityController.text,
                                  age: int.tryParse(ageController.text) ?? 0,
                                  phone: phoneController.text,
                                );

                                final savedUser = await ApiService().updateUser(updatedUser);

                                if (context.mounted) {
                                  Navigator.pop(context, savedUser);
                                  
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Perfil actualizado correctamente"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString()),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              }
                            },
                      child: loading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text("Guardar cambios"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    postalCodeController.dispose();
    cityController.dispose();
    ageController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}