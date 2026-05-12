import 'package:flutter/material.dart';

class SobreNos extends StatefulWidget {
  const SobreNos({super.key});

  @override
  State<SobreNos> createState() => _SobreNosState();
}

class _SobreNosState extends State<SobreNos> {
  bool highContrast = false;

  static const Color azulPrimario = Color(0xFF002855);
  static const Color azulRoyal = Color(0xFF0056B3);
  static const Color azulCyan = Color(0xFF4DD0E1);

  @override
  Widget build(BuildContext context) {
    final bgColor = highContrast ? Colors.black : const Color(0xFFF2F2F2);
    final cardColor = highContrast ? Colors.black : Colors.white;
    final textColor = highContrast ? Colors.yellow : azulPrimario;
    final subTextColor =
        highContrast ? Colors.white : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bgColor,

      // 🔷 APPBAR PADRÃO
      appBar: AppBar(
        backgroundColor: azulPrimario,
        title: const Text(
          "HYDROFLOW",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              highContrast ? Icons.light_mode : Icons.contrast,
            ),
            onPressed: () {
              setState(() {
                highContrast = !highContrast;
              });
            },
          )
        ],
      ),

      // 🍔 MENU PADRÃO
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: azulPrimario,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hydroflow",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "Tecnologia no Campo",
                    style: TextStyle(color: azulCyan),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Início"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),

            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("Sobre"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/sobre');
              },
            ),

            ListTile(
              leading: const Icon(Icons.login),
              title: const Text("Login"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),

            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text("Cadastro"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/cadastro');
              },
            ),
          ],
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
                  color: Colors.black.withOpacity(0.6),
                ),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),

                      Text(
                        "Equipe Técnica",
                        style: TextStyle(
                          color: azulCyan,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Unindo engenharia e software para um futuro sustentável.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 30),

            Text(
              "Nossa Equipe",
              style: TextStyle(
                fontSize: 24,
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
                  ),

                  _buildTeamCard(
                    "Ana Rita Boiago",
                    "SM / Back-End",
                    "assets/images/anarita.jpeg",
                    cardColor,
                    textColor,
                    subTextColor,
                  ),

                  _buildTeamCard(
                    "Giulia Ribeiro",
                    "Analista de Sistemas e Designer",
                    "assets/images/giulia.jpeg",
                    cardColor,
                    textColor,
                    subTextColor,
                  ),

                  _buildTeamCard(
                    "Rubens Neto",
                    "Analista de Sistemas e Designer",
                    "assets/images/rubens.jpeg",
                    cardColor,
                    textColor,
                    subTextColor,
                  ),

                  _buildTeamCard(
                    "Diego Bortolotti",
                    "Full-Stack",
                    "assets/images/diego.jpeg",
                    cardColor,
                    textColor,
                    subTextColor,
                  ),

                  _buildTeamCard(
                    "Felipe Ribeiro",
                    "Full-Stack",
                    "assets/images/felipe.jpeg",
                    cardColor,
                    textColor,
                    subTextColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 📌 FOOTER
            Container(
              padding: const EdgeInsets.all(30),
              color: highContrast ? Colors.black : Colors.grey[300],
              width: double.infinity,
              child: Text(
                "© 2026 Hydroflow - Gestão de Recursos Hídricos.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: textColor,
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
  ) {
    return Card(
      color: cardColor,
      elevation: 4,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: highContrast
            ? const BorderSide(
                color: Colors.yellow,
                width: 2,
              )
            : BorderSide.none,
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: azulRoyal,

            child: CircleAvatar(
              radius: 34,
              backgroundImage: AssetImage(imagePath),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: nameColor,
            ),
          ),

          Text(
            role,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: roleColor,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.business,
                  size: 18,
                  color: Color(0xFF0077B5),
                ),
                onPressed: () {},
              ),

              IconButton(
                icon: Icon(
                  Icons.code,
                  size: 18,
                  color:
                      highContrast ? Colors.white : Colors.black,
                ),
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}