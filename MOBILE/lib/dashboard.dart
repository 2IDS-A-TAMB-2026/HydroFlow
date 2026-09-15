/*import 'dart:async';
import 'dart:convert';

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
      // Faz requisição GET para API
      final resposta = await http.get(
        Uri.parse('http://DESKTOP-38ILVP3/HydroFlow/public/api/dashboard'),
        headers: {'Accept': 'application/json'},
      );

      // Converter resposta para JSON
      final resultado = jsonDecode(resposta.body);

      // Verificar se API respondeu corretamente
      if (resposta.statusCode == 200) {
        if (!mounted) return;

        setState(() {
          /*
          Caso sua API retorne:

          {
            "data": {
              "qtdPlantas": 10,
              "qtdIrrigacoes": 5,
              "dispositivosAtivos": 3
            }
          }

          */
          final kpis = Map<String, dynamic>.from(
            resultado['data']?['kpis'] ?? {},
          );
          setState(() {
            dashboardData = kpis;
            carregando = false;
            erro = null;
          });
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

      /// ─────────────────────────────────────────
      /// APP BAR
      /// ─────────────────────────────────────────
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

      /// ─────────────────────────────────────────
      /// BODY
      /// ─────────────────────────────────────────
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          /// ERRO
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
          /// DASHBOARD
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Visão Geral",
                    style: TextStyle(
                      fontSize: 20 * f,
                      fontWeight: FontWeight.bold,
                      color: txtPrincipal,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        cardMetric(
                          "Plantas",
                          dashboardData?['total_plantas']?.toString() ?? '0',
                          Icons.park,
                          bgContainer,
                          high,
                          f,
                        ),

                        cardMetric(
                          "Dispositivos Ativos",
                          dashboardData?['total_ativos']?.toString() ?? '0',
                          Icons.memory,
                          bgContainer,
                          high,
                          f,
                        ),

                        cardMetric(
                          "Alertas",
                          dashboardData?['total_alertas']?.toString() ?? '0',
                          Icons.warning_amber,
                          bgContainer,
                          high,
                          f,
                        ),

                        cardMetric(
                          "Consumo (L)",
                          dashboardData?['consumo_total_litros']?.toString() ??
                              '0',
                          Icons.water_drop,
                          bgContainer,
                          high,
                          f,
                        ),
                      ],
                    ),
                  ),
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
    Color bg,
    bool high,
    double f,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),

        border: high
            ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5)
            : null,

        boxShadow: high
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(icon, size: 36 * f, color: high ? Colors.cyanAccent : azul),

          const SizedBox(height: 8),

          Text(
            value,
            style: TextStyle(
              fontSize: 22 * f,
              fontWeight: FontWeight.bold,
              color: high ? DarkPalette.textPrimary : Colors.black87,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14 * f,
              color: high ? DarkPalette.textSecondary : Colors.black54,
            ),
          ),
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

            item(Icons.history, "Histórico", '/historico', f),

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

  /// ─────────────────────────────────────────────
  /// ITEM DO DRAWER
  /// ─────────────────────────────────────────────

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
}*/

import 'dart:async';
import 'dart:convert';

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
      // Faz requisição GET para API
      final resposta = await http.get(
        Uri.parse('http://DESKTOP-38ILVP3/HydroFlow/public/api/dashboard'),
        headers: {'Accept': 'application/json'},
      );

      // Converter resposta para JSON
      final resultado = jsonDecode(resposta.body);

      // Verificar se API respondeu corretamente
      if (resposta.statusCode == 200) {
        if (!mounted) return;

        setState(() {
          /*
          Caso sua API retorne:

          {
            "data": {
              "qtdPlantas": 10,
              "qtdIrrigacoes": 5,
              "dispositivosAtivos": 3
            }
          }

          */
          final kpis = Map<String, dynamic>.from(
            resultado['data']?['kpis'] ?? {},
          );
          setState(() {
            dashboardData = kpis;
            carregando = false;
            erro = null;
          });
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

  /// ─────────────────────────────────────────────
  /// HELPER: lê um KPI como double, com fallback 0
  /// (usado apenas para desenhar o gráfico — não altera
  /// a lógica de exibição dos cards, que continua usando
  /// ?.toString() normalmente)
  /// ─────────────────────────────────────────────
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

    final bgPage = high ? DarkPalette.background : const Color(0xFFF5F6FA);

    final bgContainer = high ? DarkPalette.surface : Colors.white;

    final appBarBg = high ? DarkPalette.surface : azul;

    final txtPrincipal = high ? Colors.cyanAccent : azul;

    final appBarBorder = high
        ? const BorderSide(color: DarkPalette.surfaceBorder, width: 2)
        : BorderSide.none;

    return Scaffold(
      backgroundColor: bgPage,

      /// ─────────────────────────────────────────
      /// APP BAR
      /// ─────────────────────────────────────────
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

      /// ─────────────────────────────────────────
      /// BODY
      /// ─────────────────────────────────────────
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          /// ERRO
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
          /// DASHBOARD
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Visão Geral",
                    style: TextStyle(
                      fontSize: 20 * f,
                      fontWeight: FontWeight.bold,
                      color: txtPrincipal,
                    ),
                  ),

                  const SizedBox(height: 16),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.3,
                    children: [
                      cardMetric(
                        "Plantas",
                        dashboardData?['total_plantas']?.toString() ?? '0',
                        Icons.park,
                        bgContainer,
                        high,
                        f,
                      ),

                      cardMetric(
                        "Dispositivos Ativos",
                        dashboardData?['total_ativos']?.toString() ?? '0',
                        Icons.memory,
                        bgContainer,
                        high,
                        f,
                      ),

                      cardMetric(
                        "Alertas",
                        dashboardData?['total_alertas']?.toString() ?? '0',
                        Icons.warning_amber,
                        bgContainer,
                        high,
                        f,
                      ),

                      cardMetric(
                        "Consumo (L)",
                        dashboardData?['consumo_total_litros']?.toString() ??
                            '0',
                        Icons.water_drop,
                        bgContainer,
                        high,
                        f,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Text(
                    "Resumo em Gráfico",
                    style: TextStyle(
                      fontSize: 18 * f,
                      fontWeight: FontWeight.bold,
                      color: txtPrincipal,
                    ),
                  ),

                  const SizedBox(height: 12),

                  buildKpiBarChart(bgContainer, high, f),

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
    Color bg,
    bool high,
    double f,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),

        border: high
            ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5)
            : null,

        boxShadow: high
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(icon, size: 36 * f, color: high ? Colors.cyanAccent : azul),

          const SizedBox(height: 8),

          Text(
            value,
            style: TextStyle(
              fontSize: 22 * f,
              fontWeight: FontWeight.bold,
              color: high ? DarkPalette.textPrimary : Colors.black87,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14 * f,
              color: high ? DarkPalette.textSecondary : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  /// ─────────────────────────────────────────────
  /// GRÁFICO DE BARRAS DOS KPIS
  /// Widget nativo (sem dependência externa) que
  /// compara Plantas, Dispositivos Ativos e Alertas.
  /// O Consumo (L) fica de fora da comparação de barras
  /// porque costuma estar em uma escala bem maior — ele
  /// aparece no rótulo abaixo da própria barra, mas a
  /// altura é normalizada só entre os 3 primeiros KPIs
  /// para não distorcer o gráfico.
  /// ─────────────────────────────────────────────
  Widget buildKpiBarChart(Color bg, bool high, double f) {
    final barras = <_BarraKpi>[
      _BarraKpi(
        label: "Plantas",
        valor: _kpiComoDouble('total_plantas'),
        cor: high ? Colors.cyanAccent : azul,
      ),
      _BarraKpi(
        label: "Ativos",
        valor: _kpiComoDouble('total_ativos'),
        cor: high ? Colors.lightBlueAccent : const Color(0xFF3D7BC4),
      ),
      _BarraKpi(
        label: "Alertas",
        valor: _kpiComoDouble('total_alertas'),
        cor: high ? Colors.orangeAccent : const Color(0xFFE8A33D),
      ),
      _BarraKpi(
        label: "Consumo",
        valor: _kpiComoDouble('consumo_total_litros'),
        cor: high ? Colors.tealAccent : const Color(0xFF2FA0A0),
      ),
    ];

    final maiorValor = barras
        .map((b) => b.valor)
        .fold<double>(0, (a, b) => b > a ? b : a);

    const double alturaMaxima = 160;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: high
            ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5)
            : null,
        boxShadow: high
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: barras.map((barra) {
          final proporcao = maiorValor == 0 ? 0.0 : (barra.valor / maiorValor);
          final altura = (alturaMaxima * proporcao).clamp(4.0, alturaMaxima);

          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  barra.valor % 1 == 0
                      ? barra.valor.toInt().toString()
                      : barra.valor.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 13 * f,
                    fontWeight: FontWeight.bold,
                    color: high ? DarkPalette.textPrimary : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  height: altura,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: barra.cor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  barra.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12 * f,
                    color: high ? DarkPalette.textSecondary : Colors.black54,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
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

            item(Icons.history, "Histórico", '/historico', f),

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

  /// ─────────────────────────────────────────────
  /// ITEM DO DRAWER
  /// ─────────────────────────────────────────────

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

/// Pequena classe auxiliar só para organizar os dados de cada barra do gráfico
class _BarraKpi {
  final String label;
  final double valor;
  final Color cor;

  _BarraKpi({required this.label, required this.valor, required this.cor});
}
