import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'login.dart';
import 'sobre_nos.dart';
import 'cadastro.dart';
import 'dashboard.dart';

void main() {
  runApp(const HydroflowApp());
}

class HydroflowApp extends StatelessWidget {
  const HydroflowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hydroflow',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF002855),
        ),
      ),

      home: const Home(), // 🔥 MELHOR QUE initialRoute

      routes: {
        '/home': (context) => const Home(),
        '/login': (context) => const LoginMobilePage(),
        '/sobre': (context) => const SobreNos(),
        '/cadastro': (context) => const CadastroPage(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}

//
// 🔐 VERIFICA LOGIN
//
class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool? isLogged;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final logged = prefs.getBool('isLogged') ?? false;

    if (!mounted) return;

    setState(() {
      isLogged = logged;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLogged == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return isLogged!
        ? const DashboardPage()
        : const LoginMobilePage();
  }
}