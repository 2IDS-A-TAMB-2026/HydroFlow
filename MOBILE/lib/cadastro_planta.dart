import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcc/botao_acessibilidade.dart';
import 'accessibility_provider.dart';
import 'package:provider/provider.dart';

//  PALETA DO MODO ESCURO (mesma do dashboard/plantas)

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
  static const String _urlApi =
      'http://10.141.131.38/HydroFlow/public/api/plantas/novo';

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _culturaController = TextEditingController();
  final TextEditingController _qtdAguaController = TextEditingController();
  final TextEditingController _periodoController = TextEditingController();

  String? _tipoSelecionado;
  String? _dispositivoSelecionado;

  String _unidadeAgua = 'Litros/dia';
  String _unidadeTempo = 'Dias';

  bool salvando = false;

  // Nome exibido -> ID no banco (ajuste para os IDs reais da tabela de dispositivos)
  final Map<String, int> _dispositivos = {
    "Irriga 1000": 1,
    "Hortas 03012": 2,
    "Irrigation PRO": 3,
  };

  static const azulPrimario = Color(0xFF002855);

  @override
  void dispose() {
    _nomeController.dispose();
    _culturaController.dispose();
    _qtdAguaController.dispose();
    _periodoController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _limpar() {
    _formKey.currentState?.reset();
    _nomeController.clear();
    _culturaController.clear();
    _qtdAguaController.clear();
    _periodoController.clear();
    setState(() {
      _tipoSelecionado = null;
      _dispositivoSelecionado = null;
      _unidadeAgua = 'Litros/dia';
      _unidadeTempo = 'Dias';
    });
  }

  /// ─────────────────────────────────────────────
  /// ENVIO PARA A API (POST)
  /// ─────────────────────────────────────────────
  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    // Converte para as unidades que o banco guarda (litros e dias)
    double qtd = double.parse(_qtdAguaController.text.replaceAll(',', '.'));
    if (_unidadeAgua == 'mL/dia') qtd = qtd / 1000;

    double periodo = double.parse(_periodoController.text.replaceAll(',', '.'));
    if (_unidadeTempo == 'Horas') periodo = periodo / 24;
    if (_unidadeTempo == 'Semanas') periodo = periodo * 7;
    final periodoDias = periodo.round() < 1 ? 1 : periodo.round();

    final dadosPlanta = {
      "PLANTA_NOME": _nomeController.text.trim(),
      "PLANTA_TIPO": _tipoSelecionado,
      "PLANTA_CULTURA": _culturaController.text.trim(),
      "PLANTA_QTD_AGUA": qtd,
      "PLANTA_PERIDIOCIDADE": periodoDias,
      "FK_USU_ID": 1, // fixo enquanto o login não existe
      "FK_DIS_ID": _dispositivos[_dispositivoSelecionado],
    };

    setState(() => salvando = true);

    try {
      final response = await http.post(
        Uri.parse(_urlApi),
        headers: {
          "Accept": "application/json",
        },
        body: jsonEncode(dadosPlanta),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Planta cadastrada com sucesso!')),
        );
        _limpar();
        Navigator.pushReplacementNamed(context, '/plantas');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ${response.statusCode}: ${response.body}'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao acessar a API: $e')),
      );
    } finally {
      if (mounted) setState(() => salvando = false);
    }
  }

  String? _validaObrigatorio(String? v, String msg) {
    if (v == null || v.trim().isEmpty) return msg;
    return null;
  }

  String? _validaNumero(String? v) {
    if (v == null || v.trim().isEmpty) return 'Obrigatório';
    final n = double.tryParse(v.replaceAll(',', '.'));
    if (n == null || n <= 0) return 'Valor inválido';
    return null;
  }

  // Função que aceita os parâmetros de acessibilidade dinamicamente
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
        borderSide: BorderSide(
            color: high
                ? DarkPalette.surfaceBorder
                : Colors.grey.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: high ? Colors.cyanAccent : azulPrimario, width: 2),
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

    final estiloTexto = TextStyle(
      color: high ? DarkPalette.textPrimary : Colors.black,
      fontSize: 14 * f,
    );

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
                border: high
                    ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5)
                    : null,
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
                    /// HEADER INTERNO
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.eco,
                                  color: high
                                      ? Colors.cyanAccent
                                      : azulPrimario),
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
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, '/plantas'),
                          icon: const Icon(Icons.list),
                          label: Text(
                            "Ver plantas",
                            style: TextStyle(fontSize: 14 * f),
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor:
                                high ? Colors.cyanAccent : azulPrimario,
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
                      style: estiloTexto,
                      decoration: _input("Nome da planta", high, f,
                          hint: "Ex: Tomate Carmem"),
                      validator: (v) => _validaObrigatorio(v, 'Informe o nome'),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            isExpanded: true, // evita overflow do texto do item
                            value: _tipoSelecionado,
                            dropdownColor:
                                high ? DarkPalette.surfaceElevated : Colors.white,
                            style: estiloTexto,
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
                                      child: Text(e,
                                          overflow: TextOverflow.ellipsis),
                                    ))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _tipoSelecionado = v),
                            validator: (v) =>
                                v == null ? 'Selecione o tipo' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _culturaController,
                            style: estiloTexto,
                            decoration: _input("Cultura", high, f),
                            validator: (v) =>
                                _validaObrigatorio(v, 'Informe a cultura'),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _qtdAguaController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            style: estiloTexto,
                            decoration: _input("Quantidade de água", high, f),
                            validator: _validaNumero,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _unidadeAgua,
                            dropdownColor:
                                high ? DarkPalette.surfaceElevated : Colors.white,
                            style: estiloTexto,
                            decoration: _input("Unidade", high, f),
                            items: const ["Litros/dia", "mL/dia"]
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e,
                                          overflow: TextOverflow.ellipsis),
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
                      value: _dispositivoSelecionado,
                      decoration: _input("Dispositivo", high, f),
                      dropdownColor:
                          high ? DarkPalette.surfaceElevated : Colors.white,
                      style: estiloTexto,
                      items: _dispositivos.keys
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e, overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _dispositivoSelecionado = v),
                      validator: (v) =>
                          v == null ? 'Selecione o dispositivo' : null,
                    ),

                    const SizedBox(height: 12),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _periodoController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            style: estiloTexto,
                            decoration: _input("Periodicidade", high, f),
                            validator: _validaNumero,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _unidadeTempo,
                            dropdownColor:
                                high ? DarkPalette.surfaceElevated : Colors.white,
                            style: estiloTexto,
                            decoration: _input("Unidade", high, f),
                            items: const ["Horas", "Dias", "Semanas"]
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e,
                                          overflow: TextOverflow.ellipsis),
                                    ))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _unidadeTempo = v!),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// BOTÕES
                    // Quebram linha em telas estreitas ou fonte grande,
                    // em vez de estourar a largura do card.
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        OutlinedButton(
                          onPressed: salvando ? null : _limpar,
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                high ? Colors.cyanAccent : azulPrimario,
                            side: BorderSide(
                                color: high
                                    ? DarkPalette.surfaceBorder
                                    : azulPrimario),
                          ),
                          child: Text("Limpar",
                              style: TextStyle(fontSize: 14 * f)),
                        ),
                        ElevatedButton.icon(
                          onPressed: salvando ? null : _salvar,
                          icon: salvando
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: high
                                        ? Colors.cyanAccent
                                        : Colors.white,
                                  ),
                                )
                              : const Icon(Icons.check),
                          label: Text(
                            salvando ? "Salvando..." : "Salvar",
                            style: TextStyle(
                                fontSize: 14 * f, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                high ? DarkPalette.surfaceElevated : azulPrimario,
                            foregroundColor:
                                high ? Colors.cyanAccent : Colors.white,
                            side: high
                                ? const BorderSide(
                                    color: Colors.cyanAccent, width: 1.5)
                                : BorderSide.none,
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

  /// DRAWER
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
            _drawerItem(
                Icons.history, "Histórico de Ativação", '/historico', f),
            _drawerItem(
                Icons.history, "Histórico de Medição", '/dados_sensores', f),
            _drawerItem(Icons.memory, "sensores", '/sensores', f),
            const Spacer(),
            Divider(color: high ? DarkPalette.surfaceBorder : Colors.white24),
            _drawerItem(Icons.logout, "Sair", '/login', f, isLogout: true),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, String route, double f,
      {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title:
          Text(title, style: TextStyle(color: Colors.white, fontSize: 14 * f)),
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