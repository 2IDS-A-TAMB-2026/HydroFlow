import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const Color azul = Color(0xFF002855);

  // Dados retornados pela API
  Map<String, dynamic>? dashboardData;

  // Controlar carregamento
  bool carregando = true;

  // Armazenar erro
  String? erro;

  // Timer para atualização automática
  Timer? pollingTimer;

  static const Duration intervaloAtualizacao = Duration(seconds: 15);

  @override
  void initState() {
    super.initState();

    consultarDashboard();

    // Atualizar automaticamente
    pollingTimer = Timer.periodic(intervaloAtualizacao, (_) {
      consultarDashboard(mostrarLoading: false);
    });
  }

  @override
  void dispose() {
    pollingTimer?.cancel();
    super.dispose();
  }

  /// ─────────────────────────────────────────────
  /// CONSULTAR API
  /// ─────────────────────────────────────────────

  Future<void> consultarDashboard({bool mostrarLoading = true}) async {
    if (mostrarLoading) {
      setState(() {
        carregando = true;
        erro = null;
      });
    }

    try {
      final resposta = await http.get(
        Uri.parse('http://DESKTOP-38ILVP3/HydroFlow/public/api/dashboard'),
        headers: {'Accept': 'application/json'},
      );

      final resultado = jsonDecode(resposta.body);

      if (resposta.statusCode == 200) {
        if (!mounted) return;

        final kpis = Map<String, dynamic>.from(
          resultado['data']?['kpis'] ?? {},
        );
        setState(() {
          dashboardData = kpis;
          carregando = false;
          erro = null;
        });
      } else {
        if (!mounted) return;

        setState(() {
          erro = resultado['message'] ?? 'Erro ao consultar dashboard';
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

  /// ─────────────────────────────────────────────
  /// LOGOUT
  /// ─────────────────────────────────────────────

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/login');
  }

  /// Helper para ler o KPI como double
  double _kpiComoDouble(String chave) {
    final valor = dashboardData?[chave];
    if (valor == null) return 0;
    if (valor is num) return valor.toDouble();
    return double.tryParse(valor.toString()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final acc = Provider.of<AccessibilityProvider>(context);

    final high = acc.isHighContrast;
    final f = acc.fontSizeFactor;

    final bgPage = high ? DarkPalette.background : const Color(0xFFF4F6F9);
    final bgContainer = high ? DarkPalette.surface : Colors.white;
    final appBarBg = high ? DarkPalette.surface : azul;
    final txtPrincipal = high ? Colors.cyanAccent : azul;

    final appBarBorder = high
        ? const BorderSide(color: DarkPalette.surfaceBorder, width: 2)
        : BorderSide.none;

    return Scaffold(
      backgroundColor: bgPage,

      appBar: AppBar(
        title: Text("Painel Principal", style: TextStyle(fontSize: 20 * f)),
        backgroundColor: appBarBg,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: Border(bottom: appBarBorder),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: () {
              consultarDashboard();
            },
            icon: const Icon(Icons.refresh),
          ),
          const BotaoAcessibilidade(),
        ],
      ),

      drawer: buildDrawer(high, f),

      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : erro != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 50 * f,
                          color: high ? Colors.redAccent : Colors.red,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Erro ao carregar dados",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: high ? Colors.redAccent : Colors.red,
                            fontSize: 18 * f,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          erro ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14 * f),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            consultarDashboard();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text("Tentar novamente"),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Visão Geral",
                            style: TextStyle(
                              fontSize: 20 * f,
                              fontWeight: FontWeight.bold,
                              color: txtPrincipal,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: high
                                  ? DarkPalette.surfaceElevated
                                  : Colors.blue.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.sync,
                                    size: 14,
                                    color: high ? Colors.cyanAccent : azul),
                                const SizedBox(width: 4),
                                Text(
                                  "Ao vivo",
                                  style: TextStyle(
                                    fontSize: 11 * f,
                                    fontWeight: FontWeight.w600,
                                    color: high ? Colors.cyanAccent : azul,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 16),

                      // CARDS DE MÉTRICAS
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.15,
                        children: [
                          cardMetric(
                            "Plantas",
                            dashboardData?['total_plantas']?.toString() ?? '0',
                            Icons.park_rounded,
                            high ? Colors.greenAccent : const Color(0xFF2E7D32),
                            bgContainer,
                            high,
                            f,
                          ),
                          cardMetric(
                            "Dispositivos",
                            dashboardData?['total_ativos']?.toString() ?? '0',
                            Icons.memory_rounded,
                            high ? Colors.cyanAccent : const Color(0xFF0288D1),
                            bgContainer,
                            high,
                            f,
                          ),
                          cardMetric(
                            "Alertas",
                            dashboardData?['total_alertas']?.toString() ?? '0',
                            Icons.warning_amber_rounded,
                            high ? Colors.orangeAccent : const Color(0xFFED6C02),
                            bgContainer,
                            high,
                            f,
                          ),
                          cardMetric(
                            "Consumo (L)",
                            dashboardData?['consumo_total_litros']?.toString() ?? '0',
                            Icons.water_drop_rounded,
                            high ? Colors.tealAccent : const Color(0xFF00897B),
                            bgContainer,
                            high,
                            f,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Text(
                        "Análise Radar de Operação",
                        style: TextStyle(
                          fontSize: 18 * f,
                          fontWeight: FontWeight.bold,
                          color: txtPrincipal,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // GRÁFICO DE RADAR NORMALIZADO
                      buildKpiRadarChart(bgContainer, high, f),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
    );
  }

  /// ─────────────────────────────────────────────
  /// CARD DAS MÉTRICAS
  /// ─────────────────────────────────────────────

  Widget cardMetric(
    String title,
    String value,
    IconData icon,
    Color accentColor,
    Color bg,
    bool high,
    double f,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: high
              ? DarkPalette.surfaceBorder
              : Colors.black.withOpacity(0.06),
          width: high ? 1.5 : 1.0,
        ),
        boxShadow: high
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(high ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 22 * f,
                  color: accentColor,
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 22 * f,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: high ? DarkPalette.textPrimary : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w500,
                  color: high ? DarkPalette.textSecondary : Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ─────────────────────────────────────────────
  /// GRÁFICO RADAR NORMALIZADO
  /// ─────────────────────────────────────────────

  Widget buildKpiRadarChart(Color bg, bool high, double f) {
    // Definimos limites máximos realistas para cada variável
    final metricas = <_MetricaRadar>[
      _MetricaRadar(
        label: "Plantas",
        valorReal: _kpiComoDouble('total_plantas'),
        maxEsperado: 20, // Limite de referência para plantas
      ),
      _MetricaRadar(
        label: "Ativos",
        valorReal: _kpiComoDouble('total_ativos'),
        maxEsperado: 10, // Limite de referência para ativos
      ),
      _MetricaRadar(
        label: "Alertas",
        valorReal: _kpiComoDouble('total_alertas'),
        maxEsperado: 15, // Limite de referência para alertas
      ),
      _MetricaRadar(
        label: "Consumo",
        valorReal: _kpiComoDouble('consumo_total_litros'),
        maxEsperado: 10000, // Limite de referência em litros
      ),
    ];

    final radarColor = high ? Colors.cyanAccent : const Color(0xFF007AFF);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: high
              ? DarkPalette.surfaceBorder
              : Colors.black.withOpacity(0.06),
          width: high ? 1.5 : 1.0,
        ),
        boxShadow: high
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 230,
            child: CustomPaint(
              size: const Size(double.infinity, 230),
              painter: _RadarChartPainter(
                metricas: metricas,
                accentColor: radarColor,
                textColor: high ? DarkPalette.textPrimary : Colors.black87,
                gridColor: high
                    ? DarkPalette.surfaceBorder
                    : Colors.grey.withOpacity(0.25),
                fontSize: 11 * f,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: radarColor.withOpacity(0.4),
                  border: Border.all(color: radarColor, width: 2),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Nível Proporcional de Operação",
                style: TextStyle(
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w500,
                  color: high ? DarkPalette.textSecondary : Colors.grey[600],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// ─────────────────────────────────────────────
  /// DRAWER
  /// ─────────────────────────────────────────────

  Widget buildDrawer(bool high, double f) {
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
            item(Icons.home, "Painel", '/dashboard', f),
            item(Icons.park, "Plantas", '/plantas', f),
            item(Icons.history, "Histórico de Ativação", '/historico', f),
            item(Icons.show_chart, "Histórico de Medição", '/dados_sensores', f),
            item(Icons.memory, "Equipamentos", '/equipamentos', f),
            const Spacer(),
            Divider(color: high ? DarkPalette.surfaceBorder : Colors.white24),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: Text(
                "Sair",
                style: TextStyle(color: Colors.white, fontSize: 14 * f),
              ),
              onTap: logout,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget item(IconData icon, String label, String route, double f) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 14 * f),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}

/// ─────────────────────────────────────────────
/// MODELO DE DADOS DO RADAR
/// ─────────────────────────────────────────────

class _MetricaRadar {
  final String label;
  final double valorReal;
  final double maxEsperado;

  _MetricaRadar({
    required this.label,
    required this.valorReal,
    required this.maxEsperado,
  });

  /// Retorna o percentual normalizado (de 0.08 a 1.0) para desenhar o radar
  double get proporcao {
    if (maxEsperado <= 0) return 0.08;
    return (valorReal / maxEsperado).clamp(0.08, 1.0);
  }
}

/// ─────────────────────────────────────────────
/// PAINTER DO GRÁFICO RADAR
/// ─────────────────────────────────────────────

class _RadarChartPainter extends CustomPainter {
  final List<_MetricaRadar> metricas;
  final Color accentColor;
  final Color textColor;
  final Color gridColor;
  final double fontSize;

  _RadarChartPainter({
    required this.metricas,
    required this.accentColor,
    required this.textColor,
    required this.gridColor,
    required this.fontSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (metricas.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 38;
    final count = metricas.length;
    final angleStep = (2 * pi) / count;

    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final axisPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // 1. Teia/Grade
    const levels = 3;
    for (int level = 1; level <= levels; level++) {
      final levelRadius = radius * (level / levels);
      final gridPath = Path();

      for (int i = 0; i < count; i++) {
        final angle = i * angleStep - (pi / 2);
        final x = center.dx + levelRadius * cos(angle);
        final y = center.dy + levelRadius * sin(angle);

        if (i == 0) {
          gridPath.moveTo(x, y);
        } else {
          gridPath.lineTo(x, y);
        }
      }
      gridPath.close();
      canvas.drawPath(gridPath, gridPaint);
    }

    // 2. Eixos e Rótulos com o Valor Real
    for (int i = 0; i < count; i++) {
      final angle = i * angleStep - (pi / 2);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      canvas.drawLine(center, Offset(x, y), axisPaint);

      final labelRadius = radius + 22;
      final lx = center.dx + labelRadius * cos(angle);
      final ly = center.dy + labelRadius * sin(angle);

      final val = metricas[i].valorReal;
      final strVal = val % 1 == 0 ? val.toInt().toString() : val.toStringAsFixed(1);
      final textSpan = TextSpan(
        text: "${metricas[i].label}\n($strVal)",
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          height: 1.1,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(lx - textPainter.width / 2, ly - textPainter.height / 2),
      );
    }

    // 3. Polígono de dados normalizado
    final dataPath = Path();
    final dataPoints = <Offset>[];

    for (int i = 0; i < count; i++) {
      final angle = i * angleStep - (pi / 2);
      final currentRadius = radius * metricas[i].proporcao;

      final x = center.dx + currentRadius * cos(angle);
      final y = center.dy + currentRadius * sin(angle);
      dataPoints.add(Offset(x, y));

      if (i == 0) {
        dataPath.moveTo(x, y);
      } else {
        dataPath.lineTo(x, y);
      }
    }
    dataPath.close();

    final fillPaint = Paint()
      ..color = accentColor.withOpacity(0.25)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final dotPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(dataPath, fillPaint);
    canvas.drawPath(dataPath, strokePaint);

    for (final point in dataPoints) {
      canvas.drawCircle(point, 4.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) {
    return oldDelegate.metricas != metricas ||
        oldDelegate.accentColor != accentColor;
  }
}