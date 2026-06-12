class Ticket {

  final int id;
  final String name;
  final double price;
  final int available;

  Ticket({
    required this.id,
    required this.name,
    required this.price,
    required this.available,
  });

  factory Ticket.fromJson(
    Map<String, dynamic> json,
  ) {

    return Ticket(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      available: json['available'],
    );
  }
}