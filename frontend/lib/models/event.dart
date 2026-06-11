class Event {

  final int id;
  final String name;
  final String description;
  final String location;
  final double ticketPrice;
  final int capacity;
  final String eventDate;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.ticketPrice,
    required this.capacity,
    required this.eventDate,
  });

  factory Event.fromJson(Map<String, dynamic> json) {

    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      location: json['location'],
      ticketPrice: json['ticketPrice'].toDouble(),
      capacity: json['capacity'],
      eventDate: json['eventDate'],
    );
  }
}