import 'package:flutter/material.dart';

// Importações originais
import 'home.dart';
import 'login.dart';
import 'sobre_nos.dart';
import 'cadastro.dart';
import 'dashboard.dart';
import 'esqueci_senha.dart';

import 'agendamento.dart';
import 'cadastro_planta.dart';
import 'plantas.dart';
import 'equipamentos.dart';
import 'historico.dart';

void main() {
  runApp(const HydroflowApp());
}

class HydroflowApp extends StatelessWidget {
  const HydroflowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hydroflow',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF002855),
        ),
      ),

      // Tela inicial
      home: const Home(),

      routes: {
        '/home': (context) => const Home(),
        '/login': (context) => const LoginMobilePage(),
        '/sobre': (context) => const SobreNos(),
        '/cadastro': (context) => const CadastroPage(),
        '/dashboard': (context) => const DashboardPage(),

        '/nova_senha': (context) => const NovaSenhaPage(),

        // OUTRAS ROTAS
        '/agendamentos': (context) => const AgendamentoPage(),
        '/cadastro_plantas': (context) => const CadastroPlantaPage(),
        '/plantas': (context) => const PlantasPage(),
        '/equipamentos': (context) => const EquipamentosPage(),
        '/historico': (context) => const HistoricoPage()
      },
    );
  }
}