import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/botao_acessibilidade.dart';
import 'accessibility_provider.dart';

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

  final ApiService _api = ApiService();

  DashboardData? _dashboardData;

  bool _carregandoInicial = true;
  String? _erro;

  Timer? _pollingTimer;

  static const Duration _intervaloAtualizacao = Duration(seconds: 15);

  @override
  void initState() {
    super.initState();
    _carregarDados(mostrarLoading: true);

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
      final json = await _api.getDashboard();
      final dados = DashboardData.fromJson(json);

      if (!mounted) return;

      setState(() {
        _dashboardData = dados;
        _carregandoInicial = false;
        _erro = null;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _carregandoInicial = false;
        _erro = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _carregandoInicial = false;
        _erro = 'Erro inesperado: $e';
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
              else
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: [
                    _KpiCard(
                      value: "${_dashboardData?.qtdPlantas ?? 0}",
                      label: "Plantas",
                      color: Colors.green,
                    ),
                    _KpiCard(
                      value: "${_dashboardData?.qtdIrrigacoes ?? 0}",
                      label: "Irrigações",
                      color: Colors.cyan,
                    ),
                    _KpiCard(
                      value: "${_dashboardData?.dispositivosAtivos ?? 0}",
                      label: "Dispositivos Ativos",
                      color: Colors.blue,
                    ),
                  ],
                ),
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