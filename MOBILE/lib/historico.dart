import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAdmin = prefs.getBool('isAdmin') ?? false;
    });
  }

  // 🔥 Lógica de navegação inteligente para o Painel
  void _navegarParaPainelCorreto() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isAdmin = prefs.getBool('isAdmin') ?? false;

    if (!mounted) return;

    if (isAdmin) {
      Navigator.pushReplacementNamed(context, '/dashboard_admin');
    } else {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Histórico de Ativações"),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF002855),
        elevation: 0,
      ),
      drawer: _buildDrawer(context),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildFilterWidget(context),
              const SizedBox(height: 20),
              _buildHistoryTable(context),
            ],
          ),
        ),
      ),
    );
  }

  // --- SEÇÃO DE FILTROS ---
  Widget _buildFilterWidget(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.filter_list, color: Color(0xFF002855)),
                SizedBox(width: 8),
                Text("Filtros de Busca", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                _filterItem("Data Inicial", "01/04/2026", context),
                _filterItem("Data Final", "14/04/2026", context),
                _filterDropdown("Setor / Área", ["Todos os Setores", "Estufa 1", "Estufa 2", "Campo"]),
                _filterDropdown("Status", ["Todos", "Concluído", "Falha", "Interrompido"]),
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                    label: const Text("Filtrar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002855),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- TABELA DE HISTÓRICO ---
  Widget _buildHistoryTable(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.assignment, color: Color(0xFF002855)),
                    SizedBox(width: 8),
                    Text("Registros de Irrigação", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const Divider(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Data e Hora", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Setor / Cultura")),
                  DataColumn(label: Text("Duração")),
                  DataColumn(label: Text("Volume")),
                  DataColumn(label: Text("Acionamento")),
                  DataColumn(label: Text("Status")),
                ],
                rows: [
                  _historyRow("14/04 - 06:00", "Estufa 1 (Tomate)", "30 min", "150L", Icons.smart_toy, "Automático", "Concluído", Colors.green),
                  _historyRow("13/04 - 18:00", "Campo (Milho)", "15 min", "250L", Icons.smart_toy, "Automático", "Falha", Colors.red),
                  _historyRow("13/04 - 14:30", "Estufa 2 (Morango)", "45 min", "80L", Icons.touch_app, "Manual", "Concluído", Colors.green),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- DRAWER UNIFICADO (Estilo Imagem) ---
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF002855),
        child: Column(
          children: [
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
                    letterSpacing: 1.2),
              ),
            ),
            const Divider(color: Colors.white, thickness: 1.2, height: 1),
            const SizedBox(height: 10),
            
            _drawerItem(Icons.home, "Painel", _navegarParaPainelCorreto),
            _drawerItem(Icons.calendar_month, "Agendamentos", () => Navigator.pushNamed(context, '/agendamentos')),
            _drawerItem(Icons.park, "Plantas", () => Navigator.pushNamed(context, '/plantas')),
            _drawerItem(Icons.history, "Histórico", () => Navigator.pop(context), active: true),

            if (_isAdmin) ...[
              const Divider(color: Colors.white24),
              _drawerItem(Icons.eco, "Cadastro de Plantas", () => Navigator.pushNamed(context, '/cadastro_plantas')),
              _drawerItem(Icons.shopping_cart, "Equipamentos", () => Navigator.pushNamed(context, '/equipamentos')),
            ],
            
            const Spacer(),
            const Divider(color: Colors.white24),
            _drawerItem(Icons.logout, "Sair", _logout),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap, {bool active = false}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 24),
      title: Text(title,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
      tileColor: active ? Colors.white.withOpacity(0.15) : Colors.transparent,
      onTap: onTap,
    );
  }

  // --- COMPONENTES AUXILIARES ---
  Widget _filterItem(String label, String value, BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: value,
              suffixIcon: const Icon(Icons.calendar_month, size: 18),
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterDropdown(String label, List<String> options) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: options[0],
            items: options.map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(fontSize: 13)))).toList(),
            onChanged: (val) {},
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _historyRow(String data, String setor, String duracao, String vol, IconData icon, String tipo, String status, Color statusColor) {
    return DataRow(cells: [
      DataCell(Text(data, style: const TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text(setor)),
      DataCell(Text(duracao)),
      DataCell(Text(vol)),
      DataCell(Row(children: [Icon(icon, size: 16), const SizedBox(width: 5), Text(tipo)])),
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(20)),
          child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
        ),
      ),
    ]);
  }
}