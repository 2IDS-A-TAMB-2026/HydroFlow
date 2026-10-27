import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
  State<Relatoriodados_sensoresPage> createState() =>
      _Relatoriodados_sensoresPageState();
}

class _Relatoriodados_sensoresPageState
    extends State<Relatoriodados_sensoresPage> {
  final ScrollController horizontalController = ScrollController();
  static const azul = Color(0xFF002855);

  // Controladores do formulário de filtros
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

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  // Formata data do banco YYYY-MM-DD para DD/MM/YYYY
  String _formatarDataBr(String dataBanco) {
    if (dataBanco.isEmpty) return '';
    final dia = dataBanco.length >= 10 ? dataBanco.substring(0, 10) : dataBanco;
    final partes = dia.split('-');
    if (partes.length == 3) {
      return '${partes[2]}/${partes[1]}/${partes[0]}';
    }
    return dataBanco;
  }

  // Converte datas digitadas como DD/MM/AAAA ou recebidas como AAAA-MM-DD.
  String _dataIso(String valor) {
    final texto = valor.trim();
    if (texto.isEmpty) return '';
    final partes = texto.split('/');
    if (partes.length == 3 && partes[2].length == 4) {
      return '${partes[2]}-${partes[1].padLeft(2, '0')}-${partes[0].padLeft(2, '0')}';
    }
    if (texto.length >= 10 && texto[4] == '-' && texto[7] == '-') {
      return texto.substring(0, 10);
    }
    return texto;
  }

  double _toDouble(dynamic valor) {
    return double.tryParse(valor?.toString().replaceAll(',', '.') ?? '') ?? 0.0;
  }

  String _classificar(double umidade) {
    if (umidade < 40.0) return 'Ruim';
    if (umidade <= 70.0) return 'Bom';
    return 'Ótimo';
  }

  // ===========================================================================
  // 1. REQUISIÇÃO API + FILTRO LOCAL
  // ===========================================================================
  Future<void> consultardados_sensores() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final usuarioJson = prefs.getString('usuarioLogado');
      if (usuarioJson == null) throw Exception('Usuário não encontrado.');

      final usuario = jsonDecode(usuarioJson);
      final idUsuario = usuario['USU_ID'];
      if (idUsuario == null) throw Exception('ID do usuário não encontrado.');

      final parametros = <String, String>{
        'usuario_id': idUsuario.toString(),
        if (_dataInicialController.text.isNotEmpty)
          'data_inicial': _dataInicialController.text,
        if (_dataFinalController.text.isNotEmpty)
          'data_final': _dataFinalController.text,
        if (_tempMinController.text.isNotEmpty)
          'temp_min': _tempMinController.text.replaceAll(',', '.'),
        if (_umidadeMaxController.text.isNotEmpty)
          'umidade_max': _umidadeMaxController.text.replaceAll(',', '.'),
        if (_statusFiltro != 'todos') 'status_filtro': _statusFiltro,
      };

      final uri = Uri.parse(
        'http://10.141.131.57/HydroFlow/public/api/dados_sensores',
      ).replace(queryParameters: parametros);

      print('URL DOS SENSORES: $uri');

      final resposta = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      );

      print('STATUS SENSORES: ${resposta.statusCode}');
      print('RESPOSTA SENSORES: ${resposta.body}');

      if (!mounted) return;

      if (resposta.statusCode != 200) {
        setState(() {
          erro = 'Erro na requisição: ${resposta.statusCode}';
          carregando = false;
        });
        return;
      }

      final dynamic rawJson = jsonDecode(resposta.body);
      List<dynamic> listData = [];

      if (rawJson is List) {
        listData = rawJson;
      } else if (rawJson is Map && rawJson['data'] is List) {
        listData = rawJson['data'];
      }

      // =====================================================
      // FILTRO LOCAL (garante que o filtro funcione sempre,
      // mesmo que o PHP ignore os parâmetros)
      // =====================================================
      final double? tempMin =
          double.tryParse(_tempMinController.text.replaceAll(',', '.'));
      final double? umidMax =
          double.tryParse(_umidadeMaxController.text.replaceAll(',', '.'));
      final String dataIni = _dataIso(_dataInicialController.text);
      final String dataFim = _dataIso(_dataFinalController.text);

      listData = listData.where((e) {
        final item = Map<String, dynamic>.from(e as Map);

        // Data (compara só YYYY-MM-DD)
        final dataItem = item['DDS_DATA']?.toString() ?? '';
        final dia = _dataIso(dataItem);

        if (dataIni.isNotEmpty && dia.compareTo(dataIni) < 0) return false;
        if (dataFim.isNotEmpty && dia.compareTo(dataFim) > 0) return false;

        final temp = _toDouble(item['DDS_TEMP']);
        final umid = _toDouble(item['DDS_UMIDADE']);

        if (tempMin != null && temp < tempMin) return false;
        if (umidMax != null && umid > umidMax) return false;

        switch (_statusFiltro) {
          case 'otimo':
            if (!(umid > 70)) return false;
            break;
          case 'bom':
            if (!(umid >= 40 && umid <= 70)) return false;
            break;
          case 'ruim':
            if (!(umid < 40)) return false;
            break;
        }
        return true;
      }).toList();

      // Dados do gráfico em ordem cronológica (mais antigo -> mais recente)
      final ordenados = List<dynamic>.from(listData);
      ordenados.sort((a, b) {
        final ka = '${a['DDS_DATA'] ?? ''} ${a['DDS_HORA'] ?? ''}';
        final kb = '${b['DDS_DATA'] ?? ''} ${b['DDS_HORA'] ?? ''}';
        return ka.compareTo(kb);
      });

      final labels = <String>[];
      final temps = <double>[];
      final umids = <double>[];

      for (final element in ordenados) {
        final item = Map<String, dynamic>.from(element as Map);
        labels.add(item['DDS_DATA']?.toString() ?? '');
        temps.add(_toDouble(item['DDS_TEMP']));
        umids.add(_toDouble(item['DDS_UMIDADE']));
      }

      setState(() {
        dados_sensores = listData;
        chartLabels = labels;
        tempValues = temps;
        umidValues = umids;
        carregando = false;
      });
    } catch (e) {
      print('ERRO SENSORES: $e');
      if (!mounted) return;
      setState(() {
        erro = 'Erro de conexão: $e';
        carregando = false;
      });
    }
  }

  void _limparFiltros() {
    _dataInicialController.clear();
    _dataFinalController.clear();
    _tempMinController.clear();
    _umidadeMaxController.clear();
    setState(() => _statusFiltro = 'todos');
    consultardados_sensores();
  }

  // ===========================================================================
  // 2. EXPORTAÇÃO PDF
  // ===========================================================================
  Future<void> _exportarPdf() async {
    final pdf = pw.Document();
    final agora = DateTime.now();
    final geradoEm =
        '${agora.day.toString().padLeft(2, '0')}/${agora.month.toString().padLeft(2, '0')}/${agora.year}';

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
                  pw.Text(
                    'SISTEMA DE IRRIGAÇÃO - REGISTROS DOS SENSORES (ESP32)',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text('Gerado em: $geradoEm'),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: [
                'Data e Hora',
                'Sensor / Área',
                'Temperatura',
                'Umidade Coletada',
                'Status / Saúde'
              ],
              data: dados_sensores.map((rawItem) {
                final item = Map<String, dynamic>.from(rawItem as Map);
                final umidade = _toDouble(item['DDS_UMIDADE']);
                return [
                  '${_formatarDataBr(item['DDS_DATA']?.toString() ?? '')} ${item['DDS_HORA'] ?? ''}',
                  item['nome_sensor'] ?? 'Sensor #${item['FK_SEN_ID'] ?? ''}',
                  '${item['DDS_TEMP'] ?? '0'} °C',
                  '${item['DDS_UMIDADE'] ?? '0'} %',
                  _classificar(umidade),
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColor.fromInt(0xFF1E3C72)),
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

  // ===========================================================================
  // BUILD
  // ===========================================================================
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
        title:
            Text('Relatório de Sensores', style: TextStyle(fontSize: 20 * f)),
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
      drawer: _buildDrawer(context, high, f),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // MENSAGEM DE ERRO
            if (erro != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(erro!, style: const TextStyle(color: Colors.red)),
              ),

            // CARD 1: FILTROS DE BUSCA
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgContainer,
                borderRadius: BorderRadius.circular(12),
                border: high
                    ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5)
                    : null,
                boxShadow: high
                    ? []
                    : [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8)
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.filter_alt,
                          color: high ? Colors.cyanAccent : Colors.grey[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Filtros de Busca',
                        style: TextStyle(
                          fontSize: 16 * f,
                          fontWeight: FontWeight.bold,
                          color:
                              high ? DarkPalette.textPrimary : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildDateField(
                          'Data Inicial', _dataInicialController, context, high),
                      _buildDateField(
                          'Data Final', _dataFinalController, context, high),
                      _buildNumberField('Temp. Acima (°C)', _tempMinController,
                          'Ex: 25', high),
                      _buildNumberField('Umid. Abaixo (%)',
                          _umidadeMaxController, 'Ex: 40', high),
                      _buildDropdownStatus(high),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: consultardados_sensores,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A65A),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                          icon: const Icon(Icons.search, color: Colors.white),
                          label: Text(
                            'Filtrar',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14 * f),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _limparFiltros,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            foregroundColor:
                                high ? Colors.cyanAccent : Colors.black87,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                          icon: const Icon(Icons.clear),
                          label: Text('Limpar',
                              style: TextStyle(fontSize: 14 * f)),
                        ),
                      ),
                    ],
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
                border: high
                    ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5)
                    : null,
                boxShadow: high
                    ? []
                    : [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8)
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comportamento do Ambiente',
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
                      _buildLegendItem(
                          'Temperatura (°C)', const Color(0xFFFF6B6B), high),
                      const SizedBox(width: 20),
                      _buildLegendItem(
                          'Umidade (%)', const Color(0xFF0284C7), high),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 260,
                    child: carregando
                        ? Center(
                            child: CircularProgressIndicator(
                                color: high ? Colors.cyanAccent : azul))
                        : tempValues.isEmpty
                            ? Center(
                                child: Text(
                                  'Sem dados para exibir',
                                  style: TextStyle(
                                    color: high
                                        ? DarkPalette.textSecondary
                                        : Colors.black87,
                                  ),
                                ),
                              )
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
                border: high
                    ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5)
                    : null,
                boxShadow: high
                    ? []
                    : [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8)
                      ],
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
                      ElevatedButton.icon(
                        onPressed: dados_sensores.isEmpty ? null : _exportarPdf,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC3545),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                        ),
                        icon: const Icon(Icons.picture_as_pdf,
                            size: 16, color: Colors.white),
                        label: const Text('PDF',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
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
                          high
                              ? DarkPalette.surfaceElevated
                              : const Color(0xFFE7F0F2),
                        ),
                        headingTextStyle: TextStyle(
                          color: high ? Colors.cyanAccent : azul,
                          fontWeight: FontWeight.bold,
                          fontSize: 14 * f,
                        ),
                        dataTextStyle: TextStyle(
                          color: high
                              ? DarkPalette.textSecondary
                              : Colors.black87,
                          fontSize: 13 * f,
                        ),
                        border: TableBorder.all(
                          color: high
                              ? DarkPalette.surfaceBorder
                              : const Color(0xFFE0E5E7),
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
                                final item =
                                    Map<String, dynamic>.from(rowItem as Map);

                                final data = item['DDS_DATA']?.toString() ?? '';
                                final hora = item['DDS_HORA']?.toString() ?? '';
                                final temp = item['DDS_TEMP']?.toString() ?? '0';
                                final umid =
                                    item['DDS_UMIDADE']?.toString() ?? '0';
                                final sensorId =
                                    item['FK_SEN_ID']?.toString() ?? '';

                                return DataRow(
                                  cells: [
                                    DataCell(Text(
                                        '${_formatarDataBr(data)} $hora'
                                            .trim())),
                                    DataCell(Text(
                                        item['nome_sensor']?.toString() ??
                                            'Sensor #$sensorId')),
                                    DataCell(Text('$temp °C')),
                                    DataCell(Text('$umid %')),
                                    DataCell(
                                        _buildStatusBadge(_toDouble(umid))),
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
  Widget _buildDateField(String label, TextEditingController controller,
      BuildContext context, bool isHigh) {
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
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
          );
          if (picked != null) {
            controller.text =
                "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
          }
        },
      ),
    );
  }

  Widget _buildNumberField(String label, TextEditingController controller,
      String placeholder, bool isHigh) {
    return SizedBox(
      width: 150,
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
    final List<FlSpot> tempSpots = [];
    final List<FlSpot> umidSpots = [];

    for (int i = 0; i < tempValues.length; i++) {
      tempSpots.add(FlSpot(i.toDouble(), tempValues[i]));
      umidSpots.add(FlSpot(i.toDouble(), umidValues[i]));
    }

    // Intervalo dinâmico para não sobrepor textos no eixo X
    double intervalX = (tempValues.length / 5).ceilToDouble();
    if (intervalX < 1) intervalX = 1;

    return LineChartData(
      minX: 0,
      maxX: (tempValues.length - 1).toDouble() > 0
          ? (tempValues.length - 1).toDouble()
          : 1,
      minY: 0,
      maxY: 100,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 20,
        getDrawingHorizontalLine: (value) => FlLine(
          color: isHighContrast
              ? DarkPalette.surfaceBorder
              : const Color(0xFFE2E8F0),
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
              final int index = value.toInt();
              if (index >= 0 && index < chartLabels.length) {
                String label = chartLabels[index];
                if (label.length >= 10) label = label.substring(0, 10);
                if (label.contains('-')) {
                  final List<String> p = label.split('-');
                  if (p.length == 3) label = '${p[2]}/${p[1]}';
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: isHighContrast
                          ? DarkPalette.textSecondary
                          : const Color(0xFF64748B),
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
              style: const TextStyle(
                  color: Color(0xFFFF6B6B),
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
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
              style: const TextStyle(
                  color: Color(0xFF0284C7),
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
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
              colors: [
                const Color(0xFFFF6B6B).withOpacity(0.15),
                const Color(0xFFFF6B6B).withOpacity(0.0)
              ],
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
              colors: [
                const Color(0xFF0284C7).withOpacity(0.15),
                const Color(0xFF0284C7).withOpacity(0.0)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, bool isHighContrast) {
    return Row(
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
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
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child:
          Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
    );
  }

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
            _drawerItem(context, Icons.show_chart, "Histórico de Medição", f,
                () {
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

  Widget _drawerItem(BuildContext context, IconData icon, String title,
      double f, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title:
          Text(title, style: TextStyle(color: Colors.white, fontSize: 14 * f)),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}