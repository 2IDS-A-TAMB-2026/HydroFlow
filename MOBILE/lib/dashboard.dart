import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Cores oficiais Hydroflow
  static const Color azulPrimario = Color(0xFF002855);
  static const Color azulBanco = Color(0xFF0D47A1);
  static const Color azulCyan = Color(0xFF4DD0E1);
  static const Color offWhite = Color(0xFFF5F6FA);

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,

      // Drawer padronizado
      drawer: _buildDrawer(context),

      appBar: AppBar(
        title: const Text("Painel Hydroflow"),
        backgroundColor: azulPrimario,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Status em Tempo Real",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: azulPrimario,
              ),
            ),

            const SizedBox(height: 20),

            // Cards KPI
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: 160,
                  child: KPIcard(
                    "24°C",
                    "Temp. Ambiente",
                    Colors.orange,
                  ),
                ),

                SizedBox(
                  width: 160,
                  child: KPIcard(
                    "65%",
                    "Umidade Solo",
                    azulCyan,
                  ),
                ),

                SizedBox(
                  width: 160,
                  child: KPIcard(
                    "Ligado",
                    "Status Bomba",
                    Colors.green,
                  ),
                ),

                SizedBox(
                  width: 160,
                  child: KPIcard(
                    "120L",
                    "Consumo Diário",
                    azulBanco,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Card central
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Próxima Rega Agendada",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(
                        Icons.timer,
                        color: azulCyan,
                      ),

                      const SizedBox(width: 10),

                      Text(
                        "Hoje às 18:30",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // DRAWER
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: azulPrimario,

        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: azulPrimario,
              ),

              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "HYDROFLOW",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Sistema de Irrigação Inteligente",
                      style: TextStyle(
                        color: azulCyan,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Itens do menu
            _drawerItem(
              Icons.home,
              "Painel",
              () => Navigator
                  .pushReplacementNamed(
                context,
                '/dashboard',
              ),
            ),

            _drawerItem(
              Icons.calendar_month,
              "Agendamentos",
              () => Navigator.pushNamed(
                context,
                '/agendamentos',
              ),
            ),

            _drawerItem(
              Icons.park,
              "Plantas",
              () => Navigator.pushNamed(
                context,
                '/plantas',
              ),
            ),

            _drawerItem(
              Icons.history,
              "Histórico",
              () => Navigator.pushNamed(
                context,
                '/historico',
              ),
            ),

            _drawerItem(
              Icons.shopping_cart,
              "Equipamentos",
              () => Navigator.pushNamed(
                context,
                '/equipamentos',
              ),
            ),
            const Spacer(),

            const Divider(color: Colors.white24),

            _drawerItem(
              Icons.logout,
              "Sair",
              () => _logout(context),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool active = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),

      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),

      tileColor:
          active ? Colors.blue.withOpacity(0.3) : Colors.transparent,

      onTap: onTap,
    );
  }
}

class KPIcard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const KPIcard(
    this.value,
    this.label,
    this.color, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}