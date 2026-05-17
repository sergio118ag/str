import 'package:flutter/material.dart';

import '../models/event.dart';

class EventDetailScreen extends StatelessWidget {

  final Event event;

  const EventDetailScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(event.name),
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
                    event.name,

                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    event.description,

                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [

                      const Icon(Icons.location_on),

                      const SizedBox(width: 10),

                      Text(
                        event.location,

                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(

                      onPressed: () {},

                      child: const Text(
                        "Comprar entrada",
                        style: TextStyle(fontSize: 20),
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
  }
}