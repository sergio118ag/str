import 'package:flutter/material.dart';

import '../models/event.dart';
import '../services/api_service.dart';

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

      appBar: AppBar(
        title: const Text("Eventos"),
      ),

      body: FutureBuilder<List<Event>>(

        future: events,

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {

            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final data = snapshot.data!;

          return ListView.builder(

            itemCount: data.length,

            itemBuilder: (context, index) {

              final event = data[index];

              return Card(

                margin: const EdgeInsets.all(10),

                child: ListTile(

                  title: Text(event.name),

                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Text(event.description),
                      Text(event.location),

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