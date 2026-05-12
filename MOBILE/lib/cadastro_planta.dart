import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CadastroPlantaPage extends StatefulWidget {
  const CadastroPlantaPage({super.key});

  @override
  State<CadastroPlantaPage> createState() =>
      _CadastroPlantaPageState();
}

class _CadastroPlantaPageState
    extends State<CadastroPlantaPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nomeController =
      TextEditingController();

  final TextEditingController
      _culturaController =
      TextEditingController();

  final TextEditingController
      _qtdAguaController =
      TextEditingController();

  final TextEditingController
      _periodoController =
      TextEditingController();

  String? _tipoSelecionado;
  String? _dispositivoSelecionado;

  String _unidadeAgua = 'Litros/dia';
  String _unidadeTempo = 'Horas';

  @override
  void dispose() {
    _nomeController.dispose();
    _culturaController.dispose();
    _qtdAguaController.dispose();
    _periodoController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.clear();

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      '/login',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Cadastro de Culturas"),

        backgroundColor: Colors.white,

        foregroundColor:
            const Color(0xFF002855),

        elevation: 0,
      ),

      drawer: _buildDrawer(context),

      body: Container(
        color: Colors.grey[100],

        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(16.0),

          child: Card(
            elevation: 4,

            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),

            child: Padding(
              padding:
                  const EdgeInsets.all(20.0),

              child: Form(
                key: _formKey,

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.eco,
                              color:
                                  Color(0xFF00a65a),
                            ),

                            SizedBox(width: 10),

                            Text(
                              "Nova Planta",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/plantas',
                            );
                          },

                          icon:
                              const Icon(Icons.list),

                          label: const Text(
                            "Ver Cadastradas",
                          ),

                          style:
                              OutlinedButton.styleFrom(
                            foregroundColor:
                                const Color(
                              0xFF002855,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 30),

                    const Text(
                      "Informações da Espécie",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w600,
                        color:
                            Colors.blueGrey,
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller:
                          _nomeController,

                      decoration:
                          const InputDecoration(
                        labelText:
                            "Nome da Planta",

                        border:
                            OutlineInputBorder(),

                        hintText:
                            "Ex: Tomate Carmem",
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child:
                              DropdownButtonFormField<
                                  String>(
                            decoration:
                                const InputDecoration(
                              labelText:
                                  "Tipo",

                              border:
                                  OutlineInputBorder(),
                            ),

                            items: [
                              "Hortaliça",
                              "Frutífera",
                              "Legume",
                              "Grão",
                              "Ornamental"
                            ]
                                .map(
                                  (t) =>
                                      DropdownMenuItem(
                                    value: t,
                                    child:
                                        Text(t),
                                  ),
                                )
                                .toList(),

                            onChanged: (val) {
                              setState(() {
                                _tipoSelecionado =
                                    val;
                              });
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: TextFormField(
                            controller:
                                _culturaController,

                            decoration:
                                const InputDecoration(
                              labelText:
                                  "Cultura",

                              border:
                                  OutlineInputBorder(),

                              hintText:
                                  "Ex: Solanáceas",
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Parâmetros de Irrigação",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w600,
                        color:
                            Colors.blueGrey,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          flex: 2,

                          child: TextFormField(
                            controller:
                                _qtdAguaController,

                            keyboardType:
                                TextInputType
                                    .number,

                            decoration:
                                const InputDecoration(
                              labelText:
                                  "Qtd. de Água",

                              border:
                                  OutlineInputBorder(),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          flex: 1,

                          child:
                              DropdownButtonFormField<
                                  String>(
                            initialValue:
                                _unidadeAgua,

                            decoration:
                                const InputDecoration(
                              border:
                                  OutlineInputBorder(),
                            ),

                            items: [
                              "Litros/dia",
                              "mm/dia",
                              "mL/dia"
                            ]
                                .map(
                                  (u) =>
                                      DropdownMenuItem(
                                    value: u,
                                    child:
                                        Text(u),
                                  ),
                                )
                                .toList(),

                            onChanged: (val) {
                              setState(() {
                                _unidadeAgua =
                                    val!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField<
                        String>(
                      decoration:
                          const InputDecoration(
                        labelText:
                            "Dispositivo Responsável",

                        border:
                            OutlineInputBorder(),
                      ),

                      items: [
                        "Irriga 1000",
                        "Hortas 03012",
                        "Irrigation PRO"
                      ]
                          .map(
                            (d) =>
                                DropdownMenuItem(
                              value: d,
                              child: Text(d),
                            ),
                          )
                          .toList(),

                      onChanged: (val) {
                        setState(() {
                          _dispositivoSelecionado =
                              val;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          flex: 2,

                          child: TextFormField(
                            controller:
                                _periodoController,

                            keyboardType:
                                TextInputType
                                    .number,

                            decoration:
                                const InputDecoration(
                              labelText:
                                  "Periodicidade",

                              border:
                                  OutlineInputBorder(),

                              hintText:
                                  "Ex: 12",
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          flex: 1,

                          child:
                              DropdownButtonFormField<
                                  String>(
                            initialValue:
                                _unidadeTempo,

                            decoration:
                                const InputDecoration(
                              border:
                                  OutlineInputBorder(),
                            ),

                            items: [
                              "Horas",
                              "Dias",
                              "Semanas"
                            ]
                                .map(
                                  (u) =>
                                      DropdownMenuItem(
                                    value: u,
                                    child:
                                        Text(u),
                                  ),
                                )
                                .toList(),

                            onChanged: (val) {
                              setState(() {
                                _unidadeTempo =
                                    val!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 50),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.end,

                      children: [
                        TextButton(
                          onPressed: () {
                            _formKey.currentState
                                ?.reset();
                          },

                          child:
                              const Text("Limpar"),
                        ),

                        const SizedBox(width: 15),

                        ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey
                                .currentState!
                                .validate()) {
                              ScaffoldMessenger.of(
                                      context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Planta Salva com Sucesso!",
                                  ),
                                ),
                              );
                            }
                          },

                          icon:
                              const Icon(Icons.grass),

                          label: const Text(
                            "Salvar Planta",
                          ),

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(
                              0xFF002855,
                            ),

                            foregroundColor:
                                Colors.white,

                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ],
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

  // DRAWER
  Widget _buildDrawer(
      BuildContext context) {
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
                  fontWeight:
                      FontWeight.bold,
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

            const Divider(
              color: Colors.white24,
            ),

            _drawerItem(
              Icons.logout,
              "Sair",
              _logout,
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
          fontWeight:
              FontWeight.w400,
        ),
      ),

      tileColor: active
          ? Colors.white.withOpacity(0.15)
          : Colors.transparent,

      onTap: onTap,
    );
  }
}