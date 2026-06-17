import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  late Future<List<User>> users;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void loadUsers() {
    setState(() {
      users = ApiService().getAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestionar Usuarios"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadUsers,
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(
              child: Text("No hay usuarios registrados"),
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final user = data[index];
              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 4,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getRoleColor(user.role),
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.email),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getRoleColor(user.role).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _getRoleName(user.role),
                          style: TextStyle(
                            fontSize: 12,
                            color: _getRoleColor(user.role),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.admin_panel_settings, color: Colors.blue),
                        onPressed: () {
                          _showChangeRoleDialog(context, user);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmation(context, user);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'event_manager':
        return Colors.orange;
      case 'staff':
        return Colors.purple;
      case 'asistente':
      default:
        return Colors.blue;
    }
  }

  String _getRoleName(String role) {
    switch (role) {
      case 'admin':
        return 'Administrador';
      case 'event_manager':
        return 'Organizador';
      case 'staff':
        return 'Staff';
      case 'asistente':
      default:
        return 'Asistente';
    }
  }

  void _showChangeRoleDialog(BuildContext context, User user) {
    String selectedRole = user.role;
    final List<String> roles = ['asistente', 'event_manager', 'staff', 'admin'];
    final List<String> roleNames = ['Asistente', 'Organizador', 'Staff', 'Administrador'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Cambiar rol de ${user.name}"),
        content: DropdownButtonFormField<String>(
          value: selectedRole,
          decoration: const InputDecoration(
            labelText: "Selecciona un rol",
            border: OutlineInputBorder(),
          ),
          items: roles.asMap().entries.map((entry) {
            int index = entry.key;
            String role = entry.value;
            return DropdownMenuItem<String>(
              value: role,
              child: Text(roleNames[index]),
            );
          }).toList(),
          onChanged: (String? newValue) {
            selectedRole = newValue!;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ApiService().updateUserRole(user.id, selectedRole);
                loadUsers();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Rol actualizado correctamente"),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("Actualizar"),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar eliminación"),
        content: Text("¿Seguro que quieres eliminar al usuario ${user.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ApiService().deleteUser(user.id);
                loadUsers();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Usuario eliminado correctamente"),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );
  }
}