class User {

  final int id;
  final String name;
  final String email;
  final String password;
  final int points;

  final String address;
  final String postalCode;
  final String city;
  final int age;
  final String phone;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.points,
    required this.address,
    required this.postalCode,
    required this.city,
    required this.age,
    required this.phone,
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

      address: json['address'] ?? "",
      postalCode: json['postalCode'] ?? "",
      city: json['city'] ?? "",
      age: json['age'] ?? 0,
      phone: json['phone'] ?? "",
    );
  }
}