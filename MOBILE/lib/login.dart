import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LoginMobilePage extends StatefulWidget {
  const LoginMobilePage({super.key});

  @override
  State<LoginMobilePage> createState() => _LoginMobilePageState();
}

class _LoginMobilePageState extends State<LoginMobilePage> {
  static const Color azulPrimario = Color(0xFF002855);
  static const Color azulBanco = Color(0xFF0D47A1);
  static const Color azulCyan = Color(0xFF4DD0E1);
  static const Color offWhite = Color(0xFFF5F6FA);

  bool _obscureText = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    if (email == "user@email.com" && senha == "1234") {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLogged', true);

      if (!mounted) return;
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
      
      // --- MENU SANDUÍCHE CORRIGIDO ---
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, left: 20, bottom: 20),
              color: azulPrimario,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hydroflow',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Tecnologia no Campo',
                    style: TextStyle(
                      color: Colors.blue[200],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _drawerItem(
                      icon: Icons.home,
                      label: 'Início',
                      onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                    ),
                    _drawerItem(
                      icon: Icons.info,
                      label: 'Sobre',
                      onTap: () => Navigator.pushReplacementNamed(context, '/sobre'),
                    ),
                    _drawerItem(
                      icon: Icons.login,
                      label: 'Login',
                      onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                    ),
                    _drawerItem(
                      icon: Icons.person_add_alt_1,
                      label: 'Cadastro',
                      onTap: () => Navigator.pushReplacementNamed(context, '/cadastro'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      appBar: AppBar(
        backgroundColor: azulPrimario,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bem-vindo a HydroFlow!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Faça login para continuar',
                    style: TextStyle(color: azulCyan),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: offWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(30),
                child: SingleChildScrollView(
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
                        controller: _emailController,
                        decoration: _buildInputDecoration('exemplo@email.com'),
                      ),
                      const SizedBox(height: 20),
                      _buildLabel('Senha'),
                      TextFormField(
                        controller: _senhaController,
                        obscureText: _obscureText,
                        decoration: _buildInputDecoration('••••••••').copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: azulBanco,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Entrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 20),
                      _buildFooterLink('Não tem uma conta? ', 'Cadastre-se', '/cadastro'),
                      const SizedBox(height: 15),
                      _buildFooterLink('É administrador? ', 'Entrar como admin', '/login_admin'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- MÉTODOS AUXILIARES (O QUE ESTAVA FALTANDO) ---

  Widget _drawerItem({required IconData icon, required String label, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(label, style: const TextStyle(color: Colors.black87, fontSize: 16)),
      onTap: onTap,
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildFooterLink(String text, String linkText, String route) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, route),
          child: Text(
            linkText,
            style: const TextStyle(color: azulBanco, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}