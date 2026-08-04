import 'package:flutter/material.dart';
import 'dart:math';
import 'package:tcc/botao_acessibilidade.dart';
import 'accessibility_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AccessibilityProvider(),
      child: const IrrigacaoApp(),
    ),
  );
}

class IrrigacaoApp extends StatelessWidget {
  const IrrigacaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hydroflow Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF002855)),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

/// ─────────────────────────────────────────────
///  MODEL
/// ─────────────────────────────────────────────
enum IrrigacaoStatus { irrigado, falha, interrompido }

class IrrigacaoItem {
  final String nomePlanta;
  final String nomeDispositivo;
  final IrrigacaoStatus status;

  const IrrigacaoItem({
    required this.nomePlanta,
    required this.nomeDispositivo,
    required this.status,
  });
}

/// ─────────────────────────────────────────────
///  MOCK HYDROFLOW
/// ─────────────────────────────────────────────
const int totalAtivos = 12;
const int totalAlertas = 3;
const int totalPlantas = 8;
const int totalInativos = 2;

const List<IrrigacaoItem> ultimasIrrigacoes = [
  IrrigacaoItem(
    nomePlanta: 'Tomate Cereja',
    nomeDispositivo: 'ESP32-01',
    status: IrrigacaoStatus.irrigado,
  ),
  IrrigacaoItem(
    nomePlanta: 'Alface Crespa',
    nomeDispositivo: 'ESP32-02',
    status: IrrigacaoStatus.falha,
  ),
];

const List<String> graficoLabels = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
const List<double> graficoValores = [12.5, 18.0, 9.3, 22.1, 15.6, 7.8, 19.4];

/// ─────────────────────────────────────────────
///  PALETA DO MODO ESCURO (mantém as cores do app)
/// ─────────────────────────────────────────────
class DarkPalette {
  // Fundo escuro em vez de preto puro (derivado do azul primário)
  static const Color background = Color(0xFF0A1A2B);
  static const Color surface = Color(0xFF10263D);
  static const Color surfaceBorder = Color(0xFF1E3B57);
  static const Color textPrimary = Color(0xFFF2F6FA);
  static const Color textSecondary = Color(0xFFA9C0D6);
}

/// ─────────────────────────────────────────────
///  DASHBOARD HYDROFLOW
/// ─────────────────────────────────────────────
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const azulPrimario = Color(0xFF002855);
  static const azulCyan = Color(0xFF4DD0E1);

  @override
  Widget build(BuildContext context) {
    final acc = Provider.of<AccessibilityProvider>(context);
    final high = acc.isHighContrast;
    final f = acc.fontSizeFactor;

    // Fundo escuro com tom de azul, não preto/branco puro
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
        shape: Border(bottom: appBarBorder), // Borda visual no modo escuro
        title: Text(
          'Painel HYDROFLOW',
          style: TextStyle(fontSize: 18 * f, fontWeight: FontWeight.bold),
        ),
        actions: const [BotaoAcessibilidade()],
      ),

      floatingActionButton: const BotaoAcessibilidade(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ── KPI ─────────────────────────────
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: [
                _KpiCard(value: "$totalAtivos", label: "Dispositivos Ativos", color: Colors.cyan),
                _KpiCard(value: "$totalAlertas", label: "Alertas", color: Colors.orange),
                _KpiCard(value: "$totalPlantas", label: "Plantas", color: Colors.green),
                _KpiCard(value: "$totalInativos", label: "Inativos", color: Colors.red),
              ],
            ),

            const SizedBox(height: 20),

            /// ── TABELA ──────────────────────────
            _TableWidget(),

            const SizedBox(height: 20),

            /// ── GRÁFICO ─────────────────────────
            _ChartWidget(),
          ],
        ),
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
        // No modo escuro a borda usa a cor do próprio KPI, mais forte,
        // em vez de ficar tudo branco/preto
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
              // valor numérico ganha a cor do KPI no modo escuro
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
          ...ultimasIrrigacoes.map((item) => Padding(
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
            child: CustomPaint(
              painter: _LinePainter(
                values: graficoValores,
                labels: graficoLabels,
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
    final chartHeight = size.height - 40;
    final chartWidth = size.width - 20;

    final maxValue = values.reduce(max);
    final stepX = chartWidth / (values.length - 1);

    // Cor de destaque do gráfico: verde-água no modo claro, cyan vivo no escuro
    final lineColor = isHighContrast ? Colors.cyanAccent : const Color(0xFF00A65A);

    /// ── GRID ─────────────────────────────
    final gridPaint = Paint()
      ..color = isHighContrast
          ? DarkPalette.surfaceBorder.withOpacity(0.6)
          : Colors.grey.withOpacity(0.15)
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = (chartHeight / 4) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(chartWidth, y),
        gridPaint,
      );
    }

    /// ── POINTS ───────────────────────────
    List<Offset> points = [];
    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = chartHeight - (values[i] / maxValue * chartHeight);
      points.add(Offset(x, y));
    }

    /// ── CURVE PATH ───────────────────────
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      final midX = (current.dx + next.dx) / 2;

      path.cubicTo(
        midX, current.dy,
        midX, next.dy,
        next.dx, next.dy,
      );
    }

    /// ── AREA FILL ─────────────────────────
    // Agora também preenche no modo escuro, com opacidade menor
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

    /// ── LINE ─────────────────────────────
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = isHighContrast ? 3 : 2.5;

    canvas.drawPath(path, linePaint);

    /// ── DOTS + LABELS ─────────────────────
    for (int i = 0; i < points.length; i++) {
      final p = points[i];

      canvas.drawCircle(
        p,
        5,
        Paint()..color = isHighContrast ? DarkPalette.surface : Colors.white,
      );
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
        // Em vez de preto puro, mantém um degradê do azul da marca
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