class Reward {

  final int id;
  final String name;
  final String description;
  final int pointsRequired;

  Reward({
    required this.id,
    required this.name,
    required this.description,
    required this.pointsRequired,
  });

  factory Reward.fromJson(
      Map<String, dynamic> json) {

    return Reward(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pointsRequired:
          json['pointsRequired'],
    );
  }
}