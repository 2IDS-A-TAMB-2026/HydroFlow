import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LoginMobilePage extends StatefulWidget {
  const LoginMobilePage({super.key});

  @override
  State<LoginMobilePage> createState() => _LoginMobilePageState();
}

class _LoginMobilePageState extends State<LoginMobilePage> {
  static const Color azulPrimario = Color(0xFF002855);
  static const Color azulRoyal = Color(0xFF0056B3);
  static const Color azulCyan = Color(0xFF4DD0E1);
  static const Color offWhite = Color(0xFFF2F2F2);

  bool _obscureText = true;

  // 🔥 CONTROLLERS
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  // 🔐 FUNÇÃO LOGIN
  Future<void> _login() async {
    String email = _emailController.text.trim();
    String senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    // 🔥 LOGIN SIMULADO (você pode trocar depois por API)
    if (email == "admin@email.com" && senha == "1234") {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLogged', true);

      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email ou senha inválidos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: azulPrimario,
      appBar: AppBar(
        backgroundColor: azulPrimario,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: azulPrimario),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hydroflow",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("Tecnologia no Campo",
                      style: TextStyle(color: azulCyan)),
                ],
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              child: const Text(
                'Bem-vindo!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
            ),

            Container(
              decoration: const BoxDecoration(
                color: offWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: azulPrimario,
                    ),
                  ),

                  const SizedBox(height: 30),

                  _buildLabel('Email'),
                  TextFormField(
                    controller: _emailController, // 🔥 AQUI
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        _buildInputDecoration('exemplo@email.com'),
                  ),

                  const SizedBox(height: 20),

                  _buildLabel('Senha'),
                  TextFormField(
                    controller: _senhaController, // 🔥 AQUI
                    obscureText: _obscureText,
                    decoration:
                        _buildInputDecoration('••••••••').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _login, // 🔥 AQUI
                    style: ElevatedButton.styleFrom(
                      backgroundColor: azulRoyal,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}