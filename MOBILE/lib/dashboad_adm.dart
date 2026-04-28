import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardAdminPage extends StatelessWidget {
  const DashboardAdminPage({super.key});

  // Cores oficiais extraídas da sua imagem
  static const Color azulFundoMenu = Color(0xFF002855);
  static const Color offWhite = Color(0xFFF5F6FA);

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      
      // 🍔 MENU SANDUÍCHE IDENTICO À IMAGEM
      drawer: Drawer(
        child: Container(
          color: azulFundoMenu,
          child: Column(
            children: [
              // Cabeçalho sem "Box" - Apenas o texto e a divisória
              Container(
                height: 160,
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text(
                  "HYDROFLOW",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              
              // Linha divisória branca igual à imagem
              const Divider(color: Colors.white, thickness: 1.2, height: 1),
              
              const SizedBox(height: 10),

              // Itens do Menu com ícones e textos brancos
              _menuItem(Icons.dashboard, "Painel Geral", false, () {
                Navigator.pushReplacementNamed(context, '/dashboard_admin');
              }),
              _menuItem(Icons.eco, "Cadastro de Plantas", false, () {
                Navigator.pushNamed(context, '/cadastro_plantas');
              }),
              _menuItem(Icons.history, "Histórico", false, () {
                Navigator.pushNamed(context, '/historico');
              }),
              _menuItem(Icons.shopping_cart, "Equipamentos", false, () {
                Navigator.pushNamed(context, '/equipamentos');
              }),

              const Spacer(),
              
              const Divider(color: Colors.white24),
              _menuItem(Icons.logout, "Encerrar Sessão", false, () => _logout(context)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      appBar: AppBar(
        title: const Text("Console do Administrador"),
        backgroundColor: Colors.white,
        foregroundColor: azulFundoMenu,
        elevation: 0,
        actions: const [
          Icon(Icons.security),
          SizedBox(width: 15),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔷 KPIs ADMINISTRATIVOS
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: const [
                SizedBox(width: 155, child: KPIcard("1.2k", "Usuários Ativos", Color(0xFF007BFF))),
                SizedBox(width: 155, child: KPIcard("45", "Alertas Críticos", Colors.orange)),
                SizedBox(width: 155, child: KPIcard("99.9%", "Uptime Server", Color(0xFF17A2B8))),
                SizedBox(width: 155, child: KPIcard("08", "Hardware Offline", Colors.red)),
              ],
            ),
            const SizedBox(height: 20),
            _table(),
            const SizedBox(height: 16),
            _chart(),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _menuItem(IconData icon, String title, bool active, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      tileColor: active ? Colors.white.withOpacity(0.1) : Colors.transparent,
      onTap: onTap,
    );
  }

  Widget _table() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Monitoramento de Dispositivos", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Node ID")),
                  DataColumn(label: Text("Localização")),
                  DataColumn(label: Text("Status")),
                ],
                rows: const [
                  DataRow(cells: [DataCell(Text("GW-001")), DataCell(Text("Setor Norte")), DataCell(Text("ONLINE"))]),
                  DataRow(cells: [DataCell(Text("GW-002")), DataCell(Text("Setor Sul")), DataCell(Text("ONLINE"))]),
                  DataRow(cells: [DataCell(Text("GW-009")), DataCell(Text("Setor Leste")), DataCell(Text("OFFLINE"))]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Tráfego Global de Dados (MB/s)", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [FlSpot(0, 10), FlSpot(1, 25), FlSpot(2, 18), FlSpot(3, 40), FlSpot(4, 32)],
                      isCurved: true,
                      color: const Color(0xFF007BFF),
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KPIcard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const KPIcard(this.value, this.label, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}