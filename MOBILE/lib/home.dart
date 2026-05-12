import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static const Color azulPrimario = Color(0xFF002855);
  static const Color azulRoyal = Color(0xFF0056B3);
  static const Color azulCyan = Color(0xFF4DD0E1);
  static const Color offWhite = Color(0xFFF5F6FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,

      appBar: AppBar(
        backgroundColor: azulPrimario,
        elevation: 0,
        title: const Text(
          "HYDROFLOW",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 60,
                left: 20,
                bottom: 25,
              ),
              color: azulPrimario,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "HydroFlow",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Tecnologia no Campo",
                    style: TextStyle(
                      color: azulCyan,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _drawerItem(
                      context,
                      Icons.home,
                      "Início",
                      '/',
                    ),
                    _drawerItem(
                      context,
                      Icons.info,
                      "Sobre",
                      '/sobre',
                    ),
                    _drawerItem(
                      context,
                      Icons.login,
                      "Login",
                      '/login',
                    ),
                    _drawerItem(
                      context,
                      Icons.person_add,
                      "Cadastro",
                      '/cadastro',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      body: ListView(
        children: [
          // HERO (Botão Removido)
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                "assets/images/irrigador.jpeg",
                height: 280,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              Container(
                height: 280,
                color: Colors.black.withOpacity(0.55),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Text(
                      "HydroFlow",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 42,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Sistema inteligente de irrigação automática",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: azulCyan,
                        fontSize: 18,
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
                const Text(
                  "Benefícios da Plataforma",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: azulPrimario,
                  ),
                ),

                const SizedBox(height: 20),

                buildCard(
                  Icons.water_drop,
                  "Economia de Água",
                  "Controle inteligente para evitar desperdícios.",
                ),

                buildCard(
                  Icons.sync,
                  "Automação Total",
                  "Irrigação automática baseada em sensores.",
                ),

                buildCard(
                  Icons.analytics,
                  "Monitoramento em Tempo Real",
                  "Acompanhe informações diretamente do sistema.",
                ),

                buildCard(
                  Icons.security,
                  "Confiabilidade",
                  "Tecnologia segura e estável para produção agrícola.",
                ),
              ],
            ),
          ),

          // DESAFIO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: buildBox(
                    "O Problema",
                    "Grande desperdício de água e irrigação manual.",
                    azulRoyal,
                  ),
                ),

                Expanded(
                  child: buildBox(
                    "Nossa Solução",
                    "Controle automático inteligente e sustentável.",
                    azulCyan,
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
                const Text(
                  "Tecnologia Utilizada",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: azulPrimario,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "A HydroFlow utiliza ESP32, sensores capacitivos e integração IoT para automatizar processos agrícolas.",
                  style: TextStyle(fontSize: 15),
                ),

                const SizedBox(height: 18),

                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    "assets/images/diagrama.png",
                  ),
                ),
              ],
            ),
          ),

          // SOLUÇÕES
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              "Nossas Soluções",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: azulPrimario,
              ),
            ),
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
              buildService("📡", "Monitoramento IoT"),
              buildService("📱", "Gestão Remota"),
              buildService("⚙️", "Automação"),
              buildService("📉", "Eficiência"),
              buildService("🔔", "Alertas"),
              buildService("🌱", "Sustentabilidade"),
            ],
          ),

          // COMO FUNCIONA
          Container(
            margin: const EdgeInsets.all(18),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  "Como funciona?",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: azulPrimario,
                  ),
                ),

                const SizedBox(height: 20),

                buildStep("1", "Conexão dos Sensores"),
                buildStep("2", "Envio para a Nuvem"),
                buildStep("3", "Irrigação Inteligente"),
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
                buildTag("Produtores"),
                buildTag("Hortas"),
                buildTag("Microempresas"),
                buildTag("Condomínios"),
                buildTag("Agronegócio"),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // FOOTER
          Container(
            padding: const EdgeInsets.all(30),
            color: azulPrimario,
            child: const Center(
              child: Text(
                "© 2026 HydroFlow • Tecnologia Sustentável",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }

  Widget buildCard(IconData icon, String title, String desc) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          icon,
          color: azulRoyal,
          size: 34,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(desc),
        ),
      ),
    );
  }

  Widget buildBox(String title, String desc, Color corBorda) {
    return Container(
      height: 140,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: corBorda,
            width: 6,
          ),
        ),
        boxShadow: [
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: azulPrimario,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            desc,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget buildService(String icon, String title) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 34),
            ),

            const SizedBox(height: 12),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStep(String number, String title) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: azulRoyal,
        child: Text(
          number,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildTag(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: azulCyan.withOpacity(0.2),
      side: BorderSide.none,
    );
  }
}