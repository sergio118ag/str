import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/purchase.dart';
import '../models/event.dart';
import '../models/user.dart';
import '../models/reward.dart';

class ApiService {

  final String baseUrl = "http://localhost:8080";

  Future<List<Purchase>> getPurchases() async {

    final response =
        await http.get(Uri.parse('$baseUrl/purchases'));

    if (response.statusCode == 200) {

      List jsonData = json.decode(response.body);

      return jsonData
          .map((purchase) => Purchase.fromJson(purchase))
          .toList();

    } else {
      throw Exception('Error al cargar compras');
    }
  }
  Future<List<Event>> getEvents() async {

    final response =
        await http.get(Uri.parse('$baseUrl/events'));

    if (response.statusCode == 200) {

      List jsonData = json.decode(response.body);

      return jsonData
          .map((event) => Event.fromJson(event))
          .toList();

    } else {
      throw Exception('Error al cargar eventos');
    }
  }
  Future<User> getUserById(int id) async {

    final response = await http.get(
      Uri.parse('$baseUrl/users/$id'),
    );

    if (response.statusCode == 200) {

      return User.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception('Error al cargar usuario');
  }
  Future<List<Reward>> getRewards() async {

    final response = await http.get(
      Uri.parse("$baseUrl/rewards"),
    );

    if (response.statusCode == 200) {

      final List data =
          jsonDecode(response.body);

      return data
          .map((e) => Reward.fromJson(e))
          .toList();
    }

    throw Exception(
        "Error al cargar recompensas");
  }
  Future<void> removePoints(
      int userId,
      int amount,
  ) async {

    final response = await http.post(

      Uri.parse(
        "$baseUrl/users/$userId/remove-points?amount=$amount",
      ),
    );

    if (response.statusCode != 200) {

      throw Exception(
        "Error al quitar puntos",
      );
    }
  }
}