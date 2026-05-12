import 'package:flutter/material.dart';

class EquipamentosPage extends StatefulWidget {
  const EquipamentosPage({super.key});

  @override
  State<EquipamentosPage> createState() => _EquipamentosPageState();
}

class _EquipamentosPageState extends State<EquipamentosPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
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

  // Sensores vinculados
  bool _sensorSolo = false;
  bool _sensorTemperatura = false;
  bool _sensorUmidadeAr = false;
  bool _sensorChuva = false;

  @override
  void dispose() {
    _nomeDispController.dispose();
    _capacidadeController.dispose();
    _descricaoController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _ruaController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _numeroController.dispose();
    _cepController.dispose();

    super.dispose();
  }

  // Salvar dispositivo
  void _salvarDispositivo() {
    if (_formKey.currentState!.validate()) {
      if (!_sensorSolo &&
          !_sensorTemperatura &&
          !_sensorUmidadeAr &&
          !_sensorChuva) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Selecione pelo menos um sensor"),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Dispositivo salvo com sucesso!"),
        ),
      );

      _nomeDispController.clear();
      _capacidadeController.clear();
      _descricaoController.clear();
      _latitudeController.clear();
      _longitudeController.clear();
      _ruaController.clear();
      _bairroController.clear();
      _cidadeController.clear();
      _numeroController.clear();
      _cepController.clear();

      setState(() {
        _sensorSolo = false;
        _sensorTemperatura = false;
        _sensorUmidadeAr = false;
        _sensorChuva = false;
      });
    }
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

          child: Card(
            elevation: 4,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            child: Padding(
              padding: const EdgeInsets.all(20.0),

              child: Form(
                key: _formKey,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Row(
                      children: [
                        Icon(Icons.memory, color: Colors.orange),
                        SizedBox(width: 10),
                        Text(
                          "Cadastro de Dispositivos",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 30),

                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _textField(
                            "Nome do Dispositivo",
                            "Ex: Controlador Central",
                            controller: _nomeDispController,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: _textField(
                            "Capacidade",
                            "Ex: 10L",
                            controller: _capacidadeController,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    _textField(
                      "Descrição",
                      "Função do dispositivo...",
                      controller: _descricaoController,
                      maxLines: 2,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Sensores Vinculados",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF002855),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Card(
                      elevation: 1,

                      child: Column(
                        children: [
                          CheckboxListTile(
                            value: _sensorSolo,
                            onChanged: (value) {
                              setState(() {
                                _sensorSolo = value!;
                              });
                            },
                            title:
                                const Text("Sensor de Umidade do Solo"),
                          ),

                          CheckboxListTile(
                            value: _sensorTemperatura,
                            onChanged: (value) {
                              setState(() {
                                _sensorTemperatura = value!;
                              });
                            },
                            title:
                                const Text("Sensor de Temperatura"),
                          ),

                          CheckboxListTile(
                            value: _sensorUmidadeAr,
                            onChanged: (value) {
                              setState(() {
                                _sensorUmidadeAr = value!;
                              });
                            },
                            title:
                                const Text("Sensor de Umidade do Ar"),
                          ),

                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      children: [
                        Expanded(
                          child: _textField(
                            "Latitude",
                            "-23.XXXX",
                            controller: _latitudeController,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: _textField(
                            "Longitude",
                            "-46.XXXX",
                            controller: _longitudeController,
                          ),
                        ),
                      ],
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),

                      child: Text(
                        "Endereço de Instalação",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    _textField(
                      "Rua",
                      "Rua José Calipto...",
                      controller: _ruaController,
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: _textField(
                            "Bairro",
                            "Jardim...",
                            controller: _bairroController,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: _textField(
                            "Cidade",
                            "Tambaú",
                            controller: _cidadeController,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: _textField(
                            "Número",
                            "123",
                            controller: _numeroController,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: _textField(
                            "CEP",
                            "13712-46",
                            controller: _cepController,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton.icon(
                        onPressed: _salvarDispositivo,

                        icon: const Icon(Icons.save),

                        label: const Text("Salvar Dispositivo"),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // INPUT PADRÃO
  Widget _textField(
    String label,
    String hint, {
    int maxLines = 1,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,

      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Campo obrigatório";
        }
        return null;
      },

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }

  // DRAWER
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
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const Divider(
              color: Colors.white,
              thickness: 1.2,
              height: 1,
            ),

            const SizedBox(height: 10),

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
              () => Navigator.pushReplacementNamed(context, '/login'),
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
        size: 24,
      ),

      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),

      tileColor:
          active ? Colors.white.withOpacity(0.15) : Colors.transparent,

      onTap: onTap,
    );
  }
}