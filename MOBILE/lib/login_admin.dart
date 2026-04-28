import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginAdminPage extends StatefulWidget {
  const LoginAdminPage({super.key});

  @override
  State<LoginAdminPage> createState() => _LoginAdminPageState();
}

class _LoginAdminPageState extends State<LoginAdminPage> {
  static const Color azulPrimario = Color(0xFF002855);
  static const Color vermelhoAdmin = Color(0xFFB71C1C);
  static const Color offWhite = Color(0xFFF5F6FA);

  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  // 🚀 FUNÇÃO DE LOGIN
  Future<void> _loginAdmin() async {
    String email = _emailController.text.trim();
    String senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    // Validação das credenciais de Administrador
    if (email == "admin@email.com" && senha == "admin123") {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool('isLogged', true);
      await prefs.setString('userRole', 'admin'); 

      if (!mounted) return;

      // 🔔 IMPORTANTE: Mude para '/admin_dashboard' (conforme sua rota no main.dart)
      // para garantir que ele caia no dashboard azul de admin.
      Navigator.pushReplacementNamed(context, '/dashboard_admin');
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Acesso negado: Credenciais inválidas"),
          backgroundColor: vermelhoAdmin,
        ),
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Área Administrativa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Acesso restrito ao gerenciamento do sistema',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // FORMULÁRIO CARD
            Expanded(
              child: Container(
                width: double.infinity,
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
                        'Login Admin',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: azulPrimario,
                        ),
                      ),
                      const SizedBox(height: 30),

                      _buildLabel('Email do Administrador'),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _buildInputDecoration('admin@email.com'),
                      ),

                      const SizedBox(height: 20),

                      _buildLabel('Senha de Acesso'),
                      TextFormField(
                        controller: _senhaController,
                        obscureText: _obscureText,
                        decoration: _buildInputDecoration('••••••••').copyWith(
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

                      const SizedBox(height: 30),

                      // 🔴 BOTÃO DE LOGIN
                      ElevatedButton(
                        onPressed: _loginAdmin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: vermelhoAdmin,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'ENTRAR COMO ADMIN',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // 🔙 VOLTAR PARA LOGIN NORMAL
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Não é um administrador? '),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: const Text(
                              'Voltar',
                              style: TextStyle(
                                color: azulPrimario,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
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

  // --- MÉTODOS AUXILIARES DE ESTILO ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: azulPrimario, width: 2),
      ),
    );
  }
}