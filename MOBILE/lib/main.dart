import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importações dos arquivos de acessibilidade
import 'accessibility_provider.dart';
import 'botao_acessibilidade.dart';

import 'home.dart';
import 'login.dart';
import 'sobre_nos.dart';
import 'dashboard.dart';
import 'esqueci_senha.dart';
import 'cadastro_planta.dart';
import 'plantas.dart';
import 'sensores.dart';
import 'historico.dart';
import 'relatorio_dados_sensores.dart';

void main() {
  runApp(
    // 1. Envolvemos o app com o Provider para gerenciar o estado global
    ChangeNotifierProvider(
      create: (_) => AccessibilityProvider(),
      child: const HydroflowApp(),
    ),
  );
}

class HydroflowApp extends StatelessWidget {
  const HydroflowApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Escutamos as mudanças de acessibilidade
    final accessibility = Provider.of<AccessibilityProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hydroflow',
      
      // 3. Gerenciamento dinâmico de tema (Alto Contraste vs Padrão)
      theme:  ThemeData(
              fontFamily: 'Poppins',
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF002855),
              ),
            ),

      // 4. O segredo para funcionar em TODAS as páginas:
      // O builder aplica o fator de escala de texto globalmente.
      builder: (context, child) {
        final mq = MediaQuery.of(context);

        // Na web mobile (iPhone), o Flutter às vezes não recebe a área segura
        // (padding.top == 0) e a AppBar fica por baixo da ilha/status bar.
        // Este fallback corrige TODAS as telas de uma vez.
        const double topoIphone = 47;
        final precisaFallback = kIsWeb &&
            defaultTargetPlatform == TargetPlatform.iOS &&
            mq.padding.top == 0;

        return MediaQuery(
          data: mq.copyWith(
            textScaler: TextScaler.linear(accessibility.fontSizeFactor),
            padding: precisaFallback
                ? mq.padding.copyWith(top: topoIphone)
                : mq.padding,
            viewPadding: precisaFallback
                ? mq.viewPadding.copyWith(top: topoIphone)
                : mq.viewPadding,
          ),
          child: child!,
        );
      },

      home: const Home(),

      routes: {
        '/home': (context) => const Home(),
        '/login': (context) => const LoginMobilePage(),
        '/sobre': (context) => const SobreNos(),
        '/dashboard': (context) => const DashboardPage(),
        '/nova_senha': (context) => const NovaSenhaPage(),
        '/cadastro_plantas': (context) => const CadastroPlantaPage(),
        '/plantas': (context) => const PlantasPage(),
        '/equipamentos': (context) => const RelatoriodispositivosPage(),
        '/historico': (context) => const HistoricoPage(),
        '/dados_sensores': (context) => const Relatoriodados_sensoresPage()
      },
    );
  }
}