import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/purchase.dart';
import '../models/event.dart';
import '../models/user.dart';
import '../models/reward.dart';
import '../models/redeemed_reward.dart';
import '../models/ticket.dart';
import '../models/product.dart';
import '../models/incident.dart';
import '../models/waste.dart';

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

  Future<Map<String, dynamic>> getEventStats(int eventId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/events/$eventId/stats'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar estadísticas');
    }
  }

  Future<List<User>> getAttendeesByEvent(int eventId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/purchases/event/$eventId/attendees'),
    );

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Error al cargar asistentes');
    }
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

  // ========== PRODUCTOS ==========
  Future<List<Product>> getProductsByEvent(int eventId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/event/$eventId'),
    );

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  Future<Product> createProduct(Map<String, dynamic> productData, int eventId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products?eventId=$eventId'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(productData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    }

    throw Exception('Error al crear producto');
  }

  Future<Product> updateProduct(int productId, Map<String, dynamic> productData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$productId'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(productData),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    }

    throw Exception('Error al actualizar producto');
  }

  Future<void> deleteProduct(int productId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/products/$productId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar producto');
    }
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

    // Crear ticket (entrada)
  Future<Ticket> createTicket({
    required int eventId,
    required String name,
    required double price,
    required int available,
  }) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/tickets?eventId=$eventId&name=$name&price=$price&available=$available'
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Ticket.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear entrada');
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

  // Staff - Validar QR de entrada
  Future<Purchase> validateQR(String qrCode) async {
    final response = await http.get(
      Uri.parse('$baseUrl/purchases/validate/$qrCode'),
    );

    if (response.statusCode == 200) {
      return Purchase.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('QR no válido o ya utilizado');
    }
  }

  // Staff - Validar QR de recompensa
  Future<RedeemedReward> validateRewardQR(String qrCode) async {
    final response = await http.get(
      Uri.parse('$baseUrl/purchases/validate-reward/$qrCode'),
    );

    if (response.statusCode == 200) {
      return RedeemedReward.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('QR de recompensa no válido o ya utilizado');
    }
  }

  // Staff - Obtener información de compra por QR
  Future<Purchase> getPurchaseByQR(String qrCode) async {
    final response = await http.get(
      Uri.parse('$baseUrl/purchases/info/$qrCode'),
    );

    if (response.statusCode == 200) {
      return Purchase.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('QR no válido');
    }
  }
  // Staff - Crear incidencia
  Future<Incident> createIncident(
    String email,
    int staffId,
    String eventName,
    String title,
    String description,
    String type,
    int pointsPenalty,
  ) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/incidents?email=$email&staffId=$staffId&eventName=$eventName&title=$title&description=$description&type=$type&pointsPenalty=$pointsPenalty'
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Incident.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear incidencia');
    }
  }

  // Staff - Obtener incidencias por evento
  Future<List<Incident>> getIncidentsByEvent(int eventId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/incidents/event/$eventId'),
    );

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((incident) => Incident.fromJson(incident)).toList();
    } else {
      throw Exception('Error al cargar incidencias');
    }
  }

  // Staff - Actualizar estado de incidencia
  Future<Incident> updateIncidentStatus(int incidentId, String status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/incidents/$incidentId/status?status=$status'),
    );

    if (response.statusCode == 200) {
      return Incident.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar incidencia');
    }
  }

  // Staff - Crear residuo
  Future<Waste> createWaste(int userId, int eventId, String location, String type) async {
    final response = await http.post(
      Uri.parse('$baseUrl/waste?userId=$userId&eventId=$eventId&location=$location&type=$type'),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Waste.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al registrar residuo');
    }
  }

  // Staff - Obtener eventos donde presta servicio
  Future<List<Event>> getEventsByStaff(int staffId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/events/staff/$staffId'),
    );

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception('Error al cargar eventos del staff');
    }
  }

  // Admin - Obtener todos los usuarios
  Future<List<User>> getAllUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/all'),
    );

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Error al cargar usuarios');
    }
  }

  // Admin - Cambiar rol de usuario
  Future<User> updateUserRole(int userId, String role) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId/role?role=$role'),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar rol');
    }
  }

  // Admin - Eliminar usuario
  Future<void> deleteUser(int userId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$userId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar usuario');
    }
    }

    // Admin - Crear recompensa
  Future<Reward> createReward(Map<String, dynamic> rewardData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/rewards'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(rewardData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Reward.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear recompensa');
    }
  }
  // Admin - Obtener todas las recompensas (incluye inactivas)
  Future<List<Reward>> getAllRewardsAdmin() async {
    final response = await http.get(
      Uri.parse('$baseUrl/rewards/all'),
    );

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((reward) => Reward.fromJson(reward)).toList();
    } else {
      throw Exception('Error al cargar recompensas');
    }
  }

  // Admin - Actualizar recompensa
  Future<Reward> updateRewardAdmin(int rewardId, Map<String, dynamic> rewardData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/rewards/$rewardId'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(rewardData),
    );

    if (response.statusCode == 200) {
      return Reward.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar recompensa');
    }
  }

  // Admin - Eliminar recompensa (borrado lógico)
  Future<void> deleteRewardAdmin(int rewardId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/rewards/$rewardId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar recompensa');
    }
  }
  // Admin - Obtener estadísticas del dashboard
  Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/stats/dashboard'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar estadísticas');
    }
    }
  // Admin - Obtener usuarios con puntos
  Future<List<User>> getUsersWithPoints() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/all'),
    );

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Error al cargar usuarios');
    }
  }

  // Admin - Añadir puntos a un usuario
  Future<User> addPointsAdmin(int userId, int amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/$userId/add-points?amount=$amount'),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al añadir puntos');
    }
  }

  // Admin - Restar puntos a un usuario
  Future<User> removePointsAdmin(int userId, int amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/$userId/remove-points?amount=$amount'),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al restar puntos');
    }
  }
  // Admin - Obtener todos los eventos (para administradores)
  Future<List<Event>> getAllEventsForAdmin() async {
    final response = await http.get(
      Uri.parse('$baseUrl/events/admin/all'),
    );

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception('Error al cargar todos los eventos');
    }
  }
  // Staff - Obtener información de compra por QR de producto (para trazabilidad de residuos)
  Future<Map<String, dynamic>> getPurchaseInfoByQR(String qrCode) async {
    final response = await http.get(
      Uri.parse('$baseUrl/purchases/product-qr/$qrCode'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('QR no válido');
    }
}
}