import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // 🔐 LOGOUT
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogged', false);

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // SIDEBAR
          Container(
            width: 250,
            color: const Color(0xFF002855),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  "HYDROFLOW",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 20),
                _menuItem(Icons.home, "Painel", true),
                _menuItem(Icons.calendar_month, "Agendamentos", false),
                _menuItem(Icons.eco, "Cadastro de Plantas", false),
                _menuItem(Icons.park, "Plantas", false),
                _menuItem(Icons.history, "Histórico", false),
                _menuItem(Icons.shopping_cart, "Equipamentos", false),

                const Spacer(),

                // 🔴 BOTÃO LOGOUT
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text("Sair",
                      style: TextStyle(color: Colors.white)),
                  onTap: () => _logout(context),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          // MAIN CONTENT
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: Column(
                children: [
                  // TOP BAR
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Painel",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 10),
                            Icon(Icons.notifications),
                          ],
                        )
                      ],
                    ),
                  ),

                  // KPI CARDS
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: const [
                        KPIcard("66", "Dispositivos Ativos", Colors.cyan),
                        KPIcard("68", "Alertas", Colors.orange),
                        KPIcard("30", "Plantas", Colors.green),
                        KPIcard("30", "Inativos", Colors.red),
                      ],
                    ),
                  ),

                  // GRID
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(child: _table()),
                          const SizedBox(width: 16),
                          Expanded(child: _chart()),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, bool active) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      tileColor: active ? Colors.blue : Colors.transparent,
    );
  }

  Widget _table() {
    return Card(
      child: DataTable(columns: const [
        DataColumn(label: Text("Planta")),
        DataColumn(label: Text("Dispositivo")),
        DataColumn(label: Text("Status")),
      ], rows: const [
        DataRow(cells: [
          DataCell(Text("Samambaia")),
          DataCell(Text("Irriga 1000")),
          DataCell(Text("IRRIGADO")),
        ]),
        DataRow(cells: [
          DataCell(Text("Tomateira")),
          DataCell(Text("Irrigador Lest")),
          DataCell(Text("IRRIGADO")),
        ]),
        DataRow(cells: [
          DataCell(Text("Cliente 2")),
          DataCell(Text("2,00")),
          DataCell(Text("FALHA")),
        ]),
      ]),
    );
  }

  Widget _chart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 1),
                  FlSpot(1, 3),
                  FlSpot(2, 2),
                  FlSpot(3, 5),
                ],
                isCurved: true,
              )
            ],
          ),
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
    return Expanded(
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Text(label,
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}