import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  static const Color azulPrimario = Color(0xFF002855);
  static const Color azulRoyal = Color(0xFF0056B3);
  static const Color azulCyan = Color(0xFF4DD0E1);
  static const Color offWhite = Color(0xFFF2F2F2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: azulPrimario,

      // ✅ APPBAR PADRÃO
      appBar: AppBar(
        backgroundColor: azulPrimario,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // ✅ DRAWER PADRÃO
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: azulPrimario),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hydroflow",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Tecnologia no Campo",
                    style: TextStyle(color: azulCyan),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Início"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),

            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("Sobre"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/sobre');
              },
            ),

            ListTile(
              leading: const Icon(Icons.login),
              title: const Text("Login"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),

            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text("Cadastro"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/cadastro');
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, bottom: 30, left: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                      children: [
                        TextSpan(text: 'HydroFlow'),
                        TextSpan(
                          text: '.',
                          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Crie sua conta',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Comece agora sua jornada',
                    style: TextStyle(color: azulCyan),
                  ),
                ],
              ),
            ),

            // FORM
            Container(
              decoration: const BoxDecoration(
                color: offWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInput(
                      hint: "Nome completo",
                      controller: _nomeController,
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildInput(
                            hint: "CPF",
                            isCPF: true,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildInput(
                            hint: "UF",
                            maxLength: 2,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    _buildInput(
                      hint: "E-mail",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 20),

                    _buildSectionTitle("Endereço"),

                    Row(
                      children: [
                        Expanded(
                          child: _buildInput(
                            hint: "CEP",
                            isCEP: true,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: _buildInput(hint: "Rua"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildInput(hint: "Bairro"),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildInput(hint: "Nº"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _buildSectionTitle("Segurança"),

                    _buildInput(
                      hint: "Senha",
                      controller: _senhaController,
                      isPassword: true,
                    ),

                    const SizedBox(height: 15),

                    _buildInput(
                      hint: "Confirmar senha",
                      controller: _confirmarSenhaController,
                      isPassword: true,
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: azulRoyal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {}
                        },
                        child: const Text(
                          "Finalizar Cadastro",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: Text(
                        "Já tem uma conta? Faça login",
                        style: TextStyle(color: azulRoyal),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required String hint,
    TextEditingController? controller,
    bool isPassword = false,
    bool isCPF = false,
    bool isCEP = false,
    int? maxLength,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      maxLength: maxLength,
      keyboardType: keyboardType,
      inputFormatters: [
        if (isCPF) FilteringTextInputFormatter.digitsOnly,
        if (isCPF) CpfInputFormatter(),
        if (isCEP) FilteringTextInputFormatter.digitsOnly,
        if (isCEP) CepInputFormatter(),
      ],
      decoration: InputDecoration(
        hintText: hint,
        counterText: "",
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
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "Obrigatório";
        return null;
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: azulPrimario,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

