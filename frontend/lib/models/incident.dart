class Incident {
  final int id;
  final String title;
  final String description;
  final String type;
  final String status;
  final String date;
  final int pointsPenalty;
  final int userId;
  final String userName;
  final int staffId;
  final int eventId;
  final String eventName;

  Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.date,
    required this.pointsPenalty,
    required this.userId,
    required this.userName,
    required this.staffId,
    required this.eventId,
    required this.eventName,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      date: json['date'] ?? '',
      pointsPenalty: json['pointsPenalty'] ?? 0,
      userId: json['user']?['id'] ?? 0,
      userName: json['user']?['name'] ?? '',
      staffId: json['staff']?['id'] ?? 0,
      eventId: json['event']?['id'] ?? 0,
      eventName: json['event']?['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'pointsPenalty': pointsPenalty,
    };
  }
}