import 'package:flutter/material.dart';

import '../models/event.dart';
import '../models/ticket.dart';
import '../services/api_service.dart';

class EventDetailScreen extends StatefulWidget {

  final Event event;

  const EventDetailScreen({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailScreen> createState() =>
      _EventDetailScreenState();
}

class _EventDetailScreenState
    extends State<EventDetailScreen> {

  late Future<List<Ticket>> tickets;

  @override
  void initState() {

    super.initState();

    tickets = ApiService()
        .getTicketsByEvent(
      widget.event.id,
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
          crossAxisAlignment:
              CrossAxisAlignment.start,

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

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    widget.event.name,

                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    widget.event.description,

                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [

                      const Icon(
                        Icons.location_on,
                      ),

                      const SizedBox(width: 10),

                      Text(
                        widget.event.location,

                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Entradas disponibles",

                    style: TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  FutureBuilder<List<Ticket>>(

                    future: tickets,

                    builder:
                        (context, snapshot) {

                      if (snapshot
                              .connectionState ==
                          ConnectionState
                              .waiting) {

                        return const Center(
                          child:
                              CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {

                        return Text(
                          snapshot.error
                              .toString(),
                        );
                      }

                      final ticketList =
                          snapshot.data!;

                      return Column(

                        children:
                            ticketList.map(

                          (ticket) {

                            return Card(

                              margin:
                                  const EdgeInsets.only(
                                bottom: 15,
                              ),

                              child: ListTile(

                                title: Text(
                                  ticket.name,
                                ),

                                subtitle: Text(
                                  "${ticket.price} €",
                                ),

                                trailing:
                                    ElevatedButton(

                                  onPressed: () {

                                    ScaffoldMessenger.of(
                                            context)
                                        .showSnackBar(

                                      SnackBar(
                                        content: Text(
                                          "Comprar ${ticket.name}",
                                        ),
                                      ),
                                    );
                                  },

                                  child:
                                      const Text(
                                    "Comprar",
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
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