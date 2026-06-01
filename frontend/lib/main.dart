import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'STR Eventos',

      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),

      home: const LoginScreen(),
      // home: HomeScreen(
      //   user: User(
      //     id: 1,
      //     name: "Prueba",
      //     email: "prueba@gmail.com",
      //     password: "1234",
      //     points: 1000,
      //   ),
      // ),
    );
  }
}