import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'accessibility_provider.dart';
import 'api_service.dart';
import 'botao_acessibilidade.dart';

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

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const azul = Color(0xFF002855);
  final ApiService _api = ApiService();

  Map<String, dynamic>? _dashboardData;
  bool _carregandoInicial = true;
  String? _erro;

  Timer? _pollingTimer;
  static const Duration _intervaloAtualizacao = Duration(seconds: 15);

  @override
  void initState() {
    super.initState();
    _carregandoDados(mostrarLoading: true);

    _pollingTimer = Timer.periodic(_intervaloAtualizacao, (_) {
      _carregandoDados(mostrarLoading: false);
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _carregandoDados({required bool mostrarLoading}) async {
    if (mostrarLoading) {
      setState(() {
        _carregandoInicial = true;
        _erro = null;
      });
    }

    try {
      final dados = await _api.getDashboard();

      if (!mounted) return;
      setState(() {
        _dashboardData = dados;
        _carregandoInicial = false;
        _erro = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = e.toString();
        _carregandoInicial = false;
      });
    }
  }

  Future<void> _logout() async {
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
      appBar: AppBar(
        title: Text("Painel Principal", style: TextStyle(fontSize: 20 * f)),
        backgroundColor: appBarBg,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: Border(bottom: appBarBorder),
        actions: const [BotaoAcessibilidade()],
      ),
      drawer: _buildDrawer(high, f),
      body: _carregandoInicial
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Erro ao carregar dados",
                        style: TextStyle(
                          color: high ? Colors.redAccent : Colors.red,
                          fontSize: 16 * f,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _carregandoDados(mostrarLoading: true),
                        child: const Text("Tentar Novamente"),
                      )
                    ],
                  ),
                )
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
                            _cardMetric(
                              "Plantas",
                              _dashboardData?['qtdPlantas']?.toString() ?? '0',
                              Icons.park,
                              bgContainer,
                              high,
                              f,
                            ),
                            _cardMetric(
                              "Irrigações",
                              _dashboardData?['qtdIrrigacoes']?.toString() ?? '0',
                              Icons.water_drop,
                              bgContainer,
                              high,
                              f,
                            ),
                            _cardMetric(
                              "Dispositivos",
                              _dashboardData?['dispositivosAtivos']?.toString() ?? '0',
                              Icons.memory,
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

  Widget _cardMetric(
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
        border: high ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5) : null,
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
            style: TextStyle(
              fontSize: 14 * f,
              color: high ? DarkPalette.textSecondary : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(bool high, double f) {
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

            _item(Icons.home, "Painel", '/dashboard', f),
            _item(Icons.park, "Plantas", '/plantas', f),
            _item(Icons.history, "Histórico", '/historico', f),
            _item(Icons.memory, "Equipamentos", '/equipamentos', f),

            const Spacer(),
            Divider(color: high ? DarkPalette.surfaceBorder : Colors.white24),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: Text("Sair", style: TextStyle(color: Colors.white, fontSize: 14 * f)),
              onTap: _logout,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, String label, String route, double f) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: TextStyle(color: Colors.white, fontSize: 14 * f)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}