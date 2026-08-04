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

class SobreNos extends StatefulWidget {
  const SobreNos({super.key});

  @override
  State<SobreNos> createState() => _SobreNosState();
}

class _SobreNosState extends State<SobreNos> {
  static const Color azulPrimario = Color(0xFF002855);
  static const Color azulRoyal = Color(0xFF0056B3);
  static const Color azulCyan = Color(0xFF4DD0E1);

  @override
  Widget build(BuildContext context) {
    final accessibility = Provider.of<AccessibilityProvider>(context);

    final highContrast = accessibility.isHighContrast;
    final fontFactor = accessibility.fontSizeFactor;

    final bgColor = highContrast ? DarkPalette.background : const Color(0xFFF2F2F2);
    final cardColor = highContrast ? DarkPalette.surface : Colors.white;
    final textColor = highContrast ? Colors.cyanAccent : azulPrimario;
    final subTextColor = highContrast ? DarkPalette.textSecondary : Colors.grey.shade600;
    final appBarBg = highContrast ? DarkPalette.surface : azulPrimario;

    return Scaffold(
      backgroundColor: bgColor,

      // 🔷 APPBAR PADRÃO
      appBar: AppBar(
        backgroundColor: appBarBg,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        shape: highContrast
            ? const Border(bottom: BorderSide(color: DarkPalette.surfaceBorder, width: 2))
            : null,
        title: Text(
          "HYDROFLOW",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18 * fontFactor,
          ),
        ),
        actions: [
          const BotaoAcessibilidade(),
        ],
      ),

      // 🍔 MENU PADRÃO
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: highContrast
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [DarkPalette.background, DarkPalette.surface],
                  )
                : null,
            color: highContrast ? null : Colors.white,
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60, left: 16, bottom: 20),
                color: highContrast ? Colors.transparent : azulPrimario,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hydroflow",
                      style: TextStyle(
                        color: highContrast ? Colors.cyanAccent : Colors.white,
                        fontSize: 24 * fontFactor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Tecnologia no Campo",
                      style: TextStyle(
                        color: highContrast ? DarkPalette.textSecondary : azulCyan,
                        fontSize: 14 * fontFactor,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(color: highContrast ? DarkPalette.surfaceBorder : Colors.grey[200], height: 1),

              ListTile(
                leading: Icon(Icons.home, color: highContrast ? Colors.cyanAccent : Colors.black54),
                title: Text(
                  "Início",
                  style: TextStyle(
                    fontSize: 15 * fontFactor,
                    color: highContrast ? DarkPalette.textPrimary : Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),

              ListTile(
                leading: Icon(Icons.info, color: highContrast ? Colors.cyanAccent : Colors.black54),
                title: Text(
                  "Sobre",
                  style: TextStyle(
                    fontSize: 15 * fontFactor,
                    color: highContrast ? DarkPalette.textPrimary : Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/sobre');
                },
              ),

              ListTile(
                leading: Icon(Icons.login, color: highContrast ? Colors.cyanAccent : Colors.black54),
                title: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 15 * fontFactor,
                    color: highContrast ? DarkPalette.textPrimary : Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔥 HERO
            Stack(
              children: [
                Image.asset(
                  'assets/images/irrigador.jpeg',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.75),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Equipe Técnica",
                          style: TextStyle(
                            color: azulCyan,
                            fontSize: 28 * fontFactor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Unindo engenharia e software para um futuro sustentável.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 13 * fontFactor),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 30),

            Text(
              "Nossa Equipe",
              style: TextStyle(
                fontSize: 24 * fontFactor,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            Container(
              height: 3,
              width: 50,
              color: azulCyan,
              margin: const EdgeInsets.only(top: 8),
            ),

            const SizedBox(height: 20),

            // 👥 GRID DA EQUIPE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
                children: [
                  _buildTeamCard(
                    "Mariana Ribeiro",
                    "PO / Back-End",
                    "assets/images/mariana.jpeg",
                    cardColor,
                    textColor,
                    subTextColor,
                    fontFactor,
                    highContrast,
                  ),
                  _buildTeamCard(
                    "Ana Rita Boiago",
                    "SM / Back-End",
                    "assets/images/anarita.jpeg",
                    cardColor,
                    textColor,
                    subTextColor,
                    fontFactor,
                    highContrast,
                  ),
                  _buildTeamCard(
                    "Giulia Ribeiro",
                    "Analista de Sistemas e Designer",
                    "assets/images/giulia.jpeg",
                    cardColor,
                    textColor,
                    subTextColor,
                    fontFactor,
                    highContrast,
                  ),
                  _buildTeamCard(
                    "Rubens Neto",
                    "Analista de Sistemas e Designer",
                    "assets/images/rubens.jpeg",
                    cardColor,
                    textColor,
                    subTextColor,
                    fontFactor,
                    highContrast,
                  ),
                  _buildTeamCard(
                    "Diego Bortolotti",
                    "Full-Stack",
                    "assets/images/diego.jpeg",
                    cardColor,
                    textColor,
                    subTextColor,
                    fontFactor,
                    highContrast,
                  ),
                  _buildTeamCard(
                    "Felipe Ribeiro",
                    "Full-Stack",
                    "assets/images/felipe.jpeg",
                    cardColor,
                    textColor,
                    subTextColor,
                    fontFactor,
                    highContrast,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 📌 FOOTER
            Container(
              padding: const EdgeInsets.all(30),
              color: highContrast ? DarkPalette.surface : azulRoyal,
              child: Center(
                child: Text(
                  "© 2026 HydroFlow • Tecnologia Sustentável",
                  style: TextStyle(
                    color: highContrast ? DarkPalette.textSecondary : Colors.white70,
                    fontSize: 13 * fontFactor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamCard(
    String name,
    String role,
    String imagePath,
    Color cardColor,
    Color nameColor,
    Color roleColor,
    double fontFactor,
    bool highContrast,
  ) {
    return Card(
      color: cardColor,
      elevation: highContrast ? 0 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: highContrast
            ? const BorderSide(color: DarkPalette.surfaceBorder, width: 1.5)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 38,
              backgroundColor: highContrast ? Colors.cyanAccent : azulRoyal,
              child: CircleAvatar(
                radius: 34,
                backgroundImage: AssetImage(imagePath),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14 * fontFactor,
                color: nameColor,
              ),
            ),

            Text(
              role,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11 * fontFactor,
                color: roleColor,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.business,
                    size: 18,
                    color: highContrast ? Colors.cyanAccent : const Color(0xFF0077B5),
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    Icons.code,
                    size: 18,
                    color: highContrast ? DarkPalette.textPrimary : Colors.black,
                  ),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}