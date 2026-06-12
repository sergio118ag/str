import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/ticket.dart';
import '../services/api_service.dart';
import '../services/session_service.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({
    super.key,
    required this.event,
  });

  @override
  State createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late Future<List<Ticket>> tickets;

  @override
  void initState() {
    super.initState();
    tickets = ApiService().getTicketsByEvent(widget.event.id);
  }

  Future buyTicket(Ticket ticket) async {
    final userId = await SessionService().getUserId();

    if (userId == null) {
      throw Exception("Usuario no identificado");
    }

    await ApiService().buyTicket(userId, ticket.id);

    setState(() {
      tickets = ApiService().getTicketsByEvent(widget.event.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Compra realizada: ${ticket.name}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name),
      ),
      body: SingleChildScrollView(
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
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }

                      final list = snapshot.data ?? [];

                      return Column(
                        children: list.map((ticket) {
                          return Card(
                            child: ListTile(
                              title: Text(ticket.name),
                              subtitle: Text(
                                "${ticket.price} € - Disponibles: ${ticket.available}",
                              ),
                              trailing: ElevatedButton(
                                onPressed: ticket.available > 0
                                    ? () => buyTicket(ticket)
                                    : null,
                                child: Text(
                                  ticket.available > 0
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
    );
  }
}