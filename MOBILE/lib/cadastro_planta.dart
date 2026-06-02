import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcc/botao_acessibilidade.dart';
import 'accessibility_provider.dart';
import 'package:provider/provider.dart';

class CadastroPlantaPage extends StatefulWidget {
  const CadastroPlantaPage({super.key});

  @override
  State<CadastroPlantaPage> createState() => _CadastroPlantaPageState();
}

class _CadastroPlantaPageState extends State<CadastroPlantaPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _culturaController = TextEditingController();
  final TextEditingController _qtdAguaController = TextEditingController();
  final TextEditingController _periodoController = TextEditingController();

  String? _tipoSelecionado;
  String? _dispositivoSelecionado;

  String _unidadeAgua = 'Litros/dia';
  String _unidadeTempo = 'Horas';

  static const azulPrimario = Color(0xFF002855);

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Função modificada para aceitar os parâmetros de acessibilidade dinamicamente
  InputDecoration _input(String label, bool high, double f, {String? hint}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: high ? Colors.white70 : Colors.black54, fontSize: 14 * f),
      hintText: hint,
      hintStyle: TextStyle(color: high ? Colors.white54 : Colors.black38, fontSize: 14 * f),
      filled: true,
      fillColor: high ? Colors.grey[900] : Colors.white,
      errorStyle: TextStyle(fontSize: 12 * f, fontWeight: FontWeight.bold),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: high ? Colors.white54 : Colors.grey.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: high ? Colors.white : azulPrimario, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Escutando as mudanças do Provider de Acessibilidade
    final acc = Provider.of<AccessibilityProvider>(context);
    final high = acc.isHighContrast;
    final f = acc.fontSizeFactor;

    final bgPage = high ? Colors.black : const Color(0xFFF4F6F9);
    final bgCard = high ? Colors.black : Colors.white;
    final appBarBg = high ? Colors.black : azulPrimario;
    final txtPrincipal = high ? Colors.white : azulPrimario;
    final appBarBorder = high ? const BorderSide(color: Colors.white, width: 2) : BorderSide.none;

    return Scaffold(
      backgroundColor: bgPage,

      appBar: AppBar(
        title: Text("Cadastro de Culturas", style: TextStyle(fontSize: 20 * f)),
        backgroundColor: appBarBg,
        foregroundColor: Colors.white,
        shape: Border(bottom: appBarBorder),
        actions: const [BotaoAcessibilidade()],
      ),

      drawer: _buildDrawer(context, high, f),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// CARD PRINCIPAL
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: bgCard,
                borderRadius: BorderRadius.circular(14),
                border: high ? Border.all(color: Colors.white, width: 2) : null,
                boxShadow: high ? [] : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// HEADER Interno
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.eco, color: high ? Colors.white : azulPrimario),
                            const SizedBox(width: 10),
                            Text(
                              "Nova Planta",
                              style: TextStyle(
                                fontSize: 20 * f,
                                fontWeight: FontWeight.bold,
                                color: txtPrincipal,
                              ),
                            ),
                          ],
                        ),

                        TextButton.icon(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/plantas'),
                          icon: const Icon(Icons.list),
                          label: Text("Ver plantas", style: TextStyle(fontSize: 14 * f)),
                          style: TextButton.styleFrom(
                            foregroundColor: high ? Colors.white : azulPrimario,
                          ),
                        ),
                      ],
                    ),

                    Divider(height: 30, color: high ? Colors.white24 : Colors.grey[300]),

                    /// SEÇÃO 1
                    Text(
                      "Informações da Planta",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * f,
                        color: high ? Colors.white70 : Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _nomeController,
                      style: TextStyle(color: high ? Colors.white : Colors.black, fontSize: 14 * f),
                      decoration: _input("Nome da planta", high, f, hint: "Ex: Tomate Carmem"),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            dropdownColor: high ? Colors.grey[900] : Colors.white,
                            style: TextStyle(color: high ? Colors.white : Colors.black, fontSize: 14 * f),
                            decoration: _input("Tipo", high, f),
                            items: const [
                              "Hortaliça",
                              "Frutífera",
                              "Legume",
                              "Grão",
                              "Ornamental"
                            ]
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (v) => _tipoSelecionado = v,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _culturaController,
                            style: TextStyle(color: high ? Colors.white : Colors.black, fontSize: 14 * f),
                            decoration: _input("Cultura", high, f),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// SEÇÃO 2
                    Text(
                      "Irrigação",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * f,
                        color: high ? Colors.white70 : Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _qtdAguaController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: high ? Colors.white : Colors.black, fontSize: 14 * f),
                            decoration: _input("Quantidade de água", high, f),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _unidadeAgua,
                            dropdownColor: high ? Colors.grey[900] : Colors.white,
                            style: TextStyle(color: high ? Colors.white : Colors.black, fontSize: 14 * f),
                            decoration: _input("Unidade", high, f),
                            items: const ["Litros/dia", "mm/dia", "mL/dia"]
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (v) => setState(() => _unidadeAgua = v!),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      decoration: _input("Dispositivo", high, f),
                      dropdownColor: high ? Colors.grey[900] : Colors.white,
                      style: TextStyle(color: high ? Colors.white : Colors.black, fontSize: 14 * f),
                      items: const [
                        "Irriga 1000",
                        "Hortas 03012",
                        "Irrigation PRO"
                      ]
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (v) => _dispositivoSelecionado = v,
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _periodoController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: high ? Colors.white : Colors.black, fontSize: 14 * f),
                            decoration: _input("Periodicidade", high, f),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _unidadeTempo,
                            dropdownColor: high ? Colors.grey[900] : Colors.white,
                            style: TextStyle(color: high ? Colors.white : Colors.black, fontSize: 14 * f),
                            decoration: _input("Unidade", high, f),
                            items: const ["Horas", "Dias", "Semanas"]
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (v) => setState(() => _unidadeTempo = v!),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// BOTÕES
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => _formKey.currentState?.reset(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: high ? Colors.white : azulPrimario,
                            side: BorderSide(color: high ? Colors.white54 : azulPrimario),
                          ),
                          child: Text("Limpar", style: TextStyle(fontSize: 14 * f)),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Planta cadastrada com sucesso!"),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.check),
                          label: Text("Salvar", style: TextStyle(fontSize: 14 * f, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: high ? Colors.black : azulPrimario,
                            foregroundColor: Colors.white,
                            side: high ? const BorderSide(color: Colors.white, width: 2) : BorderSide.none,
                          ),
                        ),
                      ],
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

  /// DRAWER ATUALIZADO
  Widget _buildDrawer(BuildContext context, bool high, double f) {
    return Drawer(
      child: Container(
        color: high ? Colors.black : azulPrimario,
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: Center(
                child: Text(
                  "HYDROFLOW",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26 * f,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Divider(color: Colors.white24),
            _drawerItem(Icons.home, "Painel", '/dashboard', f),
            _drawerItem(Icons.eco, "Plantas", '/plantas', f),
            _drawerItem(Icons.history, "Histórico", '/historico', f),
            _drawerItem(Icons.memory, "Equipamentos", '/equipamentos', f),
            const Spacer(),
            const Divider(color: Colors.white24),
            _drawerItem(Icons.logout, "Sair", '/login', f, isLogout: true),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, String route, double f, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 14 * f)),
      onTap: () {
        Navigator.pop(context);
        if (isLogout) {
          _logout();
        } else {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
}