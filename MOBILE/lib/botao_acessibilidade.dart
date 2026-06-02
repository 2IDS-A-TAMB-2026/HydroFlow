import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'accessibility_provider.dart';

class BotaoAcessibilidade extends StatelessWidget {
  const BotaoAcessibilidade({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuta o provider (listen: false pois só queremos disparar funções aqui)
    final acc = Provider.of<AccessibilityProvider>(context, listen: false);

    return PopupMenuButton<String>(
      icon: const Icon(Icons.accessibility_new_rounded, color: Colors.white),
      tooltip: "Opções de Acessibilidade",
      onSelected: (valor) {
        if (valor == 'maior') acc.aumentarTexto();
        if (valor == 'menor') acc.diminuirTexto();
        if (valor == 'contraste') acc.alternarContraste();
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'maior',
          child: ListTile(leading: Icon(Icons.text_increase), title: Text("Aumentar Texto")),
        ),
        const PopupMenuItem(
          value: 'menor',
          child: ListTile(leading: Icon(Icons.text_decrease), title: Text("Diminuir Texto")),
        ),
        const PopupMenuItem(
          value: 'contraste',
          child: ListTile(leading: Icon(Icons.contrast), title: Text("Preto e Branco")),
        ),
      ],
    );
  }
}