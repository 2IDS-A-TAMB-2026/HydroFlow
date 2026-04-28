import 'package:flutter/material.dart';
import 'package:tcc/dashboad_adm.dart';
import 'package:tcc/login_admin.dart';

// Importações originais
import 'home.dart';
import 'login.dart';
import 'sobre_nos.dart';
import 'cadastro.dart';
import 'dashboard.dart';

// 🔥 Importações que você deve garantir que estão aqui
import 'agendamento.dart';
import 'cadastro_planta.dart';
import 'plantas.dart';
import 'equipamentos.dart';
import 'historico.dart'; // Certifique-se de ter criado este arquivo também
import 'dashboad_adm.dart';

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
        
        // 🔥 ADICIONE ESTAS ROTAS PARA O MENU FUNCIONAR:
        '/agendamentos': (context) => const AgendamentoPage(),
        '/cadastro_plantas': (context) => const CadastroPlantaPage(),
        '/plantas': (context) => const PlantasPage(),
        '/equipamentos': (context) => const EquipamentosPage(),
        '/historico': (context) => const HistoricoPage(),
        '/login_admin': (context) => const LoginAdminPage(),
        '/dashboard_admin': (context) => const DashboardAdminPage(),
      },
    );
  }
}