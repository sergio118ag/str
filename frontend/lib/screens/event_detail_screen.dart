import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/ticket.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/session_service.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;
  final User? user;

  const EventDetailScreen({
    super.key,
    required this.event,
    this.user,
  });

  @override
  State createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late Future<List<Ticket>> tickets;
  late Future<Event> eventFuture;
  User? _currentUser;
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadUser();
  }

  void _loadData() {
    tickets = ApiService().getTicketsByEvent(widget.event.id);
    eventFuture = ApiService().getEventById(widget.event.id);
  }

  Future<void> _loadUser() async {
    // Si el usuario viene por parámetro, lo usamos
    if (widget.user != null) {
      setState(() {
        _currentUser = widget.user;
        _isLoadingUser = false;
      });
      print("=== USUARIO DESDE PARÁMETRO ===");
      print("Nombre: ${_currentUser?.name}");
      print("Rol: ${_currentUser?.role}");
      return;
    }

    // Si no viene por parámetro, lo obtenemos de la sesión
    final userId = await SessionService().getUserId();
    if (userId != null) {
      try {
        final user = await ApiService().getUserById(userId);
        setState(() {
          _currentUser = user;
          _isLoadingUser = false;
        });
        print("=== USUARIO DESDE SESIÓN ===");
        print("Nombre: ${_currentUser?.name}");
        print("Rol: ${_currentUser?.role}");
      } catch (e) {
        print("Error al cargar usuario: $e");
        setState(() {
          _isLoadingUser = false;
        });
      }
    } else {
      setState(() {
        _isLoadingUser = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _loadData();
    });
    await _loadUser();
  }

  Future<void> buyTicket(Ticket ticket) async {
    final userId = await SessionService().getUserId();

    if (userId == null) {
      throw Exception("Usuario no identificado");
    }

    await ApiService().buyTicket(userId, ticket.id);

    _refreshData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Compra realizada: ${ticket.name}")),
      );
    }
  }

  bool _isOrganizerOrStaff() {
    String? role = _currentUser?.role;
    return role == 'event_manager' || role == 'admin' || role == 'staff';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Image.asset(
                'assets/images/event.jpg',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.event.name,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(widget.event.description),
                    const SizedBox(height: 30),
                    const Text(
                      "Entradas disponibles",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<List<Ticket>>(
                      future: tickets,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }

                        final list = snapshot.data ?? [];

                        if (list.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "No hay entradas disponibles para este evento",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          );
                        }

                        return Column(
                          children: list.map((ticket) {
                            bool isAvailable = ticket.available > 0;
                            bool showBuyButton = !_isOrganizerOrStaff() && isAvailable;

                            return Card(
                              child: ListTile(
                                title: Text(ticket.name),
                                subtitle: Text(
                                  "${ticket.price} € - Disponibles: ${ticket.available}",
                                ),
                                trailing: _isOrganizerOrStaff()
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          "Solo para asistentes",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      )
                                    : ElevatedButton(
                                        onPressed: showBuyButton
                                            ? () => buyTicket(ticket)
                                            : null,
                                        child: Text(
                                          showBuyButton
                                              ? "Comprar"
                                              : "Agotado",
                                        ),
                                      ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}