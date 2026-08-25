import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcc/botao_acessibilidade.dart';
import 'accessibility_provider.dart';
import 'package:provider/provider.dart';
import 'api_service.dart'; // <--- Importando o serviço de API

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

class PlantasPage extends StatefulWidget {
  const PlantasPage({super.key});

  @override
  State<PlantasPage> createState() => _PlantasPageState();
}

class _PlantasPageState extends State<PlantasPage> {
  static const azul = Color(0xFF002855);
  final ApiService _apiService = ApiService();

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final acc = Provider.of<AccessibilityProvider>(context);
    final high = acc.isHighContrast;
    final f = acc.fontSizeFactor;

    final bgPage = high ? DarkPalette.background : const Color(0xFFF5F6FA);
    final bgContainer = high ? DarkPalette.surface : Colors.white;
    final appBarBg = high ? DarkPalette.surface : azul;
    final txtPrincipal = high ? Colors.cyanAccent : azul;
    final appBarBorder = high
        ? const BorderSide(color: DarkPalette.surfaceBorder, width: 2)
        : BorderSide.none;

    return Scaffold(
      backgroundColor: bgPage,
      appBar: AppBar(
        title: Text("Plantas", style: TextStyle(fontSize: 20 * f)),
        backgroundColor: appBarBg,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: Border(bottom: appBarBorder),
        actions: const [BotaoAcessibilidade()],
      ),
      drawer: _buildDrawer(high, f),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// HEADER SIMPLES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Gestão de Plantas",
                      style: TextStyle(
                        fontSize: 18 * f,
                        fontWeight: FontWeight.bold,
                        color: txtPrincipal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Cadastre e gerencie culturas",
                      style: TextStyle(
                        color: high ? DarkPalette.textSecondary : Colors.grey,
                        fontSize: 14 * f,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/cadastro_plantas'),
                  icon: Icon(Icons.add, size: 18 * f),
                  label: Text("Nova", style: TextStyle(fontSize: 14 * f, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: high ? DarkPalette.surfaceElevated : azul,
                    foregroundColor: high ? Colors.cyanAccent : Colors.white,
                    side: high ? const BorderSide(color: Colors.cyanAccent, width: 1.5) : BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// SEARCH BAR
            TextField(
              style: TextStyle(color: high ? DarkPalette.textPrimary : Colors.black, fontSize: 14 * f),
              decoration: InputDecoration(
                hintText: "Buscar planta...",
                hintStyle: TextStyle(
                  color: high ? DarkPalette.textSecondary : Colors.black38,
                  fontSize: 14 * f,
                ),
                prefixIcon: Icon(Icons.search, color: high ? Colors.cyanAccent : Colors.black45),
                filled: true,
                fillColor: high ? DarkPalette.surface : Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: high ? DarkPalette.surfaceBorder : Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: high ? Colors.cyanAccent : azul, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// TABELA INTEGRADA COM O GET DA API
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: bgContainer,
                  borderRadius: BorderRadius.circular(10),
                  border: high ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5) : null,
                ),
                child: FutureBuilder<List<dynamic>>(
                  future: _apiService.getPlantas(), // <--- CHAMA O GET /plantas AQUI
                  builder: (context, snapshot) {
                    // 1. Enquanto carrega a API
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // 2. Se der erro na conexão
                    // if (snapshot.hasError) {
                    //   return Center(
                    //     child: Text(
                    //       "Erro ao carregar dados da API",
                    //       style: TextStyle(color: high ? Colors.redAccent : Colors.red),
                    //     ),
                    //   );
                    // }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "ERRO: ${snapshot.error}",
                          style: TextStyle(
                            color: high ? Colors.redAccent : Colors.red,
                          ),
                        ),
                      );
                    }

                    // 3. Pegando a lista de plantas retornada pela API
                    final plantas = snapshot.data ?? [];

                    if (plantas.isEmpty) {
                      return Center(
                        child: Text(
                          "Nenhuma planta cadastrada.",
                          style: TextStyle(color: high ? DarkPalette.textSecondary : Colors.black54),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(
                            high ? DarkPalette.surfaceElevated : const Color(0xFFF0F2F5),
                          ),
                          headingTextStyle: TextStyle(
                            color: high ? Colors.cyanAccent : azul,
                            fontWeight: FontWeight.bold,
                            fontSize: 14 * f,
                          ),
                          dataTextStyle: TextStyle(
                            color: high ? DarkPalette.textSecondary : Colors.black87,
                            fontSize: 13 * f,
                          ),
                          columnSpacing: 25,
                          columns: const [
                            DataColumn(label: Text("Nome")),
                            DataColumn(label: Text("Tipo")),
                            DataColumn(label: Text("Cultura")),
                            DataColumn(label: Text("Consumo")),
                            DataColumn(label: Text("Ações")),
                          ],
                          rows: plantas.map((planta) {
                            return _row(
                              planta['PLANTA_NOME'] ?? 'Sem nome',
                              planta['PLANTA_TIPO'] ?? 'Geral',
                              planta['PLANTA_CULTURA'] ?? 'Outros',
                              planta['PLANTA_QTD_AGUA'] ?? 'N/A',
                              high,
                              f,
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _row(
    String nome,
    String tipo,
    String cultura,
    String consumo,
    bool high,
    double f,
  ) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            nome,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: high ? DarkPalette.textPrimary : Colors.black,
            ),
          ),
        ),
        DataCell(Text(tipo)),
        DataCell(Text(cultura)),
        DataCell(Text(consumo)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: high ? Colors.cyanAccent : Colors.blue, size: 18 * f),
                onPressed: () {},
                tooltip: "Editar",
              ),
              IconButton(
                icon: Icon(Icons.delete, color: high ? Colors.redAccent : Colors.red, size: 18 * f),
                onPressed: () {},
                tooltip: "Excluir",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer(bool high, double f) {
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

            _item(Icons.home, "Painel", '/dashboard', f),
            _item(Icons.park, "Plantas", '/plantas', f),
            _item(Icons.history, "Histórico", '/historico', f),
            _item(Icons.memory, "Equipamentos", '/equipamentos', f),

            const Spacer(),
            Divider(color: high ? DarkPalette.surfaceBorder : Colors.white24),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: Text("Sair", style: TextStyle(color: Colors.white, fontSize: 14 * f)),
              onTap: _logout,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, String label, String route, double f) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: TextStyle(color: Colors.white, fontSize: 14 * f)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}