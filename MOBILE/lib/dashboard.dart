import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tcc/botao_acessibilidade.dart';
import 'accessibility_provider.dart';

/// ─────────────────────────────────────────────
///  MODELOS DE DADOS
/// ─────────────────────────────────────────────
class KpiData {
  final int totalAtivos;
  final int totalAlertas;
  final int totalPlantas;
  final int totalInativos;

  KpiData({
    required this.totalAtivos,
    required this.totalAlertas,
    required this.totalPlantas,
    required this.totalInativos,
  });

  factory KpiData.fromJson(Map<String, dynamic> json) {
    return KpiData(
      totalAtivos: json['totalAtivos'] ?? 0,
      totalAlertas: json['totalAlertas'] ?? 0,
      totalPlantas: json['totalPlantas'] ?? 0,
      totalInativos: json['totalInativos'] ?? 0,
    );
  }
}

enum IrrigacaoStatus { irrigado, falha, interrompido }

class IrrigacaoItem {
  final String nomePlanta;
  final String nomeDispositivo;
  final IrrigacaoStatus status;

  IrrigacaoItem({
    required this.nomePlanta,
    required this.nomeDispositivo,
    required this.status,
  });

  factory IrrigacaoItem.fromJson(Map<String, dynamic> json) {
    return IrrigacaoItem(
      nomePlanta: json['nomePlanta'] ?? '',
      nomeDispositivo: json['nomeDispositivo'] ?? '',
      status: _statusFromString(json['status']),
    );
  }

  static IrrigacaoStatus _statusFromString(String? value) {
    switch (value) {
      case 'irrigado':
        return IrrigacaoStatus.irrigado;
      case 'interrompido':
        return IrrigacaoStatus.interrompido;
      default:
        return IrrigacaoStatus.falha;
    }
  }
}

class ConsumoAguaPonto {
  final String label;
  final double valor;

  ConsumoAguaPonto({required this.label, required this.valor});

  factory ConsumoAguaPonto.fromJson(Map<String, dynamic> json) {
    return ConsumoAguaPonto(
      label: json['label'] ?? '',
      valor: (json['valor'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// ─────────────────────────────────────────────
///  CHAMADAS GET PARA A API
/// ─────────────────────────────────────────────
class HydroflowApiService {
  // TROQUE pela URL real da sua API
  static const String baseUrl = 'https://';

  /// GET - KPIs do topo do dashboard
  Future<KpiData> getKpis() async {
    final response = await http.get(Uri.parse('$baseUrl/dashboard/kpis'));

    if (response.statusCode == 200) {
      return KpiData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao buscar KPIs: ${response.statusCode}');
    }
  }

  /// GET - Últimas irrigações (tabela)
  Future<List<IrrigacaoItem>> getUltimasIrrigacoes() async {
    final response = await http.get(Uri.parse('$baseUrl/irrigacoes/ultimas'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => IrrigacaoItem.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar irrigações: ${response.statusCode}');
    }
  }

  /// GET - Dados do gráfico de consumo de água
  Future<List<ConsumoAguaPonto>> getConsumoAgua() async {
    final response = await http.get(Uri.parse('$baseUrl/consumo-agua/semana'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ConsumoAguaPonto.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar consumo de água: ${response.statusCode}');
    }
  }
}

/// ─────────────────────────────────────────────
///  PALETA DO MODO ESCURO
/// ─────────────────────────────────────────────
class DarkPalette {
  static const Color background = Color(0xFF0A1A2B);
  static const Color surface = Color(0xFF10263D);
  static const Color surfaceBorder = Color(0xFF1E3B57);
  static const Color textPrimary = Color(0xFFF2F6FA);
  static const Color textSecondary = Color(0xFFA9C0D6);
}

/// ─────────────────────────────────────────────
///  DASHBOARD HYDROFLOW (dados da API + auto-refresh)
/// ─────────────────────────────────────────────
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const azulPrimario = Color(0xFF002855);
  static const azulCyan = Color(0xFF4DD0E1);

  final HydroflowApiService _api = HydroflowApiService();

  KpiData? _kpiData;
  List<IrrigacaoItem> _irrigacoes = [];
  List<ConsumoAguaPonto> _consumo = [];

  bool _carregandoInicial = true;
  String? _erro;

  Timer? _pollingTimer;

  // Intervalo de atualização automática
  static const Duration _intervaloAtualizacao = Duration(seconds: 15);

  @override
  void initState() {
    super.initState();
    _carregarDados(mostrarLoading: true);

    // Polling: busca dados novos periodicamente sem precisar de ação do usuário
    _pollingTimer = Timer.periodic(_intervaloAtualizacao, (_) {
      _carregarDados(mostrarLoading: false);
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _carregarDados({required bool mostrarLoading}) async {
    if (mostrarLoading) {
      setState(() {
        _carregandoInicial = true;
        _erro = null;
      });
    }

    try {
      final results = await Future.wait([
        _api.getKpis(),
        _api.getUltimasIrrigacoes(),
        _api.getConsumoAgua(),
      ]);

      if (!mounted) return;

      setState(() {
        _kpiData = results[0] as KpiData;
        _irrigacoes = results[1] as List<IrrigacaoItem>;
        _consumo = results[2] as List<ConsumoAguaPonto>;
        _carregandoInicial = false;
        _erro = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _carregandoInicial = false;
        _erro = e.toString();
      });
    }
  }

  Future<void> _recarregarManual() async {
    await _carregarDados(mostrarLoading: false);
  }

  @override
  Widget build(BuildContext context) {
    final acc = Provider.of<AccessibilityProvider>(context);
    final high = acc.isHighContrast;
    final f = acc.fontSizeFactor;

    final bg = high ? DarkPalette.background : const Color(0xFFF4F6F9);
    final appBarBg = high ? DarkPalette.surface : azulPrimario;
    final appBarBorder = high
        ? const BorderSide(color: DarkPalette.surfaceBorder, width: 2)
        : BorderSide.none;

    return Scaffold(
      backgroundColor: bg,
      drawer: _HydroflowDrawer(),
      appBar: AppBar(
        backgroundColor: appBarBg,
        foregroundColor: Colors.white,
        shape: Border(bottom: appBarBorder),
        title: Text(
          'Painel HYDROFLOW',
          style: TextStyle(fontSize: 18 * f, fontWeight: FontWeight.bold),
        ),
        actions: const [BotaoAcessibilidade()],
      ),
      floatingActionButton: const BotaoAcessibilidade(),
      body: RefreshIndicator(
        onRefresh: _recarregarManual,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_carregandoInicial)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_erro != null)
                _ErrorBox(mensagem: _erro!, onTentarNovamente: _recarregarManual)
              else ...[
                /// ── KPI ─────────────────────────────
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: [
                    _KpiCard(value: "${_kpiData?.totalAtivos ?? 0}", label: "Dispositivos Ativos", color: Colors.cyan),
                    _KpiCard(value: "${_kpiData?.totalAlertas ?? 0}", label: "Alertas", color: Colors.orange),
                    _KpiCard(value: "${_kpiData?.totalPlantas ?? 0}", label: "Plantas", color: Colors.green),
                    _KpiCard(value: "${_kpiData?.totalInativos ?? 0}", label: "Inativos", color: Colors.red),
                  ],
                ),

                const SizedBox(height: 20),

                /// ── TABELA ──────────────────────────
                _TableWidget(itens: _irrigacoes),

                const SizedBox(height: 20),

                /// ── GRÁFICO ─────────────────────────
                _ChartWidget(pontos: _consumo),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────────
///  BOX DE ERRO GENÉRICA
/// ─────────────────────────────────────────────
class _ErrorBox extends StatelessWidget {
  final String mensagem;
  final VoidCallback? onTentarNovamente;

  const _ErrorBox({required this.mensagem, this.onTentarNovamente});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent),
              const SizedBox(width: 8),
              Expanded(child: Text('Erro ao carregar dados: $mensagem')),
            ],
          ),
          if (onTentarNovamente != null) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onTentarNovamente,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ],
      ),
    );
  }
}

/// ─────────────────────────────────────────────
///  KPI CARD HYDROFLOW
/// ─────────────────────────────────────────────
class _KpiCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _KpiCard({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final acc = Provider.of<AccessibilityProvider>(context);
    final high = acc.isHighContrast;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: high ? DarkPalette.surface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: high
            ? Border.all(color: color.withOpacity(0.9), width: 1.5)
            : Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24 * acc.fontSizeFactor,
              fontWeight: FontWeight.bold,
              color: high ? color : Colors.black87,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12 * acc.fontSizeFactor,
              color: high ? DarkPalette.textSecondary : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

/// ─────────────────────────────────────────────
///  TABELA HYDROFLOW
/// ─────────────────────────────────────────────
class _TableWidget extends StatelessWidget {
  final List<IrrigacaoItem> itens;

  const _TableWidget({required this.itens});

  @override
  Widget build(BuildContext context) {
    final acc = Provider.of<AccessibilityProvider>(context);
    final high = acc.isHighContrast;
    final f = acc.fontSizeFactor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: high ? DarkPalette.surface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: high ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Últimas Irrigações",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16 * f,
              color: high ? Colors.cyanAccent : const Color(0xFF002855),
            ),
          ),
          const SizedBox(height: 12),
          if (itens.isEmpty)
            Text(
              "Nenhuma irrigação registrada.",
              style: TextStyle(
                fontSize: 13 * f,
                color: high ? DarkPalette.textSecondary : Colors.grey,
              ),
            ),
          ...itens.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nomePlanta,
                      style: TextStyle(
                        fontSize: 14 * f,
                        fontWeight: FontWeight.w600,
                        color: high ? DarkPalette.textPrimary : Colors.black87,
                      ),
                    ),
                    Text(
                      item.nomeDispositivo,
                      style: TextStyle(
                        fontSize: 12 * f,
                        color: high ? DarkPalette.textSecondary : Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.status == IrrigacaoStatus.irrigado
                        ? Colors.green.withOpacity(high ? 0.35 : 0.2)
                        : Colors.red.withOpacity(high ? 0.35 : 0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: high
                        ? Border.all(
                            color: item.status == IrrigacaoStatus.irrigado
                                ? Colors.greenAccent
                                : Colors.redAccent,
                          )
                        : null,
                  ),
                  child: Text(
                    item.status == IrrigacaoStatus.irrigado ? "Irrigado" : "Falha",
                    style: TextStyle(
                      fontSize: 12 * f,
                      fontWeight: FontWeight.bold,
                      color: high
                          ? (item.status == IrrigacaoStatus.irrigado
                              ? Colors.greenAccent
                              : Colors.redAccent)
                          : (item.status == IrrigacaoStatus.irrigado
                              ? Colors.green[800]
                              : Colors.red[800]),
                    ),
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}

/// ─────────────────────────────────────────────
///  GRÁFICO HYDROFLOW
/// ─────────────────────────────────────────────
class _ChartWidget extends StatelessWidget {
  final List<ConsumoAguaPonto> pontos;

  const _ChartWidget({required this.pontos});

  @override
  Widget build(BuildContext context) {
    final acc = Provider.of<AccessibilityProvider>(context);
    final high = acc.isHighContrast;
    final f = acc.fontSizeFactor;

    return Container(
      height: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: high ? DarkPalette.surface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: high ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5) : null,
        boxShadow: high
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                )
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Consumo de Água (L)",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14 * f,
              color: high ? DarkPalette.textPrimary : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: pontos.isEmpty
                ? Center(
                    child: Text(
                      "Sem dados de consumo.",
                      style: TextStyle(
                        color: high ? DarkPalette.textSecondary : Colors.grey,
                      ),
                    ),
                  )
                : CustomPaint(
                    painter: _LinePainter(
                      values: pontos.map((p) => p.valor).toList(),
                      labels: pontos.map((p) => p.label).toList(),
                      isHighContrast: high,
                    ),
                    size: Size.infinite,
                  ),
          ),
        ],
      ),
    );
  }
}

/// ─────────────────────────────────────────────
///  PAINTER (gráfico Hydroflow)
/// ─────────────────────────────────────────────
class _LinePainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final bool isHighContrast;

  _LinePainter({
    required this.values,
    required this.labels,
    required this.isHighContrast,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final chartHeight = size.height - 40;
    final chartWidth = size.width - 20;

    final maxValue = values.reduce(max) == 0 ? 1 : values.reduce(max);
    final stepX = values.length > 1 ? chartWidth / (values.length - 1) : 0.0;

    final lineColor = isHighContrast ? Colors.cyanAccent : const Color(0xFF00A65A);

    final gridPaint = Paint()
      ..color = isHighContrast
          ? DarkPalette.surfaceBorder.withOpacity(0.6)
          : Colors.grey.withOpacity(0.15)
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = (chartHeight / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), gridPaint);
    }

    List<Offset> points = [];
    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = chartHeight - (values[i] / maxValue * chartHeight);
      points.add(Offset(x, y));
    }

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      final midX = (current.dx + next.dx) / 2;

      path.cubicTo(midX, current.dy, midX, next.dy, next.dx, next.dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, chartHeight)
      ..lineTo(points.first.dx, chartHeight)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          lineColor.withOpacity(isHighContrast ? 0.30 : 0.25),
          Colors.transparent,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = isHighContrast ? 3 : 2.5;

    canvas.drawPath(path, linePaint);

    for (int i = 0; i < points.length; i++) {
      final p = points[i];

      canvas.drawCircle(p, 5, Paint()..color = isHighContrast ? DarkPalette.surface : Colors.white);
      canvas.drawCircle(
        p,
        5,
        Paint()
          ..color = lineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      final tp = TextPainter(
        text: TextSpan(
          text: values[i].toStringAsFixed(0),
          style: TextStyle(
            fontSize: 10,
            color: isHighContrast ? DarkPalette.textPrimary : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(p.dx - tp.width / 2, p.dy - 18));

      final labelPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            fontSize: 10,
            color: isHighContrast ? DarkPalette.textSecondary : Colors.grey,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      labelPainter.paint(canvas, Offset(p.dx - 10, chartHeight + 4));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// ─────────────────────────────────────────────
///  DRAWER
/// ─────────────────────────────────────────────
class _HydroflowDrawer extends StatelessWidget {
  static const azulPrimario = Color(0xFF002855);

  const _HydroflowDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final acc = Provider.of<AccessibilityProvider>(context);
    final f = acc.fontSizeFactor;
    final high = acc.isHighContrast;

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
          color: high ? null : azulPrimario,
        ),
        child: Column(
          children: [
            Container(
              height: 160,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: high
                    ? const Border(bottom: BorderSide(color: DarkPalette.surfaceBorder))
                    : null,
              ),
              child: Text(
                "HYDROFLOW",
                style: TextStyle(
                  color: high ? Colors.cyanAccent : Colors.white,
                  fontSize: 26 * f,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Divider(color: high ? DarkPalette.surfaceBorder : Colors.white24),
            _drawerItem(context, Icons.home, "Painel", '/dashboard'),
            _drawerItem(context, Icons.park, "Plantas", '/plantas'),
            _drawerItem(context, Icons.history, "Histórico", '/historico'),
            _drawerItem(context, Icons.memory, "Equipamentos", '/equipamentos'),
            const Spacer(),
            Divider(color: high ? DarkPalette.surfaceBorder : Colors.white24),
            _drawerItem(context, Icons.logout, "Sair", '/login'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String label, String route) {
    final acc = Provider.of<AccessibilityProvider>(context);

    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14 * acc.fontSizeFactor,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        try {
          Navigator.pushReplacementNamed(context, route);
        } catch (e) {
          debugPrint("Rota $route não configurada ainda.");
        }
      },
    );
  }
}