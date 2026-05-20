class User {

  final int id;
  final String name;
  final String email;
  final String password;
  final int points;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.points,
  });

  factory User.fromJson(
    Map<String, dynamic> json,
  ) {

    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'] ?? "",
      points: json['points'] ?? 0,
    );
  }
}