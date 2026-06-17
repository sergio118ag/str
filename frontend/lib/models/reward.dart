class Reward {

  final int id;
  final String name;
  final String description;
  final int pointsRequired;
  final bool active;

  Reward({
    required this.id,
    required this.name,
    required this.description,
    required this.pointsRequired,
    required this.active,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      pointsRequired: json['pointsRequired'] ?? 0,
      active: json['active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'pointsRequired': pointsRequired,
      'active': active,
    };
  }
}