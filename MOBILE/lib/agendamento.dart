import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgendamentoPage extends StatefulWidget {
  const AgendamentoPage({super.key});

  @override
  State<AgendamentoPage> createState() => _AgendamentoPageState();
}

class _AgendamentoPageState extends State<AgendamentoPage> {
  final _formKey = GlobalKey<FormState>();
  String? _setorSelecionado;
  String? _dispositivoSelecionado;
  DateTime _dataSelecionada = DateTime.now();
  TimeOfDay _horaSelecionada = TimeOfDay.now();

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

  // 🔥 FUNÇÃO DE NAVEGAÇÃO INTELIGENTE
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
        title: const Text("Agendamento de Irrigações"),
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
              if (_isAdmin) _buildFormCard(),
              if (_isAdmin) const SizedBox(height: 20),
              _buildAgendamentosTable(),
            ],
          ),
        ),
      ),
    );
  }

  // --- FORMULÁRIO ---
  Widget _buildFormCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.water_drop, color: Color(0xFF002855)),
                  SizedBox(width: 10),
                  Text("Novo Agendamento",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(height: 30),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    labelText: "Setor / Área", border: OutlineInputBorder()),
                items: ["Estufa 1", "Estufa 2", "Campo Aberto"]
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => _setorSelecionado = val),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text("Data"),
                      subtitle: Text(
                          "${_dataSelecionada.day}/${_dataSelecionada.month}/${_dataSelecionada.year}"),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _dataSelecionada,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030));
                        if (picked != null) setState(() => _dataSelecionada = picked);
                      },
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text("Horário"),
                      subtitle: Text(_horaSelecionada.format(context)),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        TimeOfDay? picked = await showTimePicker(
                            context: context, initialTime: _horaSelecionada);
                        if (picked != null) setState(() => _horaSelecionada = picked);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    labelText: "Dispositivo Responsável", border: OutlineInputBorder()),
                items: ["Irriga 1000", "Hortas 03012", "Irrigator Bonito"]
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (val) => setState(() => _dispositivoSelecionado = val),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Agendamento Salvo!")));
                  },
                  icon: const Icon(Icons.check),
                  label: const Text("Salvar Agendamento"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF002855),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- TABELA ---
  Widget _buildAgendamentosTable() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.list_alt, color: Colors.orange),
                SizedBox(width: 10),
                Text("Próximas Irrigações",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Setor")),
                  DataColumn(label: Text("Data/Hora")),
                  DataColumn(label: Text("Status")),
                ],
                rows: [
                  _dataRow("Estufa 1", "14/04 - 06:00", "CONCLUÍDO", Colors.green),
                  _dataRow("Pomar", "14/04 - 16:30", "AGENDADO", Colors.orange),
                  _dataRow("Campo Aberto", "15/04 - 05:30", "AGENDADO", Colors.orange),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _dataRow(String setor, String data, String status, Color color) {
    return DataRow(cells: [
      DataCell(Text(setor)),
      DataCell(Text(data)),
      DataCell(Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
        child: Text(status,
            style: const TextStyle(
                color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
      )),
    ]);
  }

  // --- DRAWER ATUALIZADO (Estilo Imagem + Inteligente) ---
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
            
            // Botão Painel Inteligente
            _drawerItem(Icons.home, "Painel", _navegarParaPainelCorreto),
            
            _drawerItem(Icons.calendar_month, "Agendamentos", () => Navigator.pop(context), active: true),
            
            _drawerItem(Icons.park, "Plantas", () => Navigator.pushNamed(context, '/plantas')),
            
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

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap,
      {bool active = false}) {
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