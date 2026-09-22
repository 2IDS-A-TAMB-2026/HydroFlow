import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart' as excel_lib;
import 'package:path_provider/path_provider.dart';

import 'package:tcc/botao_acessibilidade.dart';
import 'accessibility_provider.dart';

class DarkPalette {
  static const Color background = Color(0xFF0A1A2B);
  static const Color surface = Color(0xFF10263D);
  static const Color surfaceElevated = Color(0xFF16324B);
  static const Color surfaceBorder = Color(0xFF1E3B57);
  static const Color textPrimary = Color(0xFFF2F6FA);
  static const Color textSecondary = Color(0xFFA9C0D6);
}

class Relatoriodados_sensoresPage extends StatefulWidget {
  const Relatoriodados_sensoresPage({super.key});

  @override
  State<Relatoriodados_sensoresPage> createState() => _Relatoriodados_sensoresPageState();
}

class _Relatoriodados_sensoresPageState extends State<Relatoriodados_sensoresPage> {
  final ScrollController horizontalController = ScrollController();
  static const azul = Color(0xFF002855);

  // Controladores do Formulário de Filtros
  final TextEditingController _dataInicialController = TextEditingController();
  final TextEditingController _dataFinalController = TextEditingController();
  final TextEditingController _tempMinController = TextEditingController();
  final TextEditingController _umidadeMaxController = TextEditingController();
  String _statusFiltro = 'todos';

  List<dynamic> dados_sensores = [];
  List<String> chartLabels = [];
  List<double> tempValues = [];
  List<double> umidValues = [];

  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    consultardados_sensores();
  }

  // Helper para formatar data do banco YYYY-MM-DD para DD/MM/YYYY
  String _formatarDataBr(String dataBanco) {
    if (dataBanco.isEmpty) return '';
    try {
      List<String> partes = dataBanco.split('-');
      if (partes.length == 3) {
        return '${partes[2]}/${partes[1]}/${partes[0]}';
      }
    } catch (_) {}
    return dataBanco;
  }

  // ===========================================================================
  // 1. REQUISIÇÃO API COM FILTROS
  // ===========================================================================
  Future<void> consultardados_sensores() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final uri = Uri.parse('http://desktop-38ilvp3/HydroFlow/public/api/dados_sensores').replace(
        queryParameters: {
          if (_dataInicialController.text.isNotEmpty) 'data_inicial': _dataInicialController.text,
          if (_dataFinalController.text.isNotEmpty) 'data_final': _dataFinalController.text,
          if (_tempMinController.text.isNotEmpty) 'temp_min': _tempMinController.text,
          if (_umidadeMaxController.text.isNotEmpty) 'umidade_max': _umidadeMaxController.text,
          if (_statusFiltro != 'todos') 'status_filtro': _statusFiltro,
        },
      );

      final resposta = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      );

      if (resposta.statusCode == 200) {
        final dynamic rawJson = jsonDecode(resposta.body);

        List<dynamic> listData = [];
        if (rawJson is List) {
          listData = rawJson;
        } else if (rawJson is Map && rawJson.containsKey('data')) {
          listData = rawJson['data'] ?? [];
        }

        List<String> labels = [];
        List<double> temps = [];
        List<double> umids = [];

        for (var element in listData) {
          final item = Map<String, dynamic>.from(element as Map);

          String dataStr = item['DDS_DATA']?.toString() ?? '';
          double tempVal = double.tryParse(item['DDS_TEMP']?.toString().replaceAll(',', '.') ?? '') ?? 0.0;
          double umidVal = double.tryParse(item['DDS_UMIDADE']?.toString().replaceAll(',', '.') ?? '') ?? 0.0;

          labels.add(dataStr);
          temps.add(tempVal);
          umids.add(umidVal);
        }

        setState(() {
          dados_sensores = listData;
          chartLabels = labels;
          tempValues = temps;
          umidValues = umids;
          carregando = false;
        });
      } else {
        setState(() {
          erro = 'Erro na requisição: ${resposta.statusCode}';
          carregando = false;
        });
      }
    } catch (e) {
      setState(() {
        erro = 'Erro de conexão: $e';
        carregando = false;
      });
    }
  }

  // ===========================================================================
  // 2. EXPORTAÇÃO EXCEL (.XLSX)
  // ===========================================================================
  Future<void> _exportarExcel() async {
    try {
      var excel = excel_lib.Excel.createExcel();
      excel_lib.Sheet sheetObject = excel['Dados do ESP32'];
      excel.delete('Sheet1');

      sheetObject.appendRow([
        excel_lib.TextCellValue('Data e Hora'),
        excel_lib.TextCellValue('Sensor / Área'),
        excel_lib.TextCellValue('Temperatura (°C)'),
        excel_lib.TextCellValue('Umidade Coletada (%)'),
        excel_lib.TextCellValue('Status / Saúde'),
      ]);

      for (var rawRow in dados_sensores) {
        final row = Map<String, dynamic>.from(rawRow as Map);
        final umidade = double.tryParse(row['DDS_UMIDADE']?.toString().replaceAll(',', '.') ?? '0') ?? 0.0;
        String status = umidade < 40.0 ? 'Ruim' : (umidade <= 70.0 ? 'Bom' : 'Ótimo');

        sheetObject.appendRow([
          excel_lib.TextCellValue('${_formatarDataBr(row['DDS_DATA']?.toString() ?? '')} - ${row['DDS_HORA'] ?? ''}'),
          excel_lib.TextCellValue(row['nome_sensor'] ?? 'Sensor #${row['FK_SEN_ID'] ?? ''}'),
          excel_lib.TextCellValue('${row['DDS_TEMP'] ?? '0'} °C'),
          excel_lib.TextCellValue('${row['DDS_UMIDADE'] ?? '0'} %'),
          excel_lib.TextCellValue(status),
        ]);
      }

      final directory = await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/registros_sensores.xlsx");
      await file.writeAsBytes(excel.save()!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Excel exportado em: ${file.path}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao exportar Excel: $e')),
        );
      }
    }
  }

  // ===========================================================================
  // 3. EXPORTAÇÃO PDF (PDF / PRINTING)
  // ===========================================================================
  Future<void> _exportarPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('SISTEMA DE IRRIGAÇÃO - REGISTROS DOS SENSORES (ESP32)',
                      style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Gerado em: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ['Data e Hora', 'Sensor / Área', 'Temperatura', 'Umidade Coletada', 'Status / Saúde'],
              data: dados_sensores.map((rawItem) {
                final item = Map<String, dynamic>.from(rawItem as Map);
                final umidade = double.tryParse(item['DDS_UMIDADE']?.toString().replaceAll(',', '.') ?? '0') ?? 0.0;
                String status = umidade < 40.0 ? 'Ruim' : (umidade <= 70.0 ? 'Bom' : 'Ótimo');
                return [
                  '${_formatarDataBr(item['DDS_DATA']?.toString() ?? '')} ${item['DDS_HORA'] ?? ''}',
                  item['nome_sensor'] ?? 'Sensor #${item['FK_SEN_ID'] ?? ''}',
                  '${item['DDS_TEMP'] ?? '0'} °C',
                  '${item['DDS_UMIDADE'] ?? '0'} %',
                  status
                ];
              }).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF1E3C72)),
              cellAlignment: pw.Alignment.centerLeft,
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'registros_sensores.pdf',
    );
  }

  @override
  void dispose() {
    horizontalController.dispose();
    _dataInicialController.dispose();
    _dataFinalController.dispose();
    _tempMinController.dispose();
    _umidadeMaxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final acc = Provider.of<AccessibilityProvider>(context);
    final high = acc.isHighContrast;
    final f = acc.fontSizeFactor;

    final bgPage = high ? DarkPalette.background : Colors.grey[100];
    final appBarBg = high ? DarkPalette.surface : azul;
    final bgContainer = high ? DarkPalette.surface : Colors.white;

    return Scaffold(
      backgroundColor: bgPage,
      appBar: AppBar(
        title: Text('Relatório de Sensores', style: TextStyle(fontSize: 20 * f)),
        backgroundColor: appBarBg,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: consultardados_sensores,
            icon: const Icon(Icons.refresh),
          ),
          const BotaoAcessibilidade(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // CARD 1: FILTROS DE BUSCA
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgContainer,
                borderRadius: BorderRadius.circular(12),
                border: high ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5) : null,
                boxShadow: high ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.filter_alt, color: high ? Colors.cyanAccent : Colors.grey[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Filtros de Busca',
                        style: TextStyle(
                          fontSize: 16 * f,
                          fontWeight: FontWeight.bold,
                          color: high ? DarkPalette.textPrimary : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildDateField('Data Inicial', _dataInicialController, context, high),
                      _buildDateField('Data Final', _dataFinalController, context, high),
                      _buildNumberField('Temp. Acima (°C)', _tempMinController, 'Ex: 25', high),
                      _buildNumberField('Umid. Abaixo (%)', _umidadeMaxController, 'Ex: 40', high),
                      _buildDropdownStatus(high),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: consultardados_sensores,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A65A),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      icon: const Icon(Icons.search, color: Colors.white),
                      label: Text(
                        'Filtrar',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14 * f),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // CARD 2: GRÁFICO DE LINHAS
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgContainer,
                borderRadius: BorderRadius.circular(12),
                border: high ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5) : null,
                boxShadow: high ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comportamento do Ambiente (Médias Diárias)',
                    style: TextStyle(
                      fontSize: 16 * f,
                      fontWeight: FontWeight.bold,
                      color: high ? DarkPalette.textPrimary : azul,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem('Temperatura (°C)', const Color(0xFFFF6B6B), high),
                      const SizedBox(width: 20),
                      _buildLegendItem('Umidade (%)', const Color(0xFF0284C7), high),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 260,
                    child: carregando
                        ? Center(child: CircularProgressIndicator(color: high ? Colors.cyanAccent : azul))
                        : tempValues.isEmpty
                            ? const Center(child: Text('Sem dados para exibir'))
                            : LineChart(_buildChartData(high)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // CARD 3: TABELA DE DADOS
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgContainer,
                borderRadius: BorderRadius.circular(12),
                border: high ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5) : null,
                boxShadow: high ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      Text(
                        'Registros dos Sensores (ESP32)',
                        style: TextStyle(
                          fontSize: 15 * f,
                          fontWeight: FontWeight.bold,
                          color: high ? DarkPalette.textPrimary : azul,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _exportarExcel,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1F7246),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            icon: const Icon(Icons.table_chart, size: 16, color: Colors.white),
                            label: const Text('Excel', style: TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: _exportarPdf,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDC3545),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            icon: const Icon(Icons.picture_as_pdf, size: 16, color: Colors.white),
                            label: const Text('PDF', style: TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 20),

                  Scrollbar(
                    controller: horizontalController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    scrollbarOrientation: ScrollbarOrientation.bottom,
                    child: SingleChildScrollView(
                      controller: horizontalController,
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(
                          high ? DarkPalette.surfaceElevated : const Color(0xFFE7F0F2),
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
                        border: TableBorder.all(
                          color: high ? DarkPalette.surfaceBorder : const Color(0xFFE0E5E7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        columns: const [
                          DataColumn(label: Text('DATA/HORA')),
                          DataColumn(label: Text('SENSOR')),
                          DataColumn(label: Text('TEMP')),
                          DataColumn(label: Text('UMIDADE')),
                          DataColumn(label: Text('STATUS')),
                        ],
                        rows: dados_sensores.isEmpty
                            ? [
                                const DataRow(cells: [
                                  DataCell(Text('Nenhum registro encontrado.')),
                                  DataCell(Text('')),
                                  DataCell(Text('')),
                                  DataCell(Text('')),
                                  DataCell(Text('')),
                                ])
                              ]
                            : dados_sensores.map<DataRow>((dynamic rowItem) {
                                final item = Map<String, dynamic>.from(rowItem as Map);

                                final data = item['DDS_DATA']?.toString() ?? '';
                                final hora = item['DDS_HORA']?.toString() ?? '';
                                final temp = item['DDS_TEMP']?.toString() ?? '0';
                                final umid = item['DDS_UMIDADE']?.toString() ?? '0';
                                final sensorId = item['FK_SEN_ID']?.toString() ?? '';

                                final umidadeDouble = double.tryParse(umid.replaceAll(',', '.')) ?? 0.0;

                                return DataRow(
                                  cells: [
                                    DataCell(Text('${_formatarDataBr(data)} $hora'.trim())),
                                    DataCell(Text(item['nome_sensor']?.toString() ?? 'Sensor #$sensorId')),
                                    DataCell(Text('$temp °C')),
                                    DataCell(Text('$umid %')),
                                    DataCell(_buildStatusBadge(umidadeDouble)),
                                  ],
                                );
                              }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // COMPONENTES AUXILIARES
  // ===========================================================================
  Widget _buildDateField(String label, TextEditingController controller, BuildContext context, bool isHigh) {
    return SizedBox(
      width: 150,
      child: TextField(
        controller: controller,
        readOnly: true,
        style: TextStyle(color: isHigh ? Colors.white : Colors.black),
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
        ),
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
          );
          if (picked != null) {
            controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
          }
        },
      ),
    );
  }

  Widget _buildNumberField(String label, TextEditingController controller, String placeholder, bool isHigh) {
    return SizedBox(
      width: 150,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: TextStyle(color: isHigh ? Colors.white : Colors.black),
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          isDense: true,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdownStatus(bool isHigh) {
    return SizedBox(
      width: 160,
      child: DropdownButtonFormField<String>(
        value: _statusFiltro,
        decoration: const InputDecoration(
          labelText: 'Classificação',
          isDense: true,
          border: OutlineInputBorder(),
        ),
        dropdownColor: isHigh ? DarkPalette.surface : Colors.white,
        style: TextStyle(color: isHigh ? Colors.white : Colors.black),
        items: const [
          DropdownMenuItem(value: 'todos', child: Text('Todos')),
          DropdownMenuItem(value: 'otimo', child: Text('Ótimo (>70%)')),
          DropdownMenuItem(value: 'bom', child: Text('Bom (40%-70%)')),
          DropdownMenuItem(value: 'ruim', child: Text('Ruim (<40%)')),
        ],
        onChanged: (val) {
          if (val != null) setState(() => _statusFiltro = val);
        },
      ),
    );
  }

  LineChartData _buildChartData(bool isHighContrast) {
    List<FlSpot> tempSpots = [];
    List<FlSpot> umidSpots = [];

    for (int i = 0; i < tempValues.length; i++) {
      tempSpots.add(FlSpot(i.toDouble(), tempValues[i]));
      umidSpots.add(FlSpot(i.toDouble(), umidValues[i]));
    }

    // Intervalo dinâmico para não sobrepor textos no eixo X
    double intervalX = (tempValues.length / 5).ceilToDouble();
    if (intervalX < 1) intervalX = 1;

    return LineChartData(
      minX: 0,
      maxX: (tempValues.length - 1).toDouble() > 0 ? (tempValues.length - 1).toDouble() : 1,
      minY: 0,
      maxY: 100,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 20,
        getDrawingHorizontalLine: (value) => FlLine(
          color: isHighContrast ? DarkPalette.surfaceBorder : const Color(0xFFE2E8F0),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: intervalX,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index >= 0 && index < chartLabels.length) {
                String label = chartLabels[index];
                if (label.contains('-')) {
                  List<String> p = label.split('-');
                  if (p.length == 3) label = '${p[2]}/${p[1]}';
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: isHighContrast ? DarkPalette.textSecondary : const Color(0xFF64748B),
                    ),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            interval: 20,
            getTitlesWidget: (value, meta) => Text(
              '${value.toInt()}°C',
              style: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            interval: 20,
            getTitlesWidget: (value, meta) => Text(
              '${value.toInt()}%',
              style: const TextStyle(color: Color(0xFF0284C7), fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: tempSpots,
          isCurved: true,
          color: const Color(0xFFFF6B6B),
          barWidth: 2.5,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0xFFFF6B6B).withOpacity(0.15), const Color(0xFFFF6B6B).withOpacity(0.0)],
            ),
          ),
        ),
        LineChartBarData(
          spots: umidSpots,
          isCurved: true,
          color: const Color(0xFF0284C7),
          barWidth: 2.5,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0xFF0284C7).withOpacity(0.15), const Color(0xFF0284C7).withOpacity(0.0)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, bool isHighContrast) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isHighContrast ? DarkPalette.textSecondary : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(double umidade) {
    String text;
    Color bg;
    Color fg;

    if (umidade < 40.0) {
      text = 'Ruim';
      bg = const Color(0xFFF8D7DA);
      fg = const Color(0xFF721C24);
    } else if (umidade <= 70.0) {
      text = 'Bom';
      bg = const Color(0xFFFFF3CD);
      fg = const Color(0xFF856404);
    } else {
      text = 'Ótimo';
      bg = const Color(0xFFD4EDDA);
      fg = const Color(0xFF155724);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
    );
  }
}