import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class EventAttendeesScreen extends StatefulWidget {
  final Event event;

  const EventAttendeesScreen({super.key, required this.event});

  @override
  State<EventAttendeesScreen> createState() => _EventAttendeesScreenState();
}

class _EventAttendeesScreenState extends State<EventAttendeesScreen> {
  late Future<List<User>> attendees;

  @override
  void initState() {
    super.initState();
    loadAttendees();
  }

  void loadAttendees() {
    setState(() {
      attendees = ApiService().getAttendeesByEvent(widget.event.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Asistentes - ${widget.event.name}"),
      ),
      body: FutureBuilder<List<User>>(
        future: attendees,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    "No hay asistentes registrados",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final user = data[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${user.points} pts",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
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
}