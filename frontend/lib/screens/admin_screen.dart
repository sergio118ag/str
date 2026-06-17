import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/session_service.dart';
import 'role_selection_screen.dart';
import 'event_management_screen.dart';
import 'admin_users_screen.dart';
import 'admin_rewards_screen.dart';

class AdminScreen extends StatefulWidget {
  final User user;

  const AdminScreen({super.key, required this.user});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel de Administración"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await SessionService().logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RoleSelectionScreen(),
                  ),
                );
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Panel de Administración",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Bienvenido ${widget.user.name}",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            _buildAdminButton(
              icon: Icons.people,
              title: "Gestionar Usuarios",
              subtitle: "Ver, editar y eliminar usuarios",
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminUsersScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildAdminButton(
              icon: Icons.event_note,
              title: "Gestionar Eventos",
              subtitle: "Crear, editar y eliminar eventos",
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventManagementScreen(
                      user: widget.user,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildAdminButton(
              icon: Icons.card_giftcard,
              title: "Gestionar Recompensas",
              subtitle: "Crear y gestionar recompensas",
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminRewardsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildAdminButton(
              icon: Icons.score,
              title: "Gestionar Puntos",
              subtitle: "Ver y ajustar puntos de usuarios",
              color: Colors.purple,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Función en desarrollo"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 28, color: color),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}