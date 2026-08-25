import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EquipamentosPage extends StatefulWidget {
  const EquipamentosPage({super.key});

  @override
  State<EquipamentosPage> createState() => _EquipamentosPageState();
}

class _EquipamentosPageState extends State<EquipamentosPage> {
  String jsonResultado = '';

  bool carregando = true;

  static const String baseUrl =
      'http://10.141.130.54/HydroFlow/public/api';

  @override
  void initState() {
    super.initState();

    getEquipamentos();
  }

  Future<void> getEquipamentos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sensores'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Pega o JSON da API
        final dados = jsonDecode(response.body);

        // Formata o JSON para aparecer bonitinho na tela
        final jsonFormatado =
            const JsonEncoder.withIndent('  ').convert(dados);

        setState(() {
          jsonResultado = jsonFormatado;
          carregando = false;
        });
      } else {
        setState(() {
          jsonResultado =
              'Erro ${response.statusCode}\n\n${response.body}';

          carregando = false;
        });
      }
    } catch (e) {
      setState(() {
        jsonResultado =
            'Erro ao conectar com a API:\n\n$e';

        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipamentos'),
      ),

      body: carregando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),

              child: SelectableText(
                jsonResultado,

                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'monospace',
                ),
              ),
            ),
    );
  }
}