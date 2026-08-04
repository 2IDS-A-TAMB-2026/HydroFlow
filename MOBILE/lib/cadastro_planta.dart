import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcc/botao_acessibilidade.dart';
import 'accessibility_provider.dart';
import 'package:provider/provider.dart';

/// ─────────────────────────────────────────────
///  PALETA DO MODO ESCURO (mesma do dashboard/plantas)
/// ─────────────────────────────────────────────
class DarkPalette {
  static const Color background = Color(0xFF0A1A2B);
  static const Color surface = Color(0xFF10263D);
  static const Color surfaceElevated = Color(0xFF16324B);
  static const Color surfaceBorder = Color(0xFF1E3B57);
  static const Color textPrimary = Color(0xFFF2F6FA);
  static const Color textSecondary = Color(0xFFA9C0D6);
}

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
      labelStyle: TextStyle(
        color: high ? DarkPalette.textSecondary : Colors.black54,
        fontSize: 14 * f,
      ),
      hintText: hint,
      hintStyle: TextStyle(
        color: high ? DarkPalette.textSecondary : Colors.black38,
        fontSize: 14 * f,
      ),
      filled: true,
      fillColor: high ? DarkPalette.surface : Colors.white,
      errorStyle: TextStyle(fontSize: 12 * f, fontWeight: FontWeight.bold),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: high ? DarkPalette.surfaceBorder : Colors.grey.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: high ? Colors.cyanAccent : azulPrimario, width: 2),
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

    final bgPage = high ? DarkPalette.background : const Color(0xFFF4F6F9);
    final bgCard = high ? DarkPalette.surface : Colors.white;
    final appBarBg = high ? DarkPalette.surface : azulPrimario;
    final txtPrincipal = high ? Colors.cyanAccent : azulPrimario;
    final appBarBorder = high
        ? const BorderSide(color: DarkPalette.surfaceBorder, width: 2)
        : BorderSide.none;

    return Scaffold(
      backgroundColor: bgPage,

      appBar: AppBar(
        title: Text(
          "Cadastro de Culturas",
          style: TextStyle(fontSize: 20 * f),
          overflow: TextOverflow.ellipsis,
        ),
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgCard,
                borderRadius: BorderRadius.circular(14),
                border: high ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5) : null,
                boxShadow: high
                    ? []
                    : [
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
                    // CORRIGIDO: Row com Expanded/Flexible para não estourar
                    // quando o texto aumenta (fontSizeFactor) ou a tela é estreita
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.eco, color: high ? Colors.cyanAccent : azulPrimario),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  "Nova Planta",
                                  style: TextStyle(
                                    fontSize: 20 * f,
                                    fontWeight: FontWeight.bold,
                                    color: txtPrincipal,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/plantas'),
                          icon: const Icon(Icons.list),
                          label: Text(
                            "Ver plantas",
                            style: TextStyle(fontSize: 14 * f),
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: high ? Colors.cyanAccent : azulPrimario,
                          ),
                        ),
                      ],
                    ),

                    Divider(
                      height: 30,
                      color: high ? DarkPalette.surfaceBorder : Colors.grey[300],
                    ),

                    /// SEÇÃO 1
                    Text(
                      "Informações da Planta",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * f,
                        color: high ? DarkPalette.textSecondary : Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _nomeController,
                      style: TextStyle(
                        color: high ? DarkPalette.textPrimary : Colors.black,
                        fontSize: 14 * f,
                      ),
                      decoration: _input("Nome da planta", high, f, hint: "Ex: Tomate Carmem"),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            isExpanded: true, // CORRIGIDO: evita overflow do texto do item
                            dropdownColor: high ? DarkPalette.surfaceElevated : Colors.white,
                            style: TextStyle(
                              color: high ? DarkPalette.textPrimary : Colors.black,
                              fontSize: 14 * f,
                            ),
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
                                      child: Text(e, overflow: TextOverflow.ellipsis),
                                    ))
                                .toList(),
                            onChanged: (v) => _tipoSelecionado = v,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _culturaController,
                            style: TextStyle(
                              color: high ? DarkPalette.textPrimary : Colors.black,
                              fontSize: 14 * f,
                            ),
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
                        color: high ? DarkPalette.textSecondary : Colors.grey,
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
                            style: TextStyle(
                              color: high ? DarkPalette.textPrimary : Colors.black,
                              fontSize: 14 * f,
                            ),
                            decoration: _input("Quantidade de água", high, f),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _unidadeAgua,
                            dropdownColor: high ? DarkPalette.surfaceElevated : Colors.white,
                            style: TextStyle(
                              color: high ? DarkPalette.textPrimary : Colors.black,
                              fontSize: 14 * f,
                            ),
                            decoration: _input("Unidade", high, f),
                            items: const ["Litros/dia", "mm/dia", "mL/dia"]
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e, overflow: TextOverflow.ellipsis),
                                    ))
                                .toList(),
                            onChanged: (v) => setState(() => _unidadeAgua = v!),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: _input("Dispositivo", high, f),
                      dropdownColor: high ? DarkPalette.surfaceElevated : Colors.white,
                      style: TextStyle(
                        color: high ? DarkPalette.textPrimary : Colors.black,
                        fontSize: 14 * f,
                      ),
                      items: const [
                        "Irriga 1000",
                        "Hortas 03012",
                        "Irrigation PRO"
                      ]
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e, overflow: TextOverflow.ellipsis),
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
                            style: TextStyle(
                              color: high ? DarkPalette.textPrimary : Colors.black,
                              fontSize: 14 * f,
                            ),
                            decoration: _input("Periodicidade", high, f),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _unidadeTempo,
                            dropdownColor: high ? DarkPalette.surfaceElevated : Colors.white,
                            style: TextStyle(
                              color: high ? DarkPalette.textPrimary : Colors.black,
                              fontSize: 14 * f,
                            ),
                            decoration: _input("Unidade", high, f),
                            items: const ["Horas", "Dias", "Semanas"]
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e, overflow: TextOverflow.ellipsis),
                                    ))
                                .toList(),
                            onChanged: (v) => setState(() => _unidadeTempo = v!),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// BOTÕES
                    // CORRIGIDO: Wrap em vez de Row simples, para os botões
                    // quebrarem linha em telas estreitas ou fonte grande,
                    // em vez de estourar a largura do card.
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        OutlinedButton(
                          onPressed: () => _formKey.currentState?.reset(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: high ? Colors.cyanAccent : azulPrimario,
                            side: BorderSide(color: high ? DarkPalette.surfaceBorder : azulPrimario),
                          ),
                          child: Text("Limpar", style: TextStyle(fontSize: 14 * f)),
                        ),
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
                          label: Text(
                            "Salvar",
                            style: TextStyle(fontSize: 14 * f, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: high ? DarkPalette.surfaceElevated : azulPrimario,
                            foregroundColor: high ? Colors.cyanAccent : Colors.white,
                            side: high ? const BorderSide(color: Colors.cyanAccent, width: 1.5) : BorderSide.none,
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
        decoration: BoxDecoration(
          gradient: high
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [DarkPalette.background, DarkPalette.surface],
                )
              : null,
          color: high ? null : azulPrimario,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: Center(
                child: Text(
                  "HYDROFLOW",
                  style: TextStyle(
                    color: high ? Colors.cyanAccent : Colors.white,
                    fontSize: 26 * f,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Divider(color: high ? DarkPalette.surfaceBorder : Colors.white24),
            _drawerItem(Icons.home, "Painel", '/dashboard', f),
            _drawerItem(Icons.eco, "Plantas", '/plantas', f),
            _drawerItem(Icons.history, "Histórico", '/historico', f),
            _drawerItem(Icons.memory, "Equipamentos", '/equipamentos', f),
            const Spacer(),
            Divider(color: high ? DarkPalette.surfaceBorder : Colors.white24),
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