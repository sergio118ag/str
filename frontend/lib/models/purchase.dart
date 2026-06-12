import 'ticket.dart';
import 'event.dart';

class Purchase {

  final int id;
  final String productName;
  final double price;
  final String? qrCode;
  final Ticket? ticket;

  final Event? event;
  final String? date;
  final bool? used;

  Purchase({
    required this.id,
    required this.productName,
    required this.price,
    this.qrCode,
    this.ticket,
    this.event,
    this.date,
    this.used,
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

      event: json['event'] != null
          ? Event.fromJson(json['event'])
          : null,

      date: json['date'],

      used: json['used'],
    );
  }
}