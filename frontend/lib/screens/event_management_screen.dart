import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'event_create_screen.dart';
import 'event_edit_screen.dart';
import 'event_detail_screen.dart';
import 'role_selection_screen.dart';
import '../services/session_service.dart';

class EventManagementScreen extends StatefulWidget {
  final User user;
  
  const EventManagementScreen({super.key, required this.user});

  @override
  State<EventManagementScreen> createState() => _EventManagementScreenState();
}

class _EventManagementScreenState extends State<EventManagementScreen> {
  late Future<List<Event>> events;

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    setState(() {
      events = ApiService().getEventsByOrganizer(widget.user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Eventos"),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_note, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    "No tienes eventos creados",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Presiona el botón + para crear uno",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: loadEvents,
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final event = data[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 4,
                  child: ListTile(
                    leading: event.imageUrl.isNotEmpty
                        ? Image.network(
                            event.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(Icons.event),
                              );
                            },
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[300],
                            child: const Icon(Icons.event),
                          ),
                    title: Text(
                      event.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.location),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.people, size: 14),
                            const SizedBox(width: 5),
                            Text(
                              "Aforo: ${event.available}/${event.capacity}",
                              style: TextStyle(
                                color: event.available > 0 
                                    ? Colors.green 
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventEditScreen(
                                  event: event,
                                ),
                              ),
                            );
                            if (result == true) {
                              loadEvents();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Confirmar eliminación"),
                                content: Text("¿Seguro que quieres eliminar el evento ${event.name}?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text("Cancelar"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text("Eliminar"),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              try {
                                await ApiService().deleteEvent(event.id);
                                loadEvents();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Evento eliminado correctamente"),
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
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailScreen(
                            event: event,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventCreateScreen(
                organizerId: widget.user.id,
              ),
            ),
          );
          if (result == true) {
            loadEvents();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}