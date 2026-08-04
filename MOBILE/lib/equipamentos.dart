import 'package:flutter/material.dart';
import 'package:tcc/botao_acessibilidade.dart';
import 'accessibility_provider.dart';
import 'package:provider/provider.dart';

/// ─────────────────────────────────────────────
///  PALETA DO MODO ESCURO
/// ─────────────────────────────────────────────
class DarkPalette {
  static const Color background = Color(0xFF0A1A2B);
  static const Color surface = Color(0xFF10263D);
  static const Color surfaceElevated = Color(0xFF16324B);
  static const Color surfaceBorder = Color(0xFF1E3B57);
  static const Color textPrimary = Color(0xFFF2F6FA);
  static const Color textSecondary = Color(0xFFA9C0D6);
}

class EquipamentosPage extends StatefulWidget {
  const EquipamentosPage({super.key});

  @override
  State<EquipamentosPage> createState() => _EquipamentosPageState();
}

class _EquipamentosPageState extends State<EquipamentosPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeDispController = TextEditingController();
  final _capacidadeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _ruaController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _numeroController = TextEditingController();
  final _cepController = TextEditingController();

  bool _sensorSolo = false;
  bool _sensorTemperatura = false;
  bool _sensorUmidadeAr = false;

  static const azul = Color(0xFF002855);
  static const verde = Color(0xFF00A65A);

  void _salvarDispositivo() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Dispositivo salvo com sucesso!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escutando as mudanças do Provider de Acessibilidade
    final acc = Provider.of<AccessibilityProvider>(context);
    final high = acc.isHighContrast;
    final f = acc.fontSizeFactor;

    // Definição de cores dinâmicas baseadas no contraste
    final bgPage = high ? DarkPalette.background : const Color(0xFFF4F6F9);
    final bgCard = high ? DarkPalette.surface : Colors.white;
    final appBarBg = high ? DarkPalette.surface : azul;
    final txtPrincipal = high ? Colors.cyanAccent : azul;
    final appBarBorder = high
        ? const BorderSide(color: DarkPalette.surfaceBorder, width: 2)
        : BorderSide.none;

    return Scaffold(
      backgroundColor: bgPage,

      appBar: AppBar(
        title: Text(
          "Equipamentos",
          style: TextStyle(fontSize: 20 * f),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: appBarBg,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: Border(bottom: appBarBorder),
        actions: const [BotaoAcessibilidade()],
      ),

      drawer: _buildDrawer(context, high, f),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Text(
              "Gestão de Equipamentos",
              style: TextStyle(
                fontSize: 22 * f,
                fontWeight: FontWeight.bold,
                color: txtPrincipal,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "Cadastre e gerencie dispositivos de irrigação",
              style: TextStyle(
                fontSize: 14 * f,
                color: high ? DarkPalette.textSecondary : Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            /// CARD PRINCIPAL
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: bgCard,
                borderRadius: BorderRadius.circular(16),
                border: high ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5) : null,
                boxShadow: high
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                        )
                      ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dispositivo",
                      style: TextStyle(
                        fontSize: 16 * f,
                        fontWeight: FontWeight.bold,
                        color: txtPrincipal,
                      ),
                    ),

                    const SizedBox(height: 15),

                    _field("Nome do dispositivo", _nomeDispController, high, f),

                    const SizedBox(height: 12),

                    // CORRIGIDO: "Capacidade" e "Descrição" lado a lado com
                    // largura fixa igual podiam apertar o texto com fonte
                    // grande de acessibilidade; os TextFormField já cortam
                    // com ellipsis internamente, mas o Row garante o espaço.
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _field("Capacidade", _capacidadeController, high, f),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _field("Descrição", _descricaoController, high, f),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Text(
                      "Sensores",
                      style: TextStyle(
                        fontSize: 16 * f,
                        fontWeight: FontWeight.bold,
                        color: txtPrincipal,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _switchTile(
                      "Umidade do Solo",
                      Icons.grass,
                      _sensorSolo,
                      (v) => setState(() => _sensorSolo = v),
                      high,
                      f,
                    ),

                    _switchTile(
                      "Temperatura",
                      Icons.thermostat,
                      _sensorTemperatura,
                      (v) => setState(() => _sensorTemperatura = v),
                      high,
                      f,
                    ),

                    _switchTile(
                      "Umidade do Ar",
                      Icons.water_drop,
                      _sensorUmidadeAr,
                      (v) => setState(() => _sensorUmidadeAr = v),
                      high,
                      f,
                    ),

                    const SizedBox(height: 25),

                    Text(
                      "Localização",
                      style: TextStyle(
                        fontSize: 16 * f,
                        fontWeight: FontWeight.bold,
                        color: txtPrincipal,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(child: _field("Latitude", _latitudeController, high, f)),
                        const SizedBox(width: 10),
                        Expanded(child: _field("Longitude", _longitudeController, high, f)),
                      ],
                    ),

                    const SizedBox(height: 12),

                    _field("Rua", _ruaController, high, f),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(child: _field("Bairro", _bairroController, high, f)),
                        const SizedBox(width: 10),
                        Expanded(child: _field("Cidade", _cidadeController, high, f)),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(child: _field("Número", _numeroController, high, f)),
                        const SizedBox(width: 10),
                        Expanded(child: _field("CEP", _cepController, high, f)),
                      ],
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _salvarDispositivo,
                        icon: const Icon(Icons.save),
                        label: Text(
                          "Salvar Equipamento",
                          style: TextStyle(fontSize: 16 * f, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: high ? DarkPalette.surfaceElevated : azul,
                          foregroundColor: high ? Colors.cyanAccent : Colors.white,
                          side: high ? const BorderSide(color: Colors.cyanAccent, width: 1.5) : BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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

  Widget _field(String label, TextEditingController c, bool high, double f) {
    return TextFormField(
      controller: c,
      validator: (v) => v == null || v.isEmpty ? "Obrigatório" : null,
      style: TextStyle(color: high ? DarkPalette.textPrimary : Colors.black, fontSize: 14 * f),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: high ? DarkPalette.textSecondary : Colors.black54, fontSize: 14 * f),
        filled: true,
        fillColor: high ? DarkPalette.surface : const Color(0xFFF5F7FA),
        errorStyle: TextStyle(fontSize: 12 * f, fontWeight: FontWeight.bold),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: high ? DarkPalette.surfaceBorder : Colors.grey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: high ? Colors.cyanAccent : azul, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  Widget _switchTile(
    String title,
    IconData icon,
    bool value,
    Function(bool) onChanged,
    bool high,
    double f,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: high ? DarkPalette.surface : const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: high ? Border.all(color: DarkPalette.surfaceBorder) : null,
      ),
      child: SwitchListTile(
        value: value,
        onChanged: (v) => onChanged(v),
        title: Row(
          children: [
            Icon(icon, color: high ? Colors.cyanAccent : azul),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14 * f,
                  color: high ? DarkPalette.textPrimary : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        // CORRIGIDO: no modo escuro o switch ativo usava branco puro,
        // agora usa verde (mesma cor de "irrigado"/"concluído" no resto
        // do app) para manter a linguagem visual de cor = status positivo.
        activeColor: high ? Colors.greenAccent : verde,
        activeTrackColor: high ? Colors.greenAccent.withOpacity(0.3) : verde.withOpacity(0.4),
      ),
    );
  }

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
          color: high ? null : azul,
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Text(
              "HYDROFLOW",
              style: TextStyle(
                color: high ? Colors.cyanAccent : Colors.white,
                fontSize: 24 * f,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: high ? DarkPalette.surfaceBorder : Colors.white24),

            _item(Icons.home, "Painel", "/dashboard", context, f),
            _item(Icons.park, "Plantas", "/plantas", context, f),
            _item(Icons.history, "Histórico", "/historico", context, f),
            _item(Icons.memory, "Equipamentos", "/equipamentos", context, f),

            const Spacer(),
            Divider(color: high ? DarkPalette.surfaceBorder : Colors.white24),

            _item(Icons.logout, "Sair", "/login", context, f),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _item(
    IconData icon,
    String title,
    String route,
    BuildContext context,
    double f,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 14 * f),
      ),
      onTap: () {
        Navigator.pop(context);
        try {
          Navigator.pushReplacementNamed(context, route);
        } catch (e) {
          debugPrint("Rota $route não configurada.");
        }
      },
    );
  }
}