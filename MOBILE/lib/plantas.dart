import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlantasPage extends StatefulWidget {
  const PlantasPage({super.key});

  @override
  State<PlantasPage> createState() => _PlantasPageState();
}

class _PlantasPageState extends State<PlantasPage> {
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
        title: const Text("Listagem de Culturas"),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF002855),
        elevation: 0,
      ),
      drawer: _buildDrawer(context),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.list, color: Color(0xFF002855)),
                          SizedBox(width: 10),
                          Text("Plantas Cadastradas",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      if (_isAdmin)
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/cadastro_plantas'),
                          icon: const Icon(Icons.add),
                          label: const Text("Nova Planta"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF002855),
                            foregroundColor: Colors.white,
                          ),
                        ),
                    ],
                  ),
                  const Divider(height: 30),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Buscar por nome ou cultura...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                      columns: [
                        const DataColumn(label: Text("Nome", style: TextStyle(fontWeight: FontWeight.bold))),
                        const DataColumn(label: Text("Tipo")),
                        const DataColumn(label: Text("Cultura")),
                        const DataColumn(label: Text("Parâmetros")),
                        if (_isAdmin) const DataColumn(label: Text("Ações")),
                      ],
                      rows: [
                        _plantaRow("Tomate Carmem", "Hortaliça", "Solanáceas", "5L/dia (12h)"),
                        _plantaRow("Alface Crespa", "Hortaliça", "Folhosas", "2L/dia (24h)"),
                        _plantaRow("Couve Manteiga", "Hortaliça", "Folhosas", "3L/dia (10h)"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  DataRow _plantaRow(String nome, String tipo, String cultura, String params) {
    return DataRow(cells: [
      DataCell(Text(nome, style: const TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text(tipo)),
      DataCell(Text(cultura)),
      DataCell(Text(params)),
      if (_isAdmin)
        DataCell(Row(
          children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.blue, size: 20), onPressed: () {}),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 20), onPressed: () {}),
          ],
        )),
    ]);
  }

  // --- DRAWER UNIFICADO ---
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
            _drawerItem(Icons.park, "Plantas", () => Navigator.pop(context), active: true),
            _drawerItem(Icons.history, "Histórico", () => Navigator.pushNamed(context, '/historico')),

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
}