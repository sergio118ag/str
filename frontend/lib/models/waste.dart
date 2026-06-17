class Waste {
  final int id;
  final String qrCode;
  final String location;
  final String type;
  final bool recycled;
  final String date;
  final int userId;
  final String userName;
  final int eventId;
  final String eventName;

  Waste({
    required this.id,
    required this.qrCode,
    required this.location,
    required this.type,
    required this.recycled,
    required this.date,
    required this.userId,
    required this.userName,
    required this.eventId,
    required this.eventName,
  });

  factory Waste.fromJson(Map<String, dynamic> json) {
    return Waste(
      id: json['id'] ?? 0,
      qrCode: json['qrCode'] ?? '',
      location: json['location'] ?? '',
      type: json['type'] ?? '',
      recycled: json['recycled'] ?? false,
      date: json['date'] ?? '',
      userId: json['user']?['id'] ?? 0,
      userName: json['user']?['name'] ?? '',
      eventId: json['event']?['id'] ?? 0,
      eventName: json['event']?['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qrCode': qrCode,
      'location': location,
      'type': type,
      'recycled': recycled,
    };
  }
}