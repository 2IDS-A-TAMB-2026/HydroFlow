import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static const Color azulPrimario = Color(0xFF002855);
  static const Color azulRoyal = Color(0xFF0056B3);
  static const Color azulCyan = Color(0xFF4DD0E1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: azulPrimario,
        title: const Text(
          "HYDROFLOW",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // ✅ MENU PADRÃO
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: azulPrimario),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hydroflow",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
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
                Navigator.pushReplacementNamed(context, '/');
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

      body: ListView(
        children: [
          // HERO
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                "assets/images/irrigador.jpeg",
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                height: 250,
                color: Colors.black.withOpacity(0.5),
              ),
              Column(
                children: [
                  const Text("Hydroflow",
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  Text("Sistema de Irrigação automática!",
                      style: TextStyle(color: azulCyan, fontSize: 18)),
                ],
              )
            ],
          ),

          // CARDS
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                buildCard(Icons.water_drop, "Automação Fluida",
                    "Sistemas que eliminam falhas e desperdícios."),
                buildCard(Icons.sync, "Constância Flow",
                    "Irrigação no tempo certo e medida exata."),
                buildCard(Icons.security, "Solidez e Confiança",
                    "Tecnologia segura para o campo."),
              ],
            ),
          ),

          // DESAFIO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: buildBox(
                      "O Desafio",
                      "Desperdício de água e dependência manual.",
                      azulRoyal),
                ),
                Expanded(
                  child: buildBox(
                      "Nossa Resposta",
                      "Monitoramento inteligente em tempo real.",
                      azulCyan),
                ),
              ],
            ),
          ),

          // ESCOPO
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Escopo do Projeto",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text(
                    "Sistema baseado em IoT com ESP32 e sensores capacitivos."),
                const SizedBox(height: 15),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset("assets/images/diagrama.png"),
                ),
              ],
            ),
          ),

          // GRID
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("Nossas Soluções",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              buildService("📡", "Monitoramento IoT"),
              buildService("📱", "Gestão Remota"),
              buildService("⚙️", "Controle Híbrido"),
              buildService("📉", "Eficiência"),
              buildService("🔔", "Alertas"),
              buildService("🌱", "Sustentabilidade"),
            ],
          ),

          // COMO FUNCIONA
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text("Como funciona?",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                buildStep("1", "Conexão do Hardware"),
                buildStep("2", "Sincronização Nuvem"),
                buildStep("3", "Automação Inteligente"),
              ],
            ),
          ),

          // TAGS
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Wrap(
              spacing: 10,
              alignment: WrapAlignment.center,
              children: [
                buildTag("Microempresas"),
                buildTag("Produtores"),
                buildTag("Hortas"),
                buildTag("Condomínios"),
              ],
            ),
          ),

          // FOOTER
          Container(
            padding: const EdgeInsets.all(30),
            color: azulPrimario,
            child: const Center(
              child: Text(
                "© 2026 Hydroflow - Tecnologia Sustentável",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCard(IconData icon, String title, String desc) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(icon, color: azulRoyal, size: 30),
        title:
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc),
      ),
    );
  }

  Widget buildBox(String title, String desc, Color corBorda) {
    return Container(
      height: 120,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: corBorda, width: 5)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: azulPrimario)),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget buildService(String icon, String title) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 10),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget buildStep(String number, String title) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: azulRoyal,
        child: Text(number, style: const TextStyle(color: Colors.white)),
      ),
      title:
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
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
