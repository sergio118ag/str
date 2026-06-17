import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late Future<Map<String, dynamic>> stats;

  @override
  void initState() {
    super.initState();
    stats = ApiService().getDashboardStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel de Control"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                stats = ApiService().getDashboardStats();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: stats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 60, color: Colors.red[300]),
                  const SizedBox(height: 20),
                  Text(
                    snapshot.error.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }
          final data = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildStatCard(
                      title: "Usuarios",
                      value: data['totalUsers'].toString(),
                      icon: Icons.people,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 10),
                    _buildStatCard(
                      title: "Puntos totales",
                      value: data['totalPoints'].toString(),
                      icon: Icons.stars,
                      color: Colors.amber,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildStatCard(
                      title: "Eventos",
                      value: "${data['activeEvents']}/${data['totalEvents']}",
                      icon: Icons.event,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 10),
                    _buildStatCard(
                      title: "Ingresos",
                      value: "${data['totalRevenue'].toStringAsFixed(2)} €",
                      icon: Icons.euro,
                      color: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildStatCard(
                      title: "Compras",
                      value: data['totalPurchases'].toString(),
                      icon: Icons.shopping_cart,
                      color: Colors.purple,
                    ),
                    const SizedBox(width: 10),
                    _buildStatCard(
                      title: "Asistentes",
                      value: data['totalAsistentes'].toString(),
                      icon: Icons.person,
                      color: Colors.teal,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Distribución de Roles",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildRoleRow(
                          label: "Administradores",
                          count: data['totalAdmins'],
                          color: Colors.red,
                        ),
                        _buildRoleRow(
                          label: "Organizadores",
                          count: data['totalOrganizadores'],
                          color: Colors.orange,
                        ),
                        _buildRoleRow(
                          label: "Staff",
                          count: data['totalStaff'],
                          color: Colors.purple,
                        ),
                        _buildRoleRow(
                          label: "Asistentes",
                          count: data['totalAsistentes'],
                          color: Colors.blue,
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

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: color),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleRow({
    required String label,
    required int count,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label),
          ),
          Text(
            count.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}