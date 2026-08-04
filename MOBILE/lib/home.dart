import 'package:flutter/material.dart';
import 'package:tcc/botao_acessibilidade.dart';
import 'accessibility_provider.dart';
import 'package:provider/provider.dart';

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

class Home extends StatelessWidget {
  const Home({super.key});

  static const Color azulPrimario = Color(0xFF002855);
  static const Color azulRoyal = Color(0xFF0056B3);
  static const Color azulCyan = Color(0xFF4DD0E1);
  static const Color offWhite = Color(0xFFF5F6FA);

  @override
  Widget build(BuildContext context) {
    final accessibility = Provider.of<AccessibilityProvider>(context);
    final high = accessibility.isHighContrast;
    final f = accessibility.fontSizeFactor;

    return Scaffold(
      backgroundColor: high ? DarkPalette.background : offWhite,

      appBar: AppBar(
        backgroundColor: high ? DarkPalette.surface : azulRoyal,
        elevation: 0,
        shape: high
            ? const Border(bottom: BorderSide(color: DarkPalette.surfaceBorder, width: 2))
            : null,
        title: Text(
          "HYDROFLOW",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
            fontSize: 18 * f,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [const BotaoAcessibilidade()],
      ),

      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: high
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [DarkPalette.background, DarkPalette.surface],
                  )
                : null,
            color: high ? null : Colors.white,
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 60,
                  left: 20,
                  bottom: 25,
                ),
                color: high ? Colors.transparent : azulPrimario,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "HydroFlow",
                      style: TextStyle(
                        color: high ? Colors.cyanAccent : Colors.white,
                        fontSize: 26 * f,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Tecnologia no Campo",
                      style: TextStyle(
                        color: high ? DarkPalette.textSecondary : azulCyan,
                        fontSize: 15 * f,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(color: high ? DarkPalette.surfaceBorder : Colors.grey[200], height: 1),

              Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      _drawerItem(context, Icons.home, "Início", '/', high, f),
                      _drawerItem(context, Icons.info, "Sobre", '/sobre', high, f),
                      _drawerItem(context, Icons.login, "Login", '/login', high, f),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: ListView(
        children: [
          // HERO
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                "assets/images/irrigador.jpeg",
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              // Gradiente em vez de overlay chapado: fica mais elegante
              // e mantém o texto legível sem escurecer a foto inteira.
              Container(
                height: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.35),
                      Colors.black.withOpacity(0.75),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "HydroFlow",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 42 * f,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      height: 3,
                      width: 60,
                      color: azulCyan,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "Sistema inteligente de irrigação automática",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: azulCyan,
                        fontSize: 18 * f,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // BENEFÍCIOS
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle("Benefícios da Plataforma", high, f),

                const SizedBox(height: 20),

                buildCard(Icons.water_drop, "Economia de Água",
                    "Controle inteligente para evitar desperdícios.", high, f),

                buildCard(Icons.sync, "Automação Total",
                    "Irrigação automática baseada em sensores.", high, f),

                buildCard(Icons.analytics, "Monitoramento em Tempo Real",
                    "Acompanhe informações diretamente do sistema.", high, f),

                buildCard(Icons.security, "Confiabilidade",
                    "Tecnologia segura e estável para produção agrícola.", high, f),
              ],
            ),
          ),

          // DESAFIO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: buildBox(
                    "O Problema",
                    "Grande desperdício de água e irrigação manual.",
                    high ? Colors.redAccent : azulRoyal,
                    high,
                    f,
                  ),
                ),
                Expanded(
                  child: buildBox(
                    "Nossa Solução",
                    "Controle automático inteligente e sustentável.",
                    high ? Colors.greenAccent : azulRoyal,
                    high,
                    f,
                  ),
                ),
              ],
            ),
          ),

          // ESCOPO
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle("Tecnologia Utilizada", high, f),

                const SizedBox(height: 12),

                Text(
                  "A HydroFlow utiliza ESP32, sensores capacitivos e integração IoT para automatizar processos agrícolas.",
                  style: TextStyle(
                    fontSize: 15 * f,
                    color: high ? DarkPalette.textSecondary : Colors.black87,
                  ),
                ),

                const SizedBox(height: 18),

                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    decoration: BoxDecoration(
                      border: high ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5) : null,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Image.asset("assets/images/diagrama.png"),
                  ),
                ),
              ],
            ),
          ),

          // SOLUÇÕES
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: _sectionTitle("Nossas Soluções", high, f),
          ),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(18),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              buildService("📡", "Monitoramento IoT", high, f),
              buildService("📱", "Gestão Remota", high, f),
              buildService("⚙️", "Automação", high, f),
              buildService("📉", "Eficiência", high, f),
              buildService("🔔", "Alertas", high, f),
              buildService("🌱", "Sustentabilidade", high, f),
            ],
          ),

          // COMO FUNCIONA
          Container(
            margin: const EdgeInsets.all(18),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: high ? DarkPalette.surface : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: high ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5) : null,
              boxShadow: high
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                      ),
                    ],
            ),
            child: Column(
              children: [
                Text(
                  "Como funciona?",
                  style: TextStyle(
                    fontSize: 24 * f,
                    fontWeight: FontWeight.bold,
                    color: high ? Colors.cyanAccent : azulPrimario,
                  ),
                ),

                const SizedBox(height: 20),

                buildStep("1", "Conexão dos Sensores", high, f),
                buildStep("2", "Envio para a Nuvem", high, f),
                buildStep("3", "Irrigação Inteligente", high, f),
              ],
            ),
          ),

          // PÚBLICO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                buildTag("Produtores", high, f),
                buildTag("Hortas", high, f),
                buildTag("Microempresas", high, f),
                buildTag("Condomínios", high, f),
                buildTag("Agronegócio", high, f),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // FOOTER
          Container(
            padding: const EdgeInsets.all(30),
            color: high ? DarkPalette.surface : azulRoyal,
            child: Center(
              child: Text(
                "© 2026 HydroFlow • Tecnologia Sustentável",
                style: TextStyle(
                  color: high ? DarkPalette.textSecondary : Colors.white70,
                  fontSize: 13 * f,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text, bool high, double f) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24 * f,
        fontWeight: FontWeight.bold,
        color: high ? Colors.cyanAccent : azulCyan.withOpacity(1),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
    bool high,
    double f,
  ) {
    return ListTile(
      leading: Icon(icon, color: high ? Colors.cyanAccent : Colors.black54),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16 * f,
          color: high ? DarkPalette.textPrimary : Colors.black87,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }

  Widget buildCard(IconData icon, String title, String desc, bool high, double f) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: high ? DarkPalette.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: high ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5) : null,
        boxShadow: high
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                ),
              ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        // Ícone agora com fundo circular colorido em vez de solto,
        // fica mais "produto premium" e ainda funciona no modo escuro.
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: high ? azulCyan.withOpacity(0.15) : azulRoyal.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: high ? Colors.cyanAccent : azulRoyal,
            size: 26,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15 * f,
            color: high ? DarkPalette.textPrimary : Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            desc,
            style: TextStyle(
              fontSize: 13 * f,
              color: high ? DarkPalette.textSecondary : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBox(String title, String desc, Color corBorda, bool high, double f) {
    return Container(
      constraints: const BoxConstraints(minHeight: 140),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: high ? DarkPalette.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: corBorda, width: 6),
          top: high ? BorderSide(color: DarkPalette.surfaceBorder) : BorderSide.none,
          right: high ? BorderSide(color: DarkPalette.surfaceBorder) : BorderSide.none,
          bottom: high ? BorderSide(color: DarkPalette.surfaceBorder) : BorderSide.none,
        ),
        boxShadow: high
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: high ? corBorda : azulPrimario,
              fontSize: 16 * f,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            style: TextStyle(
              fontSize: 13 * f,
              color: high ? DarkPalette.textSecondary : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildService(String icon, String title, bool high, double f) {
    return Container(
      decoration: BoxDecoration(
        color: high ? DarkPalette.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: high ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5) : null,
        boxShadow: high
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 34)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13 * f,
                color: high ? DarkPalette.textPrimary : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStep(String number, String title, bool high, double f) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: high ? Colors.cyanAccent : azulRoyal,
        child: Text(
          number,
          style: TextStyle(color: high ? DarkPalette.background : Colors.white),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14 * f,
          color: high ? DarkPalette.textPrimary : Colors.black87,
        ),
      ),
    );
  }

  Widget buildTag(String text, bool high, double f) {
    return Chip(
      label: Text(
        text,
        style: TextStyle(
          fontSize: 13 * f,
          color: high ? Colors.cyanAccent : azulPrimario,
        ),
      ),
      backgroundColor: high ? DarkPalette.surfaceElevated : azulCyan.withOpacity(0.2),
      side: high ? const BorderSide(color: DarkPalette.surfaceBorder) : BorderSide.none,
    );
  }
}