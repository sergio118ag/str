import 'user.dart';
class Event {

  final int id;
  final String name;
  final String description;
  final String location;
  final double ticketPrice;
  final int capacity;
  final int available;
  final String eventDate;
  final String imageUrl;
  final String category;
  final bool active;
  final int organizerId;
  final User? organizer;
  

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.ticketPrice,
    required this.capacity,
    required this.available,
    required this.eventDate,
    required this.imageUrl,
    required this.category,
    required this.active,
    required this.organizerId,
    this.organizer, 
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      ticketPrice: (json['ticketPrice'] ?? 0).toDouble(),
      capacity: json['capacity'] ?? 0,
      available: json['available'] ?? 0,
      eventDate: json['eventDate'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      active: json['active'] ?? true,
      organizerId: json['organizer']?['id'] ?? 0,
      organizer: json['organizer'] != null ? User.fromJson(json['organizer']) : null, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'location': location,
      'ticketPrice': ticketPrice,
      'capacity': capacity,
      'eventDate': eventDate,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  Event copyWith({
    int? id,
    String? name,
    String? description,
    String? location,
    double? ticketPrice,
    int? capacity,
    int? available,
    String? eventDate,
    String? imageUrl,
    String? category,
    bool? active,
    int? organizerId,
    User? organizer,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      ticketPrice: ticketPrice ?? this.ticketPrice,
      capacity: capacity ?? this.capacity,
      available: available ?? this.available,
      eventDate: eventDate ?? this.eventDate,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      active: active ?? this.active,
      organizerId: organizerId ?? this.organizerId,
      organizer: organizer ?? this.organizer,
    );
  }
}