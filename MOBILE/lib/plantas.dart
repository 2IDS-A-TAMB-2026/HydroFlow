import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tcc/home.dart';
import 'accessibility_provider.dart';
import 'botao_acessibilidade.dart';

/// ─────────────────────────────────────────────
/// PALETA DO MODO ESCURO
/// ─────────────────────────────────────────────
class DarkPalette {
  static const Color background = Color(0xFF0A1A2B);
  static const Color surface = Color(0xFF10263D);
  static const Color surfaceElevated = Color(0xFF16324B);
  static const Color surfaceBorder = Color(0xFF1E3B57);
  static const Color textPrimary = Color(0xFFF2F6FA);
  static const Color textSecondary = Color(0xFFA9C0D6);
}

class PlantasPage extends StatefulWidget {
  const PlantasPage({super.key});

  @override
  State<PlantasPage> createState() => _PlantasPageState();
}

class _PlantasPageState extends State<PlantasPage> {
  static const azul = Color(0xFF002855);

  // Estados de Carregamento e Dados da API
  bool isLoading = true;
  List<dynamic> plantas = [];
  List<dynamic> plantasFiltradas = [];

  // Controladores de Filtros e Busca
  String? filtroTipo;
  String? filtroParametro;
  final TextEditingController _buscaController = TextEditingController();

  // [NOVO] Índice da fatia do gráfico que está com o mouse/dedo em cima (-1 = nenhuma)
  int _secaoTocada = -1;

  @override
  void initState() {
    super.initState();
    _buscarPlantasDaApi();
    _buscaController.addListener(_aplicarFiltros);
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  /// ─────────────────────────────────────────────
  /// REQUISIÇÃO HTTP (API)
  /// ─────────────────────────────────────────────
  Future<void> _buscarPlantasDaApi() async {
    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();

      final usuarioJson = prefs.getString('usuarioLogado');

      if (usuarioJson == null) {
        throw Exception('Usuário não encontrado.');
      }

      final usuario = jsonDecode(usuarioJson);

      final idUsuario = usuario['USU_ID'];

      if (idUsuario == null) {
        throw Exception('ID do usuário não encontrado.');
      }

      print('USUÁRIO LOGADO: $idUsuario');

      final response = await http.get(
        Uri.parse(
          'http://10.141.131.57/HydroFlow/public/api/plantas?usuario_id=$idUsuario',
        ),
        headers: {'Accept': 'application/json'},
      );

      print('STATUS PLANTAS: ${response.statusCode}');
      print('RESPOSTA PLANTAS: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> dados = jsonDecode(response.body);

        setState(() {
          plantas = dados;
          isLoading = false;
        });
        // [ALTERADO] mantém a busca/filtro ativos ao atualizar a lista
        _aplicarFiltros();
      } else {
        throw Exception('Erro na API: ${response.statusCode}');
      }
    } catch (e) {
      print('ERRO PLANTAS: $e');

      setState(() {
        isLoading = false;
        plantas = [];
        plantasFiltradas = [];
      });
    }
  }

  /// ─────────────────────────────────────────────
  /// LÓGICA DE FILTRAGEM LOCAL
  /// ─────────────────────────────────────────────
  // [NOVO] deixa o texto minúsculo e sem acento (busca "hortalica" acha "Hortaliça")
  String _normalizar(String texto) {
    const comAcento = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
    const semAcento = 'aaaaaeeeeiiiiooooouuuucn';
    var resultado = texto.toLowerCase();
    for (int i = 0; i < comAcento.length; i++) {
      resultado = resultado.replaceAll(comAcento[i], semAcento[i]);
    }
    return resultado;
  }

  void _aplicarFiltros() {
    final query = _normalizar(_buscaController.text.trim());
    final tipoFiltro = filtroTipo == null ? null : _normalizar(filtroTipo!);

    setState(() {
      plantasFiltradas = plantas.where((p) {
        // [ALTERADO] chaves corretas do banco (antes: nome, cultura, tipo)
        final nome = _normalizar((p['PLANTA_NOME'] ?? p['nome'] ?? p['NOME'] ?? '').toString());
        final cultura = _normalizar((p['PLANTA_CULTURA'] ?? p['cultura'] ?? '').toString());
        final tipo = _normalizar((p['PLANTA_TIPO'] ?? p['tipo'] ?? p['TIPO'] ?? '').toString());
        final id = _normalizar((p['PLANTA_ID'] ?? p['ID'] ?? '').toString());

        final bateuBusca = query.isEmpty ||
            nome.contains(query) ||
            cultura.contains(query) ||
            tipo.contains(query) ||
            id.contains(query);
        final bateuTipo = tipoFiltro == null || tipo == _normalizar(tipoFiltro!);

        return bateuBusca && bateuTipo;
      }).toList();
    });
  }

  /// ─────────────────────────────────────────────
  /// EXPORTAÇÃO PARA PDF
  /// Exporta o que está na tela (respeita busca e filtro de tipo)
  /// ─────────────────────────────────────────────
  Future<void> _exportarPdf() async {
    if (plantasFiltradas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Não há plantas para exportar.")),
      );
      return;
    }

    try {
      final pdf = pw.Document();
      final agora = DateTime.now();
      final dataHoje =
          "${agora.day.toString().padLeft(2, '0')}/${agora.month.toString().padLeft(2, '0')}/${agora.year}";

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context ctx) {
            return [
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
                        "Relatório de Plantas Cadastradas",
                        style: const pw.TextStyle(
                          fontSize: 14,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  pw.Text(
                    "Data: $dataHoje",
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey600,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 15),

              pw.TableHelper.fromTextArray(
                headers: [
                  'ID',
                  'Nome da Planta',
                  'Tipo',
                  'Cultura',
                  'Parâmetros',
                  'Dispositivo',
                ],
                data: plantasFiltradas.map((p) {
                  return [
                    (p['PLANTA_ID'] ?? '').toString(),
                    (p['PLANTA_NOME'] ?? '').toString(),
                    (p['PLANTA_TIPO'] ?? '').toString(),
                    (p['PLANTA_CULTURA'] ?? '').toString(),
                    (p['parametro'] ??
                            "${p['PLANTA_QTD_AGUA'] ?? '0'} L (a cada ${p['PLANTA_PERIDIOCIDADE'] ?? '1'} dia(s))")
                        .toString(),
                    (p['FK_DIS_ID'] ?? '').toString(),
                  ];
                }).toList(),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                  fontSize: 10,
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
                cellPadding: const pw.EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 6,
                ),
                cellStyle: const pw.TextStyle(fontSize: 9),
              ),

              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Total de plantas exportadas: ${plantasFiltradas.length}",
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey700,
                  ),
                ),
              ),
            ];
          },
        ),
      );

      // Abre a pré-visualização / download / impressão do PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'plantas_hydroflow.pdf',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao gerar o PDF: $e")));
    }
  }

  // Retorna o ID do usuário que está logado no aplicativo.
  Future<String> _obterIdUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final usuarioJson = prefs.getString('usuarioLogado');
    if (usuarioJson == null) throw Exception('Usuário não encontrado. Faça login novamente.');
    final usuario = jsonDecode(usuarioJson);
    final id = usuario['USU_ID'];
    if (id == null) throw Exception('ID do usuário não encontrado.');
    return id.toString();
  }

  Future<void> _editarPlanta(Map<String, dynamic> planta) async {
    final id = planta['PLANTA_ID']?.toString();
    if (id == null || id.isEmpty || id == 'null') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível identificar esta planta.')),
      );
      return;
    }

    final nome = TextEditingController(text: (planta['PLANTA_NOME'] ?? '').toString());
    final tipo = TextEditingController(text: (planta['PLANTA_TIPO'] ?? '').toString());
    final cultura = TextEditingController(text: (planta['PLANTA_CULTURA'] ?? '').toString());
    final agua = TextEditingController(text: (planta['PLANTA_QTD_AGUA'] ?? '').toString());
    final periodicidade = TextEditingController(text: (planta['PLANTA_PERIDIOCIDADE'] ?? '').toString());

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Editar planta'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nome, decoration: const InputDecoration(labelText: 'Nome da planta')),
              TextField(controller: tipo, decoration: const InputDecoration(labelText: 'Tipo')),
              TextField(controller: cultura, decoration: const InputDecoration(labelText: 'Cultura')),
              TextField(controller: agua, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Quantidade de água (L)')),
              TextField(controller: periodicidade, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Periodicidade (dias)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Salvar')),
        ],
      ),
    );

    if (confirmado != true) {
      nome.dispose(); tipo.dispose(); cultura.dispose(); agua.dispose(); periodicidade.dispose();
      return;
    }
    if (nome.text.trim().isEmpty || tipo.text.trim().isEmpty || cultura.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha nome, tipo e cultura.')),
      );
      nome.dispose(); tipo.dispose(); cultura.dispose(); agua.dispose(); periodicidade.dispose();
      return;
    }

    try {
      final usuarioId = await _obterIdUsuario();
      final url = Uri.parse('http://10.141.131.57/HydroFlow/public/api/plantas/$id?usuario_id=$usuarioId');
      final response = await http.put(
        url,
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          'PLANTA_NOME': nome.text.trim(),
          'PLANTA_TIPO': tipo.text.trim(),
          'PLANTA_CULTURA': cultura.text.trim(),
          'PLANTA_QTD_AGUA': agua.text.trim().isEmpty ? '0' : agua.text.trim(),
          'PLANTA_PERIDIOCIDADE': periodicidade.text.trim().isEmpty ? '1' : periodicidade.text.trim(),
          'FK_DIS_ID': planta['FK_DIS_ID'],
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Planta atualizada com sucesso.')));
        await _buscarPlantasDaApi();
      } else {
        throw Exception('A API retornou HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Não foi possível editar a planta: $e')));
    } finally {
      nome.dispose(); tipo.dispose(); cultura.dispose(); agua.dispose(); periodicidade.dispose();
    }
  }

  Future<void> _excluirPlanta(Map<String, dynamic> planta) async {
    final id = planta['PLANTA_ID']?.toString();
    if (id == null || id.isEmpty || id == 'null') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível identificar esta planta.')),
      );
      return;
    }

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir planta'),
        content: Text('Tem certeza de que deseja excluir "${planta['PLANTA_NOME'] ?? 'esta planta'}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmado != true) return;

    try {
      final usuarioId = await _obterIdUsuario();
      final url = Uri.parse('http://10.141.131.57/HydroFlow/public/api/plantas/$id?usuario_id=$usuarioId');
      final response = await http.delete(url, headers: {'Accept': 'application/json'});
      if (response.statusCode == 200 || response.statusCode == 202 || response.statusCode == 204) {
        if (!mounted) return;
        setState(() {
          plantas.removeWhere((p) => p['PLANTA_ID'].toString() == id);
          plantasFiltradas.removeWhere((p) => p['PLANTA_ID'].toString() == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Planta excluída com sucesso.')));
        await _buscarPlantasDaApi();
      } else {
        throw Exception('A API retornou HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Não foi possível excluir a planta: $e')));
    }
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final acc = Provider.of<AccessibilityProvider>(context);
    final high = acc.isHighContrast;
    final f = acc.fontSizeFactor;

    final bgPage = high ? DarkPalette.background : const Color(0xFFF5F6FA);
    final bgContainer = high ? DarkPalette.surface : Colors.white;
    final appBarBg = high ? DarkPalette.surface : azul;
    final txtPrincipal = high ? Colors.cyanAccent : azul;
    final appBarBorder = high
        ? const BorderSide(color: DarkPalette.surfaceBorder, width: 2)
        : BorderSide.none;

    return Scaffold(
      backgroundColor: bgPage,

      /// APP BAR COM MENU SANDUÍCHE AUTOMÁTICO (devido ao Drawer)
      appBar: AppBar(
        title: Text("Plantas Cadastradas", style: TextStyle(fontSize: 20 * f)),
        backgroundColor: appBarBg,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: Border(bottom: appBarBorder),
        actions: const [BotaoAcessibilidade()],
      ),

      /// MENU SANDUÍCHE LATERAL (DRAWER)
      drawer: _buildDrawer(context, high, f),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _buscarPlantasDaApi,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 1. HEADER (Título + Botão Nova Planta)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Gestão de Plantas",
                                style: TextStyle(
                                  fontSize: 18 * f,
                                  fontWeight: FontWeight.bold,
                                  color: txtPrincipal,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Cadastre e gerencie culturas",
                                style: TextStyle(
                                  color: high
                                      ? DarkPalette.textSecondary
                                      : Colors.grey,
                                  fontSize: 14 * f,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pushReplacementNamed(
                            context,
                            '/cadastro_plantas',
                          ),
                          icon: Icon(Icons.add, size: 18 * f),
                          label: Text(
                            "Nova Planta",
                            style: TextStyle(
                              fontSize: 14 * f,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: high
                                ? DarkPalette.surfaceElevated
                                : const Color(0xFF00A65A),
                            foregroundColor: Colors.white,
                            side: high
                                ? const BorderSide(
                                    color: Colors.cyanAccent,
                                    width: 1.5,
                                  )
                                : BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// 2. GRÁFICO (FL_Chart)
                    // [ALTERADO] só o gráfico de rosca; o gráfico de barras foi removido
                    _buildChartDonut(high, f, bgContainer),

                    const SizedBox(height: 16),

                    /// 3. FILTROS AVANÇADOS
                    _buildFiltrosAvancados(high, f, bgContainer),

                    const SizedBox(height: 16),

                    /// 4. TOOLBAR DA TABELA (Busca Local + Botões de Exportação)
                    _buildTableToolbar(high, f, bgContainer),

                    const SizedBox(height: 12),

                    /// 5. TABELA DINÂMICA PREENCHIDA PELA API
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: bgContainer,
                        borderRadius: BorderRadius.circular(10),
                        border: high
                            ? Border.all(
                                color: DarkPalette.surfaceBorder,
                                width: 1.5,
                              )
                            : null,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            high
                                ? DarkPalette.surfaceElevated
                                : const Color(0xFFF0F2F5),
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
                          columnSpacing: 20,
                          columns: const [
                            DataColumn(label: Text("ID")),
                            DataColumn(label: Text("Nome da Planta")),
                            DataColumn(label: Text("Tipo")),
                            DataColumn(label: Text("Cultura")),
                            DataColumn(label: Text("Parâmetros")),
                            DataColumn(label: Text("Dispositivo")),
                            DataColumn(label: Text("Ações")),
                          ],
                          rows: plantasFiltradas.map((p) {
                            return DataRow(
                              cells: [
                                DataCell(Text(p['PLANTA_ID'].toString())),

                                DataCell(
                                  Text(
                                    p['PLANTA_NOME'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                DataCell(Text(p['PLANTA_TIPO'] ?? '')),

                                DataCell(Text(p['PLANTA_CULTURA'] ?? '')),

                                DataCell(
                                  Text(
                                    '${p['PLANTA_QTD_AGUA'] ?? '0'} L '
                                    '(a cada ${p['PLANTA_PERIDIOCIDADE'] ?? '1'} dia(s))',
                                  ),
                                ),

                                DataCell(Text(p['FK_DIS_ID'] ?? '')),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: high
                                              ? Colors.cyanAccent
                                              : Colors.blue,
                                          size: 18 * f,
                                        ),
                                        onPressed: () => _editarPlanta(Map<String, dynamic>.from(p)),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: high
                                              ? Colors.redAccent
                                              : Colors.red,
                                          size: 18 * f,
                                        ),
                                        onPressed: () => _excluirPlanta(Map<String, dynamic>.from(p)),
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
                  ],
                ),
              ),
            ),
    );
  }

  /// WIDGET DO GRÁFICO DE ROSCA
  Widget _buildChartDonut(bool high, double f, Color bg) {
    // Conta quantas plantas existem em cada cultura
    final Map<String, int> culturas = {};

    for (final planta in plantas) {
      final cultura = (planta['PLANTA_CULTURA'] ?? 'Sem cultura').toString();

      culturas[cultura] = (culturas[cultura] ?? 0) + 1;
    }

    // Se não tiver dados
    if (culturas.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: high ? DarkPalette.surfaceBorder : const Color(0xFFE9ECEF),
          ),
        ),
        child: const Center(child: Text('Nenhuma cultura cadastrada')),
      );
    }

    final total = plantas.length;

    // [NOVO] lista fixa para ligar o índice da fatia à cultura
    final entradas = culturas.entries.toList();

    // [NOVO] dados exibidos no centro do gráfico (hover/toque)
    final temSelecao = _secaoTocada >= 0 && _secaoTocada < entradas.length;
    final nomeCentro = temSelecao ? entradas[_secaoTocada].key : 'Total';
    final qtdCentro = temSelecao ? entradas[_secaoTocada].value : total;
    final pctCentro = temSelecao
        ? '${((qtdCentro / total) * 100).toStringAsFixed(0)}%'
        : null;

    final corTexto = high ? DarkPalette.textPrimary : Colors.black87;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: high ? DarkPalette.surfaceBorder : const Color(0xFFE9ECEF),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.pie_chart,
                color: high ? Colors.cyanAccent : const Color(0xFF1E3C72),
                size: 18 * f,
              ),
              const SizedBox(width: 8),
              Text(
                "Variedade de Cultivo",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15 * f,
                  color: high
                      ? DarkPalette.textPrimary
                      : const Color(0xFF1E3C72),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // [ALTERADO] gráfico com informação ao passar o mouse / tocar,
          // e sem a legenda fixa embaixo
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 55,
                    pieTouchData: PieTouchData(
                      touchCallback:
                          (FlTouchEvent event, PieTouchResponse? resposta) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              resposta == null ||
                              resposta.touchedSection == null) {
                            _secaoTocada = -1;
                            return;
                          }
                          _secaoTocada =
                              resposta.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    sections: List.generate(entradas.length, (i) {
                      final selecionada = i == _secaoTocada;

                      return PieChartSectionData(
                        value: entradas[i].value.toDouble(),
                        // [ALTERADO] a fatia sob o mouse muda levemente de cor
                        color: selecionada
                            ? (high
                                ? Colors.cyanAccent
                                : const Color(0xFF0097A7))
                            : const Color(0xFF00BCD4),
                        title: '', // sem texto fixo nas fatias
                        radius: selecionada ? 42 : 35, // destaca a fatia
                      );
                    }),
                  ),
                ),

                // Informação no centro da rosca
                IgnorePointer(
                  child: SizedBox(
                    width: 100,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          nomeCentro,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12 * f,
                            fontWeight: FontWeight.bold,
                            color: corTexto,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$qtdCentro planta(s)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11 * f,
                            color: high
                                ? DarkPalette.textSecondary
                                : Colors.black54,
                          ),
                        ),
                        if (pctCentro != null)
                          Text(
                            pctCentro,
                            style: TextStyle(
                              fontSize: 13 * f,
                              fontWeight: FontWeight.bold,
                              color: high
                                  ? Colors.cyanAccent
                                  : const Color(0xFF1E3C72),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// PAINEL DE FILTROS AVANÇADOS
  Widget _buildFiltrosAvancados(bool high, double f, Color bg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: high ? DarkPalette.surface : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: high ? DarkPalette.surfaceBorder : const Color(0xFFE9ECEF),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.filter_alt,
                color: high ? DarkPalette.textSecondary : Colors.grey[700],
                size: 16 * f,
              ),
              const SizedBox(width: 6),
              Text(
                "Filtros de Busca Avançada",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14 * f,
                  color: high ? DarkPalette.textPrimary : Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
                  value: filtroTipo,
                  decoration: const InputDecoration(
                    labelText: "Buscar por Tipo",
                    border: OutlineInputBorder(),
                  ),
                  // [ALTERADO] mesmos tipos da tela de cadastro (antes tinha "Grãos")
                  items: ['Hortaliça', 'Frutífera', 'Legume', 'Grão', 'Ornamental', 'Medicinal']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) {
                    filtroTipo = v;
                    _aplicarFiltros();
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _aplicarFiltros,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A65A),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                ),
                child: Text(
                  "Filtrar",
                  style: TextStyle(fontSize: 14 * f, color: Colors.white),
                ),
              ),
              // [ALTERADO] aparece também quando há texto na busca e limpa os dois
              if (filtroTipo != null || _buscaController.text.isNotEmpty)
                TextButton(
                  onPressed: () {
                    filtroTipo = null;
                    _buscaController.clear(); // o listener reaplica os filtros
                    _aplicarFiltros();
                  },
                  child: const Text("Limpar Filtro"),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// TOOLBAR DE BUSCA E EXPORTAÇÃO
  Widget _buildTableToolbar(bool high, double f, Color bg) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 280,
          child: TextField(
            controller: _buscaController,
            style: TextStyle(
              fontSize: 14 * f,
              color: high ? DarkPalette.textPrimary : Colors.black,
            ),
            decoration: InputDecoration(
              hintText: "Buscar por nome ou cultura...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: bg,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: _exportarPdf,
              icon: const Icon(Icons.download, size: 16),
              label: const Text("Exportar PDF"),
            ),
          ],
        ),
      ],
    );
  }

  /// MENU SANDUÍCHE (DRAWER)

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
          color: high ? null : Home.azulPrimario,
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
            _drawerItem(
              context,
              Icons.show_chart,
              "Histórico de Medição",
              f,
              () {
                Navigator.pushReplacementNamed(context, '/dados_sensores');
              },
            ),
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

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    double f,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 14 * f),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}