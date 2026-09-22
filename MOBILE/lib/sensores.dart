import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'accessibility_provider.dart';
import 'package:tcc/botao_acessibilidade.dart';

// ==========================================================
// PALETA DO MODO ESCURO
// ==========================================================

class DarkPalette {
  static const Color background = Color(0xFF0A1A2B);
  static const Color surface = Color(0xFF10263D);
  static const Color surfaceElevated = Color(0xFF16324B);
  static const Color surfaceBorder = Color(0xFF1E3B57);
  static const Color textPrimary = Color(0xFFF2F6FA);
  static const Color textSecondary = Color(0xFFA9C0D6);
}

class RelatoriodispositivosPage extends StatefulWidget {
  const RelatoriodispositivosPage({super.key});

  @override
  State<RelatoriodispositivosPage> createState() =>
      _RelatoriodispositivosPageState();
}

class _RelatoriodispositivosPageState extends State<RelatoriodispositivosPage> {
  final ScrollController horizontalController = ScrollController();

  // Lista que armazenará os dispositivos retornados pela API
  List<dynamic> dispositivos = [];

  // Indica se os dados estão carregando
  bool carregando = true;

  // Armazena possível mensagem de erro
  String? erro;

  // URL base da API
  final String apiUrl =
      'http://DESKTOP-38ILVP3/HydroFlow/public/api/dispositivos';

  static const azul = Color(0xFF002855);

  @override
  void initState() {
    super.initState();
    consultarDispositivos();
  }

  Future<void> consultarDispositivos() async {
    try {
      final resposta = await http.get(
        Uri.parse(apiUrl),
        headers: {'Accept': 'application/json'},
      );

      final resultado = jsonDecode(resposta.body);

      if (resposta.statusCode == 200) {
        if (!mounted) return;

        setState(() {
          if (resultado is List) {
            dispositivos = resultado;
          } else if (resultado is Map) {
            dispositivos = resultado['data'] ?? [];
          }

          carregando = false;
          erro = null;
        });
      } else {
        if (!mounted) return;

        // Trata a mensagem de erro antes do setState para evitar ternários confusos
        String mensagemErro = 'Erro ao consultar dispositivos';
        if (resultado is Map) {
          mensagemErro =
              resultado['message'] ??
              resultado['messages']?['error'] ??
              'Erro ao consultar dispositivos';
        }

        setState(() {
          erro = mensagemErro;
          carregando = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        erro = 'Erro ao acessar API: $e';
        carregando = false;
      });
    }
  }

  Future<void> excluirDispositivo(dynamic dispositivoId) async {
    try {
      final resposta = await http.delete(
        Uri.parse('$apiUrl/$dispositivoId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      dynamic resultado;

      try {
        resultado = jsonDecode(resposta.body);
      } catch (_) {
        resultado = {};
      }

      if (resposta.statusCode == 200 ||
          resposta.statusCode == 201 ||
          resposta.statusCode == 204) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              resultado is Map
                  ? resultado['mensagem'] ?? 'Dispositivo excluído com sucesso!'
                  : 'Dispositivo excluído com sucesso!',
            ),
          ),
        );

        await consultarDispositivos();
      } else {
        if (!mounted) return;

        // Extrai a mensagem para uma variável antes de montar o SnackBar
        String mensagemDetalhe = 'Erro desconhecido';
        if (resultado is Map) {
          mensagemDetalhe =
              resultado['mensagem'] ??
              resultado['message'] ??
              resultado['messages']?['error'] ??
              'Erro desconhecido';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir dispositivo: $mensagemDetalhe'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao acessar API: $e')));
    }
  }

  // A API monta o nome do dono via join (getDispositivoComDono).
  // Como o alias pode variar, tentamos as chaves mais prováveis.
  String nomeDono(dynamic dispositivo) {
    if (dispositivo is! Map) return '';

    return (dispositivo['nome_dono'] ??
            dispositivo['dono_nome'] ??
            dispositivo['USU_NOME'] ??
            dispositivo['FK_USU_ID'] ??
            '')
        .toString();
  }

  // ---------------- LOGOUT ----------------
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  @override
  void dispose() {
    horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Escutando as configurações do Provider de acessibilidade
    final acc = Provider.of<AccessibilityProvider>(context);
    final high = acc.isHighContrast;
    final f = acc.fontSizeFactor;

    final appBarBg = high ? DarkPalette.surface : azul;
    final appBarBorder = high
        ? const BorderSide(color: DarkPalette.surfaceBorder, width: 2)
        : BorderSide.none;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de Dispositivos'),
        backgroundColor: appBarBg,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: Border(bottom: appBarBorder),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                carregando = true;
                erro = null;
              });

              consultarDispositivos();
            },
            icon: const Icon(Icons.refresh),
          ),
          const BotaoAcessibilidade(),
        ],
      ),

      drawer: _buildDrawer(context, high, f),

      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : erro != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(erro!, textAlign: TextAlign.center),
              ),
            )
          : dispositivos.isEmpty
          ? const Center(child: Text('Nenhum dispositivo encontrado.'))
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Scrollbar(
                controller: horizontalController,
                thumbVisibility: true,
                trackVisibility: true,
                scrollbarOrientation: ScrollbarOrientation.bottom,
                child: SingleChildScrollView(
                  controller: horizontalController,
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      const Color(0xFFE7F0F2),
                    ),

                    border: TableBorder.all(
                      color: const Color(0xFFE0E5E7),
                      borderRadius: BorderRadius.circular(8),
                    ),

                    columns: const [
                      DataColumn(
                        label: Text(
                          'ID',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      DataColumn(
                        label: Text(
                          'NOME',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      DataColumn(
                        label: Text(
                          'DESCRIÇÃO',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      DataColumn(
                        label: Text(
                          'STATUS',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      DataColumn(
                        label: Text(
                          'NÍVEL DO TANQUE',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      DataColumn(
                        label: Text(
                          'DONO',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      DataColumn(
                        label: Text(
                          'Ações',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],

                    rows: dispositivos.map<DataRow>((dispositivo) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(dispositivo['DIS_ID']?.toString() ?? ''),
                          ),

                          DataCell(
                            Text(dispositivo['DIS_NOME']?.toString() ?? ''),
                          ),

                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 260),
                              child: Text(
                                dispositivo['DIS_DESCRICAO']?.toString() ?? '',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),

                          DataCell(
                            Text(dispositivo['DIS_STATUS']?.toString() ?? ''),
                          ),

                          DataCell(
                            Text(
                              dispositivo['DIS_NIVEL_TANQUE'] != null
                                  ? '${dispositivo['DIS_NIVEL_TANQUE']}%'
                                  : '',
                            ),
                          ),

                          DataCell(Text(nomeDono(dispositivo))),

                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Color.fromARGB(255, 3, 83, 148),
                                  ),
                                  onPressed: () {
                                    final id = dispositivo['DIS_ID'];

                                    // Aqui você pode adicionar
                                    // a navegação para edição
                                    print('Editar dispositivo ID: $id');
                                  },
                                ),

                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final id = dispositivo['DIS_ID'];

                                    final confirmar = await showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Excluir Dispositivo?',
                                          ),

                                          content: Text(
                                            'Deseja excluir o dispositivo '
                                            '${dispositivo['DIS_NOME']}?',
                                          ),

                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, false);
                                              },
                                              child: const Text('Cancelar'),
                                            ),

                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                              },
                                              child: const Text('Excluir'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirmar == true) {
                                      await excluirDispositivo(id);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
    );
  }

  // ---------------- DRAWER ----------------
  Widget _buildDrawer(BuildContext context, bool high, double f) {
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

            _drawerItem(context, Icons.home, "Painel", f, () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            }),
            _drawerItem(context, Icons.park, "Plantas", f, () {
              Navigator.pushReplacementNamed(context, '/plantas');
            }),
            _drawerItem(context, Icons.history, "Histórico de Ativações", f, () {
              Navigator.pushReplacementNamed(context, '/historico');
            }),
            _drawerItem(context, Icons.history, "Histórico de Mediçoes", f, () {
              Navigator.pushReplacementNamed(context, '/dados_sensores');
            }),
            _drawerItem(context, Icons.memory, "Equipamentos", f, () {
              Navigator.pushReplacementNamed(context, '/equipamentos');
            }),

            const Spacer(),
            Divider(color: high ? DarkPalette.surfaceBorder : Colors.white24),

            _drawerItem(context, Icons.logout, "Sair", f, () {
              _logout(context);
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    double f,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 14 * f)),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  // Correção do nome interno do método auxiliar chamado pelo drawer
  Widget _drawerItem(BuildContext context, IconData icon, String title, double f, VoidCallback onTap) {
    return _buildDrawerItem(context, icon, title, f, onTap);
  }
}