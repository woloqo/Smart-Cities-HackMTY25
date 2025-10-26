import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'login/login_screen.dart';
import 'menu/home.dart';

Future<void> main() async {
  // Carga el archivo .env
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Banorte Móvil',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      routes: {
        'login' : (BuildContext context) => LoginScreen(),
        'home': (BuildContext context) => Home(),
      },
      initialRoute: 'login',
    );
  } 
}

