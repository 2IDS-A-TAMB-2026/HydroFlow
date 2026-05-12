import 'package:flutter/material.dart';

class NovaSenhaPage extends StatefulWidget {
  const NovaSenhaPage({super.key});

  @override
  State<NovaSenhaPage> createState() => _NovaSenhaPageState();
}

class _NovaSenhaPageState extends State<NovaSenhaPage> {
  static const Color azulPrimario = Color(0xFF002855);
  static const Color azulBanco = Color(0xFF0D47A1);
  static const Color azulCyan = Color(0xFF4DD0E1);
  static const Color offWhite = Color(0xFFF5F6FA);

  final TextEditingController _novaSenhaController =
      TextEditingController();

  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  bool _obscureNova = true;
  bool _obscureConfirmar = true;

  @override
  void dispose() {
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _salvarNovaSenha() async {
    String senha = _novaSenhaController.text.trim();
    String confirmar = _confirmarSenhaController.text.trim();

    if (senha.isEmpty || confirmar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preencha todos os campos"),
        ),
      );
      return;
    }

    if (senha.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "A senha deve ter no mínimo 4 caracteres",
          ),
        ),
      );
      return;
    }

    if (senha != confirmar) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("As senhas não coincidem"),
        ),
      );
      return;
    }

    // Simulação de salvamento
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Senha redefinida com sucesso!"),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: azulPrimario,

      appBar: AppBar(
        backgroundColor: azulPrimario,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nova Senha',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Defina sua nova senha',
                  style: TextStyle(color: azulCyan),
                ),
              ],
            ),
          ),

          // FORMULÁRIO
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(30),

              decoration: const BoxDecoration(
                color: offWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),

              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,

                  children: [
                    Text(
                      'Redefinir senha',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: azulPrimario,
                      ),
                    ),

                    const SizedBox(height: 30),

                    _buildLabel('Nova senha'),

                    TextFormField(
                      controller: _novaSenhaController,
                      obscureText: _obscureNova,

                      decoration:
                          _buildInputDecoration('••••••••')
                              .copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNova
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureNova =
                                  !_obscureNova;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildLabel('Confirmar senha'),

                    TextFormField(
                      controller:
                          _confirmarSenhaController,
                      obscureText: _obscureConfirmar,

                      decoration:
                          _buildInputDecoration('••••••••')
                              .copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmar
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmar =
                                  !_obscureConfirmar;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: _salvarNovaSenha,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: azulBanco,
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),

                      child: const Text(
                        'Salvar nova senha',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildFooterLink(
                      'Voltar para ',
                      'Login',
                      '/login',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),

      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
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

  Widget _buildFooterLink(
    String text,
    String linkText,
    String route,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Text(text),

        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(
              context,
              route,
            );
          },

          child: Text(
            linkText,
            style: const TextStyle(
              color: azulBanco,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}