import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/purchase.dart';
import '../models/event.dart';
import '../models/user.dart';
import '../models/reward.dart';
import '../models/redeemed_reward.dart';
import '../models/ticket.dart';

class ApiService {

  final String baseUrl = "http://localhost:8080";

  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/users/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    print("Respuesta status: ${response.statusCode}");
    print("Respuesta body: ${response.body}");

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }

    throw Exception("Email o contraseña incorrectos");
  }

  Future<User> register(
    String name,
    String email,
    String password,
    String address,
    String postalCode,
    String city,
    int age,
    String phone,
  ) async {

    final response =
        await http.post(

      Uri.parse(
        "$baseUrl/users",
      ),

      headers: {
        "Content-Type":
            "application/json",
      },

      body: jsonEncode({

        "name": name,
        "email": email,
        "password": password,
        "points": 0,

        "address": address,
        "postalCode": postalCode,
        "city": city,
        "age": age,
        "phone": phone,
      }),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {

      return User.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      "Error al registrar usuario",
    );
  }

  Future<List<Purchase>> getPurchases() async {

    final response =
        await http.get(
      Uri.parse('$baseUrl/purchases'),
    );

    if (response.statusCode == 200) {

      List jsonData =
          json.decode(response.body);

      return jsonData
          .map(
            (purchase) =>
                Purchase.fromJson(purchase),
          )
          .toList();

    } else {

      throw Exception(
        'Error al cargar compras',
      );
    }
  }

  Future<List<Purchase>> getPurchasesByUser(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/purchases/user/$userId'),
    );

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((purchase) => Purchase.fromJson(purchase)).toList();
    } else {
      throw Exception('Error al cargar compras del usuario');
    }
  }

  Future<List<Event>> getEvents() async {

    final response =
        await http.get(
      Uri.parse('$baseUrl/events'),
    );

    if (response.statusCode == 200) {

      List jsonData =
          json.decode(response.body);

      return jsonData
          .map(
            (event) =>
                Event.fromJson(event),
          )
          .toList();

    } else {

      throw Exception(
        'Error al cargar eventos',
      );
    }
  }

  Future<List<Event>> getEventsByOrganizer(int organizerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/events/organizer/$organizerId'),
    );

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception('Error al cargar eventos del organizador');
    }
  }

  Future<Event> getEventById(int eventId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/events/$eventId'),
    );

    if (response.statusCode == 200) {
      return Event.fromJson(jsonDecode(response.body));
    }

    throw Exception('Error al cargar evento');
  }

  Future<Event> createEvent(Map<String, dynamic> eventData, int organizerId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/events?organizerId=$organizerId'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(eventData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Event.fromJson(jsonDecode(response.body));
    }

    throw Exception('Error al crear evento');
  }

  Future<Event> updateEvent(int eventId, Event event) async {
    final response = await http.put(
      Uri.parse('$baseUrl/events/$eventId'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(event.toJson()),
    );

    if (response.statusCode == 200) {
      return Event.fromJson(jsonDecode(response.body));
    }

    throw Exception('Error al actualizar evento');
  }

  Future<void> deleteEvent(int eventId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/events/$eventId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar evento');
    }
  }

  Future<Event> updateEventCapacity(int eventId, int newCapacity) async {
    final response = await http.put(
      Uri.parse('$baseUrl/events/$eventId/capacity?newCapacity=$newCapacity'),
    );

    if (response.statusCode == 200) {
      return Event.fromJson(jsonDecode(response.body));
    }

    throw Exception('Error al actualizar aforo');
  }

  Future<List<Ticket>> getTicketsByEvent(
    int eventId,
  ) async {

    final response =
        await http.get(

      Uri.parse(
        "$baseUrl/tickets/event/$eventId",
      ),
    );

    if (response.statusCode == 200) {

      final List data =
          jsonDecode(response.body);

      return data
          .map(
            (e) => Ticket.fromJson(e),
          )
          .toList();
    }

    throw Exception(
      "Error al cargar entradas",
    );
  }

  Future<void> buyTicket(
    int userId,
    int ticketId,
  ) async {

    final response =
        await http.post(

      Uri.parse(
        "$baseUrl/purchases/ticket?userId=$userId&ticketId=$ticketId",
      ),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {

      throw Exception(
        "Error al comprar entrada",
      );
    }
  }

  Future<User> getUserById(int id) async {

    final response =
        await http.get(
      Uri.parse('$baseUrl/users/$id'),
    );

    if (response.statusCode == 200) {

      return User.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Error al cargar usuario',
    );
  }

  Future<List<Reward>> getRewards() async {

    final response =
        await http.get(
      Uri.parse("$baseUrl/rewards"),
    );

    if (response.statusCode == 200) {

      final List data =
          jsonDecode(response.body);

      return data
          .map(
            (e) => Reward.fromJson(e),
          )
          .toList();
    }

    throw Exception(
      "Error al cargar recompensas",
    );
  }

  Future<void> removePoints(
    int userId,
    int amount,
  ) async {

    final response =
        await http.post(

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

  Future<void> redeemReward(
    int userId,
    int rewardId,
  ) async {

    final response =
        await http.post(

      Uri.parse(
        "$baseUrl/redeemed-rewards/redeem?userId=$userId&rewardId=$rewardId",
      ),
    );

    if (response.statusCode != 200) {

      throw Exception(
        "Error al canjear recompensa",
      );
    }
  }

  Future<User> redeemRewardAndGetUser(
    int userId,
    int rewardId,
  ) async {

    final response = await http.post(
      Uri.parse("$baseUrl/redeemed-rewards/redeem?userId=$userId&rewardId=$rewardId"),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }

    throw Exception("Error al canjear recompensa");
  }

  Future<void> useReward(
    int rewardId,
  ) async {

    final response =
        await http.post(

      Uri.parse(
        "$baseUrl/redeemed-rewards/use/$rewardId",
      ),
    );

    if (response.statusCode != 200) {

      throw Exception(
        "Error al usar recompensa",
      );
    }
  }

  Future<List<RedeemedReward>>
  getRedeemedRewards(
    int userId,
  ) async {

    final response =
        await http.get(

      Uri.parse(
        "$baseUrl/redeemed-rewards/user/$userId",
      ),
    );

    if (response.statusCode == 200) {

      final List data =
          jsonDecode(response.body);

      return data
          .map(
            (e) =>
                RedeemedReward.fromJson(e),
          )
          .toList();
    }

    throw Exception(
      "Error al cargar recompensas canjeadas",
    );
  }
  
  Future<User> updateUser(
  User user,
  ) async {

    final response =
        await http.put(

      Uri.parse(
        "$baseUrl/users/${user.id}",
      ),

      headers: {
        "Content-Type":
            "application/json",
      },

      body: jsonEncode({

        "name": user.name,
        "email": user.email,

        "address": user.address,
        "postalCode": user.postalCode,
        "city": user.city,
        "age": user.age,
        "phone": user.phone,
      }),
    );

    if (response.statusCode == 200) {

      return User.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      "Error al actualizar usuario",
    );
  }
}