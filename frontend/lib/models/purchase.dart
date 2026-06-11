import 'ticket.dart';

class Purchase {
  final int id;
  final String productName;
  final double price;
  final String? qrCode;
  final Ticket? ticket;

  Purchase({
    required this.id,
    required this.productName,
    required this.price,
    this.qrCode,
    this.ticket,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['id'],
      productName: json['productName'],
      price: json['price'].toDouble(),
      qrCode: json['qrCode'],
      ticket: json['ticket'] != null
          ? Ticket.fromJson(json['ticket'])
          : null,
    );
  }
}