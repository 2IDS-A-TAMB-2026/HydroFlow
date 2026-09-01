import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
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

class RelatoriosensoresPage extends StatefulWidget {
  const RelatoriosensoresPage({super.key});

  @override
  State<RelatoriosensoresPage> createState() =>
      _RelatoriosensoresPageState();
}

class _RelatoriosensoresPageState extends State<RelatoriosensoresPage> {
  final ScrollController horizontalController = ScrollController();

  // Lista que armazenará os sensores retornados pela API
  List<dynamic> sensores = [];

  // Indica se os dados estão carregando
  bool carregando = true;

  // Armazena possível mensagem de erro
  String? erro;

  // URL base da API
  final String apiUrl =
      'http://10.141.130.50/HydroFlow/public/api/sensores';

  @override
  void initState() {
    super.initState();
    consultarSensores();
  }

  Future<void> consultarSensores() async {
    try {
      final resposta = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
        },
      );

      final resultado = jsonDecode(resposta.body);

      if (resposta.statusCode == 200) {
        setState(() {
          // Caso a API retorne uma lista diretamente
          if (resultado is List) {
            sensores = resultado;
          }
          // Caso futuramente a API utilize {"data": [...]}
          else if (resultado is Map) {
            sensores = resultado['data'] ?? [];
          }

          carregando = false;
          erro = null;
        });
      } else {
        setState(() {
          erro = resultado is Map
              ? resultado['message'] ?? 'Erro ao consultar sensores'
              : 'Erro ao consultar sensores';

          carregando = false;
        });
      }
    } catch (e) {
      setState(() {
        erro = 'Erro ao acessar API: $e';
        carregando = false;
      });
    }
  }

  Future<void> excluirSensor(dynamic sensorId) async {
    try {
      final resposta = await http.delete(
        Uri.parse('$apiUrl/$sensorId'),
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
          const SnackBar(
            content: Text('Sensor excluído com sucesso!'),
          ),
        );

        await consultarSensores();
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao excluir sensor: '
              '${resultado is Map ? resultado['message'] ?? 'Erro desconhecido' : 'Erro desconhecido'}',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao acessar API: $e'),
        ),
      );
    }
  }

  @override
  void dispose() {
    horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de Sensores'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                carregando = true;
                erro = null;
              });

              consultarSensores();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: carregando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : erro != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      erro!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : sensores.isEmpty
                  ? const Center(
                      child: Text('Nenhum sensor encontrado.'),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(24),
                      child: Scrollbar(
                        controller: horizontalController,
                        thumbVisibility: true,
                        trackVisibility: true,
                        scrollbarOrientation:
                            ScrollbarOrientation.bottom,
                        child: SingleChildScrollView(
                          controller: horizontalController,
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor:
                                WidgetStateProperty.all(
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              DataColumn(
                                label: Text(
                                  'NOME',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              DataColumn(
                                label: Text(
                                  'STATUS',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              DataColumn(
                                label: Text(
                                  'TIPO',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              DataColumn(
                                label: Text(
                                  'ID DISPOSITIVO',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              DataColumn(
                                label: Text(
                                  'Ações',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],

                            rows: sensores.map<DataRow>((sensor) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      sensor['SEN_ID']?.toString() ?? '',
                                    ),
                                  ),

                                  DataCell(
                                    Text(
                                      sensor['SEN_NOME']?.toString() ?? '',
                                    ),
                                  ),

                                  DataCell(
                                    Text(
                                      sensor['SEN_STATUS']
                                              ?.toString() ??
                                          '',
                                    ),
                                  ),

                                  DataCell(
                                    Text(
                                      sensor['SEN_TIPO']?.toString() ?? '',
                                    ),
                                  ),

                                  DataCell(
                                    Text(
                                      sensor['FK_DIS_ID']
                                              ?.toString() ??
                                          '',
                                    ),
                                  ),

                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Color.fromARGB(
                                              255,
                                              3,
                                              83,
                                              148,
                                            ),
                                          ),
                                          onPressed: () {
                                            final id =
                                                sensor['SEN_ID'];

                                            // Aqui você pode adicionar
                                            // a navegação para edição
                                            print(
                                              'Editar sensor ID: $id',
                                            );
                                          },
                                        ),

                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () async {
                                            final id =
                                                sensor['SEN_ID'];

                                            final confirmar =
                                                await showDialog<bool>(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Excluir Sensor?',
                                                  ),

                                                  content: Text(
                                                    'Deseja excluir o sensor '
                                                    '${sensor['SEN_NOME']}?',
                                                  ),

                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                          context,
                                                          false,
                                                        );
                                                      },
                                                      child: const Text(
                                                        'Cancelar',
                                                      ),
                                                    ),

                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                          context,
                                                          true,
                                                        );
                                                      },
                                                      child: const Text(
                                                        'Excluir',
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            if (confirmar == true) {
                                              await excluirSensor(id);
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
}