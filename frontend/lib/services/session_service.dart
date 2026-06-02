import 'package:shared_preferences/shared_preferences.dart';

class SessionService {

  Future<void> saveUserId(int userId) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setInt(
      "userId",
      userId,
    );
  }

  Future<int?> getUserId() async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getInt(
      "userId",
    );
  }

  Future<void> logout() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      "userId",
    );
  }
}