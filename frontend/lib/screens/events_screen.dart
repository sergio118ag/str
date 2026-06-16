import 'package:flutter/material.dart';

import '../models/event.dart';
import '../services/api_service.dart';
import 'event_detail_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late Future<List<Event>> events;

  @override
  void initState() {
    super.initState();
    events = ApiService().getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Eventos")),

      body: FutureBuilder<List<Event>>(
        future: events,

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
              child: Text("No hay eventos disponibles"),
            );
          }

          return ListView.builder(
            itemCount: data.length,

            itemBuilder: (context, index) {
              final event = data[index];

              return Container(
                margin: const EdgeInsets.all(12),

                child: Card(
                  elevation: 6,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),

                        child: event.imageUrl.isNotEmpty
                            ? Image.network(
                                event.imageUrl,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/event.jpg',
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                'assets/images/event.jpg',
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              event.name,

                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              event.description,

                              style: const TextStyle(fontSize: 16),
                            ),

                            const SizedBox(height: 10),

                            Row(
                              children: [
                                const Icon(Icons.location_on),

                                const SizedBox(width: 5),

                                Expanded(
                                  child: Text(event.location),
                                ),
                              ],
                            ),

                            const SizedBox(height: 5),

                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16),

                                const SizedBox(width: 5),

                                Text(event.eventDate),
                              ],
                            ),

                            const SizedBox(height: 5),

                            Row(
                              children: [
                                const Icon(Icons.people, size: 16),

                                const SizedBox(width: 5),

                                Text(
                                  "Disponibles: ${event.available}/${event.capacity}",
                                  style: TextStyle(
                                    color: event.available > 0 
                                        ? Colors.green 
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            SizedBox(
                              width: double.infinity,

                              child: ElevatedButton(
                                onPressed: event.available > 0
                                    ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EventDetailScreen(event: event),
                                          ),
                                        );
                                      }
                                    : null,

                                child: Text(
                                  event.available > 0 
                                      ? "Ver evento" 
                                      : "Agotado",
                                ),
                              ),
                            ),
                          ],
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