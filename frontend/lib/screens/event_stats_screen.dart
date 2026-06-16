import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/api_service.dart';

class EventStatsScreen extends StatefulWidget {
  final Event event;

  const EventStatsScreen({super.key, required this.event});

  @override
  State<EventStatsScreen> createState() => _EventStatsScreenState();
}

class _EventStatsScreenState extends State<EventStatsScreen> {
  late Future<Map<String, dynamic>> stats;

  @override
  void initState() {
    super.initState();
    stats = ApiService().getEventStats(widget.event.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Estadísticas - ${widget.event.name}"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: stats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildStatCard(
                  title: "Entradas vendidas",
                  value: data['totalTicketsSold'].toString(),
                  icon: Icons.confirmation_number,
                  color: Colors.blue,
                ),
                const SizedBox(height: 20),
                _buildStatCard(
                  title: "Asistentes",
                  value: data['totalAttendees'].toString(),
                  icon: Icons.people,
                  color: Colors.green,
                ),
                const SizedBox(height: 20),
                _buildStatCard(
                  title: "Ingresos totales",
                  value: "${data['totalRevenue'].toStringAsFixed(2)} €",
                  icon: Icons.euro,
                  color: Colors.orange,
                ),
                const SizedBox(height: 20),
                _buildStatCard(
                  title: "Aforo disponible",
                  value: "${data['available']}/${data['capacity']}",
                  icon: Icons.event_seat,
                  color: Colors.purple,
                ),
                const SizedBox(height: 30),
                LinearProgressIndicator(
                  value: data['totalTicketsSold'] / data['capacity'],
                  backgroundColor: Colors.grey[300],
                  color: Colors.green,
                  minHeight: 20,
                ),
                const SizedBox(height: 10),
                Text(
                  "Ocupación: ${((data['totalTicketsSold'] / data['capacity']) * 100).toStringAsFixed(1)}%",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
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
}