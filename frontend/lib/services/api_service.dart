import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/purchase.dart';

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
}