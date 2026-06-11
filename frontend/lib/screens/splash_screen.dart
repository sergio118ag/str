import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/api_service.dart';
import '../services/session_service.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {

  @override
  void initState() {

    super.initState();

    checkSession();
  }

  Future<void> checkSession() async {

    final userId =
        await SessionService().getUserId();


    if (userId == null) {

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(
          builder: (_) =>
              const LoginScreen(),
        ),
      );

      return;
    }

    try {

      User user =
          await ApiService()
              .getUserById(userId);

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(
          builder: (_) =>
              HomeScreen(
            user: user,
          ),
        ),
      );

    } catch (_) {

      await SessionService().logout();

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(
          builder: (_) =>
              const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(

      body: Center(

        child:
            CircularProgressIndicator(),
      ),
    );
  }
}