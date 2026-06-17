import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/session_service.dart';
import 'role_selection_screen.dart';
import 'qr_scanner_screen.dart';
import 'incident_screen.dart';
import 'waste_screen.dart';
import 'staff_events_screen.dart';

class StaffScreen extends StatefulWidget {
  final User user;

  const StaffScreen({super.key, required this.user});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel de Staff"),
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
              "Panel de Staff",
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
            _buildStaffButton(
              icon: Icons.qr_code_scanner,
              title: "Escanear QR",
              subtitle: "Validar entradas, productos y recompensas",
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QRScannerScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildStaffButton(
              icon: Icons.warning_amber_rounded,
              title: "Gestionar Incidencias",
              subtitle: "Registrar incidencias durante eventos",
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IncidentScreen(user: widget.user),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildStaffButton(
              icon: Icons.recycling,
              title: "Trazabilidad de Residuos",
              subtitle: "Escanear y gestionar residuos",
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WasteScreen(user: widget.user),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildStaffButton(
              icon: Icons.event_note,
              title: "Eventos",
              subtitle: "Consultar eventos donde prestas servicio",
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StaffEventsScreen(user: widget.user),
                    ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffButton({
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