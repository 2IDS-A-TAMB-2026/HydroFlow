import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcc/botao_acessibilidade.dart';
import 'accessibility_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

// Dependências do Pacote PDF e Impressão
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// ─────────────────────────────────────────────
///  PALETA DO MODO ESCURO
/// ─────────────────────────────────────────────
class DarkPalette {
  static const Color background = Color(0xFF0A1A2B);
  static const Color surface = Color(0xFF10263D);
  static const Color surfaceElevated = Color(0xFF16324B);
  static const Color surfaceBorder = Color(0xFF1E3B57);
  static const Color textPrimary = Color(0xFFF2F6FA);
  static const Color textSecondary = Color(0xFFA9C0D6);
}

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _dados = [];
  bool _carregando = true;
  String _erro = '';

  String _query = "";
  static const azul = Color(0xFF002855);

  final String apiUrl = 'http://10.0.2.2/HydroFlow/public/api/historico';

  @override
  void initState() {
    super.initState();
    consultarHistorico();
  }

  // ---------------- REQUISIÇÃO DA API ----------------
  Future<void> consultarHistorico() async {
    setState(() {
      _carregando = true;
      _erro = '';
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final resultado = jsonDecode(response.body);

        setState(() {
          _dados = resultado is List ? resultado : (resultado['data'] ?? []);
          _carregando = false;
        });
      } else {
        setState(() {
          _erro = 'Erro do servidor (${response.statusCode}). Verifique a rota do backend.';
          _carregando = false;
        });
      }
    } catch (e) {
      setState(() {
        _erro = 'Falha ao conectar com o servidor:\n$e';
        _carregando = false;
      });
    }
  }

  // ---------------- GERAÇÃO DE PDF ----------------
  Future<void> _gerarPdf(List<dynamic> dadosExportar) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Cabeçalho do Relatório
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "HYDROFLOW - SISTEMA DE IRRIGAÇÃO",
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue900,
                      ),
                    ),
                    pw.Text(
                      "Relatório de Histórico de Ativações",
                      style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
                    ),
                  ],
                ),
                pw.Text(
                  "Data: ${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}",
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Divider(color: PdfColors.grey400),
            pw.SizedBox(height: 15),

            // Tabela de Dados em PDF
            pw.TableHelper.fromTextArray(
              headers: ['Status', 'Data / Hora', 'Setor / Cultura', 'Duração', 'Volume', 'Acionamento'],
              data: dadosExportar.map((item) {
                final status = item['IRR_STATUS'] ?? item['status'] ?? 'Concluído';
                final dataHora = "${item['IRR_DATA'] ?? item['data'] ?? ''} ${item['IRR_HORA'] ?? item['hora'] ?? ''}".trim();
                final setor = item['nome_planta'] != null
                    ? "${item['nome_planta']} (${item['cultura'] ?? 'Geral'})"
                    : (item['setor'] ?? 'Planta #${item['planta_id'] ?? item['id']}');
                final duracao = "${item['IRR_DURACAO'] ?? item['duracao'] ?? '0'} min";
                final volume = "${item['IRR_VOLUME'] ?? item['volume'] ?? '0'} L";
                final tipo = item['IRR_ACIONAMENTO'] ?? item['tipo'] ?? 'Manual';

                return [
                  status.toString(),
                  dataHora.isEmpty ? '-' : dataHora,
                  setor.toString(),
                  duracao,
                  volume,
                  tipo.toString(),
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.blue900,
              ),
              rowDecoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: PdfColors.grey300, width: .5),
                ),
              ),
              cellAlignment: pw.Alignment.centerLeft,
              cellPadding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              cellStyle: const pw.TextStyle(fontSize: 10),
            ),

            pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Total de registros exportados: ${dadosExportar.length}",
                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700),
              ),
            ),
          ];
        },
      ),
    );

    // Abre a pré-visualização/download do PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'historico_irrigacao_hydroflow.pdf',
    );
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final acc = Provider.of<AccessibilityProvider>(context);
    final high = acc.isHighContrast;
    final f = acc.fontSizeFactor;

    final bgPage = high ? DarkPalette.background : Colors.grey[100];
    final appBarBg = high ? DarkPalette.surface : azul;
    final appBarBorder = high
        ? const BorderSide(color: DarkPalette.surfaceBorder, width: 2)
        : BorderSide.none;

    final filtrados = _dados.where((item) {
      final setor = (item['nome_planta'] ?? item['cultura'] ?? item['setor'] ?? '').toString().toLowerCase();
      final status = (item['IRR_STATUS'] ?? item['status'] ?? '').toString().toLowerCase();
      final data = "${item['IRR_DATA'] ?? item['data'] ?? ''} ${item['IRR_HORA'] ?? item['hora'] ?? ''}".toLowerCase();

      return setor.contains(_query) || status.contains(_query) || data.contains(_query);
    }).toList();

    return Scaffold(
      backgroundColor: bgPage,
      appBar: AppBar(
        title: Text(
          "Histórico de Ativações",
          style: TextStyle(fontSize: 20 * f),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: appBarBg,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: Border(bottom: appBarBorder),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: "Exportar PDF",
            onPressed: filtrados.isEmpty ? null : () => _gerarPdf(filtrados),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: consultarHistorico,
          ),
          const BotaoAcessibilidade(),
        ],
      ),
      drawer: _buildDrawer(context, high, f),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFilterWidget(high, f),
            const SizedBox(height: 20),
            _buildChartCard(high, f),
            const SizedBox(height: 20),
            _buildHistoryTable(high, f, filtrados),
          ],
        ),
      ),
    );
  }

  // ---------------- FILTROS ----------------
  Widget _buildFilterWidget(bool high, double f) {
    return Card(
      elevation: high ? 0 : 3,
      color: high ? DarkPalette.surface : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: high ? const BorderSide(color: DarkPalette.surfaceBorder, width: 1.5) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.filter_list, color: high ? Colors.cyanAccent : azul),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "Filtros de Busca",
                    style: TextStyle(
                      fontSize: 16 * f,
                      fontWeight: FontWeight.bold,
                      color: high ? DarkPalette.textPrimary : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _query = value.toLowerCase();
                });
              },
              style: TextStyle(color: high ? DarkPalette.textPrimary : Colors.black, fontSize: 14 * f),
              decoration: InputDecoration(
                hintText: "Buscar por setor, data ou status...",
                hintStyle: TextStyle(color: high ? DarkPalette.textSecondary : Colors.black38, fontSize: 14 * f),
                prefixIcon: Icon(Icons.search, color: high ? Colors.cyanAccent : Colors.black45),
                filled: true,
                fillColor: high ? DarkPalette.surfaceElevated : const Color(0xFFF5F7FA),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: high ? DarkPalette.surfaceBorder : Colors.grey.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: high ? Colors.cyanAccent : azul, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- CARD DO GRÁFICO ----------------
  Widget _buildChartCard(bool high, double f) {
    final Map<String, double> consumoPorData = {};

    for (var item in _dados) {
      final dataStr = (item['IRR_DATA'] ?? item['data'] ?? '').toString();
      final volNum = double.tryParse((item['IRR_VOLUME'] ?? item['volume'] ?? '0').toString()) ?? 0.0;

      if (dataStr.isNotEmpty) {
        String dataFormatada = dataStr;
        if (dataStr.contains('-') && dataStr.split('-').length == 3) {
          final partes = dataStr.split('-');
          dataFormatada = "${partes[2]}/${partes[1]}";
        }

        consumoPorData[dataFormatada] = (consumoPorData[dataFormatada] ?? 0) + volNum;
      }
    }

    final List<String> datas = consumoPorData.isNotEmpty
        ? consumoPorData.keys.toList()
        : ["01/05", "02/05", "03/05", "04/05", "05/05", "06/05", "07/05", "08/05", "09/05", "10/05", "11/05", "12/05", "13/05"];

    final List<double> valores = consumoPorData.isNotEmpty
        ? consumoPorData.values.toList()
        : [450, 680, 150, 460, 750, 440, 1100, 420, 450, 450, 180, 450, 670];

    final spots = List.generate(
      valores.length,
      (i) => FlSpot(i.toDouble(), valores[i]),
    );

    return Card(
      elevation: high ? 0 : 3,
      color: high ? DarkPalette.surface : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: high ? const BorderSide(color: DarkPalette.surfaceBorder, width: 1.5) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.show_chart, color: high ? Colors.cyanAccent : azul),
                const SizedBox(width: 8),
                Text(
                  "Consumo de Água no Período (Litros)",
                  style: TextStyle(
                    fontSize: 16 * f,
                    fontWeight: FontWeight.bold,
                    color: high ? DarkPalette.textPrimary : azul,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: high ? DarkPalette.surfaceBorder : Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: high ? DarkPalette.surfaceBorder : Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 45,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            "${value.toInt()} L",
                            style: TextStyle(
                              color: high ? DarkPalette.textSecondary : Colors.grey[600],
                              fontSize: 10 * f,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int idx = value.toInt();
                          if (idx >= 0 && idx < datas.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                datas[idx],
                                style: TextStyle(
                                  color: high ? DarkPalette.textSecondary : Colors.grey[600],
                                  fontSize: 10 * f,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: high ? DarkPalette.surfaceBorder : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.35,
                      color: high ? Colors.cyanAccent : azul,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 3.5,
                            color: Colors.green,
                            strokeWidth: 1.5,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: high
                            ? Colors.cyanAccent.withOpacity(0.12)
                            : azul.withOpacity(0.08),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- TABELA DE HISTÓRICO COM BOTÃO EXPORTAR PDF ----------------
  Widget _buildHistoryTable(bool high, double f, List<dynamic> filtrados) {
    if (_carregando) {
      return Card(
        elevation: high ? 0 : 3,
        color: high ? DarkPalette.surface : Colors.white,
        child: const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_erro.isNotEmpty) {
      return Card(
        elevation: high ? 0 : 3,
        color: high ? DarkPalette.surface : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                _erro,
                textAlign: TextAlign.center,
                style: TextStyle(color: high ? DarkPalette.textPrimary : Colors.red, fontSize: 14 * f),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: consultarHistorico,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: high ? 0 : 3,
      color: high ? DarkPalette.surface : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: high ? const BorderSide(color: DarkPalette.surfaceBorder, width: 1.5) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.assignment, color: high ? Colors.cyanAccent : azul),
                    const SizedBox(width: 8),
                    Text(
                      "Registros de Irrigação",
                      style: TextStyle(
                        fontSize: 18 * f,
                        fontWeight: FontWeight.bold,
                        color: high ? DarkPalette.textPrimary : Colors.black87,
                      ),
                    ),
                  ],
                ),
                // BOTÃO DE EXPORTAR PDF NO TOPO DA TABELA
                ElevatedButton.icon(
                  onPressed: filtrados.isEmpty ? null : () => _gerarPdf(filtrados),
                  icon: const Icon(Icons.picture_as_pdf, size: 18),
                  label: Text("Exportar PDF", style: TextStyle(fontSize: 12 * f)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: high ? DarkPalette.surfaceBorder : Colors.grey[300]),
            const SizedBox(height: 8),

            // QUADRO DA TABELA COM SCROLL INTERNO
            filtrados.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text("Nenhum registro encontrado.")),
                  )
                : Container(
                    height: 320,
                    decoration: BoxDecoration(
                      color: high ? DarkPalette.surfaceElevated : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: high ? DarkPalette.surfaceBorder : Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(
                              high ? DarkPalette.surface : const Color(0xFFEEF2F6),
                            ),
                            headingTextStyle: TextStyle(
                              color: high ? Colors.cyanAccent : azul,
                              fontWeight: FontWeight.bold,
                              fontSize: 14 * f,
                            ),
                            dataTextStyle: TextStyle(
                              color: high ? DarkPalette.textSecondary : Colors.black87,
                              fontSize: 13 * f,
                            ),
                            columns: const [
                              DataColumn(label: Text("Status")),
                              DataColumn(label: Text("Data e Hora")),
                              DataColumn(label: Text("Setor / Cultura")),
                              DataColumn(label: Text("Duração")),
                              DataColumn(label: Text("Volume")),
                              DataColumn(label: Text("Acionamento")),
                            ],
                            rows: filtrados.map((item) {
                              final dataHora = "${item['IRR_DATA'] ?? item['data'] ?? ''} ${item['IRR_HORA'] ?? item['hora'] ?? ''}".trim();
                              final setor = item['nome_planta'] != null
                                  ? "${item['nome_planta']} (${item['cultura'] ?? 'Geral'})"
                                  : (item['setor'] ?? 'Planta #${item['planta_id'] ?? item['id']}');
                              final duracao = "${item['IRR_DURACAO'] ?? item['duracao'] ?? '0'} min";
                              final volume = "${item['IRR_VOLUME'] ?? item['volume'] ?? '0'}L";
                              final tipo = item['IRR_ACIONAMENTO'] ?? item['tipo'] ?? 'Manual';
                              final isAuto = tipo.toString().toLowerCase() == 'automático';
                              final icon = isAuto ? Icons.smart_toy : Icons.touch_app;
                              final status = item['IRR_STATUS'] ?? item['status'] ?? 'Concluído';

                              Color statusColor = Colors.green;
                              if (status.toString().toLowerCase() == 'falha') {
                                statusColor = Colors.red;
                              } else if (status.toString().toLowerCase() == 'interrompido') {
                                statusColor = Colors.orange;
                              }

                              return _historyRow(
                                status.toString(),
                                statusColor,
                                dataHora.isEmpty ? '-' : dataHora,
                                setor,
                                duracao,
                                volume,
                                icon,
                                tipo.toString(),
                                high,
                                f,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // ---------------- LINHA DA TABELA ----------------
  DataRow _historyRow(
    String status,
    Color statusColor,
    String data,
    String setor,
    String duracao,
    String vol,
    IconData icon,
    String tipo,
    bool high,
    double f,
  ) {
    final Color highStatusColor = statusColor == Colors.green ? Colors.greenAccent : Colors.redAccent;

    return DataRow(
      cells: [
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: high ? highStatusColor.withOpacity(0.18) : statusColor,
              borderRadius: BorderRadius.circular(20),
              border: high ? Border.all(color: highStatusColor, width: 1.5) : null,
            ),
            child: Text(
              status,
              style: TextStyle(
                color: high ? highStatusColor : Colors.white,
                fontSize: 11 * f,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(Text(
          data,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: high ? DarkPalette.textPrimary : Colors.black,
          ),
        )),
        DataCell(Text(setor)),
        DataCell(Text(duracao)),
        DataCell(Text(vol)),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: high ? DarkPalette.textSecondary : Colors.black54),
            const SizedBox(width: 5),
            Text(tipo),
          ],
        )),
      ],
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
            _drawerItem(context, Icons.history, "Histórico de Ativação", f, () {
              Navigator.pushReplacementNamed(context, '/historico');
            }),
            _drawerItem(context, Icons.show_chart, "Histórico de Medição", f, () {
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

  Widget _drawerItem(BuildContext context, IconData icon, String title, double f, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 14 * f)),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}