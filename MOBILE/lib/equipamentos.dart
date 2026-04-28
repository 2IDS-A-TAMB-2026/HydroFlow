import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EquipamentosPage extends StatefulWidget {
  const EquipamentosPage({super.key});

  @override
  State<EquipamentosPage> createState() => _EquipamentosPageState();
}

class _EquipamentosPageState extends State<EquipamentosPage> {
  final _formSensorKey = GlobalKey<FormState>();
  final _formDispKey = GlobalKey<FormState>();
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
        title: const Text("Cadastro de Equipamentos"),
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
              _buildSensorCard(),
              const SizedBox(height: 20),
              _buildDispositivoCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- CARD 1: CADASTRO DE SENSORES ---
  Widget _buildSensorCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formSensorKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.sensors, color: Colors.blue),
                  SizedBox(width: 10),
                  Text("Cadastro de Sensores", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(height: 30),
              const Text("Registre novos sensores para monitoramento de campo.", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              
              const Text("Sensor de Umidade do Solo", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF002855))),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: "Nome do Sensor", border: OutlineInputBorder(), hintText: "Ex: Sensor Solo A1"),
              ),
              
              const Divider(height: 40),
              
              const Text("Sensor de Umidade do Ar e Temperatura", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF002855))),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: "Nome do Sensor", border: OutlineInputBorder(), hintText: "Ex: Sensor Temp A1"),
              ),
              
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text("Cadastrar Sensores"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, 
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- CARD 2: CADASTRO DE DISPOSITIVOS ---
  Widget _buildDispositivoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formDispKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.memory, color: Colors.orange),
                  SizedBox(width: 10),
                  Text("Cadastro de Dispositivos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(height: 30),
              
              Row(
                children: [
                  Expanded(flex: 2, child: _textField("Nome do Dispositivo", "Ex: Controlador Central")),
                  const SizedBox(width: 10),
                  Expanded(child: _textField("Capacidade", "Ex: 10L")),
                ],
              ),
              const SizedBox(height: 15),
              _textField("Descrição", "Função do dispositivo...", maxLines: 2),
              const SizedBox(height: 15),
              
              Row(
                children: [
                  Expanded(child: _textField("Latitude", "-23.XXXX")),
                  const SizedBox(width: 10),
                  Expanded(child: _textField("Longitude", "-46.XXXX")),
                ],
              ),
              
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text("Endereço de Instalação", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              
              _textField("Rua", "Rua José Calipto..."),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _textField("Bairro", "Jardim...")),
                  const SizedBox(width: 10),
                  Expanded(child: _textField("Cidade", "Tambaú")),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _textField("Número", "123")),
                  const SizedBox(width: 10),
                  Expanded(child: _textField("CEP", "13712-46")),
                ],
              ),
              
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.save),
                  label: const Text("Salvar Dispositivo"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(String label, String hint, {int maxLines = 1}) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        isDense: true,
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
            _drawerItem(Icons.history, "Histórico", () => Navigator.pushNamed(context, '/historico')),

            if (_isAdmin) ...[
              const Divider(color: Colors.white24),
              _drawerItem(Icons.eco, "Cadastro de Plantas", () => Navigator.pushNamed(context, '/cadastro_plantas')),
              _drawerItem(Icons.shopping_cart, "Equipamentos", () => Navigator.pop(context), active: true),
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