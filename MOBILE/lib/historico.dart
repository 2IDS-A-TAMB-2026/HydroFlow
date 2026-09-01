// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:provider/provider.dart';
// import 'accessibility_provider.dart';
// import 'package:tcc/botao_acessibilidade.dart';

// // ==========================================================
// // PALETA DO MODO ESCURO
// // ==========================================================

// class DarkPalette {
//   static const Color background = Color(0xFF0A1A2B);
//   static const Color surface = Color(0xFF10263D);
//   static const Color surfaceElevated = Color(0xFF16324B);
//   static const Color surfaceBorder = Color(0xFF1E3B57);
//   static const Color textPrimary = Color(0xFFF2F6FA);
//   static const Color textSecondary = Color(0xFFA9C0D6);
// }

// class RelatoriohistoricoPage extends StatefulWidget {
//   const RelatoriohistoricoPage({super.key});

//   @override
//   State<RelatoriohistoricoPage> createState() =>
//       _RelatoriohistoricoPageState();
// }

// class _RelatoriohistoricoPageState
//     extends State<RelatoriohistoricoPage> {

//   final ScrollController horizontalController =
//       ScrollController();

//   // Lista que armazenará os históricos da API
//   List<dynamic> historico = [];

//   bool carregando = true;

//   String? erro;

//   static const azul = Color(0xFF002855);

//   @override
//   void initState() {
//     super.initState();
//     consultarHistorico();
//   }

//   // ==========================================================
//   // CONSULTAR HISTÓRICO
//   // ==========================================================

//   Future<void> consultarHistorico() async {
//     try {
//       final resposta = await http.get(
//         Uri.parse(
//           'http://10.141.130.50/HydroFlow/public/api/historico',
//         ),
//         headers: {
//           'Accept': 'application/json',
//         },
//       );

//       final resultado = jsonDecode(resposta.body);

//       if (resposta.statusCode == 200) {
//         setState(() {
//           historico = resultado['data'] ?? [];
//           carregando = false;
//           erro = null;
//         });
//       } else {
//         setState(() {
//           erro = resultado['message'] ??
//               'Erro ao consultar histórico';
//           carregando = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         erro = 'Erro ao acessar API: $e';
//         carregando = false;
//       });
//     }
//   }

//   // ==========================================================
//   // EXCLUIR HISTÓRICO
//   // ==========================================================

//   Future<void> excluirHistorico(dynamic historicoID) async {
//     try {
//       final resposta = await http.delete(
//         Uri.parse(
//           'http://10.141.130.50/HydroFlow/public/api/historico/$historicoID',
//         ),
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//         },
//       );

//       dynamic resultado = {};

//       if (resposta.body.isNotEmpty) {
//         resultado = jsonDecode(resposta.body);
//       }

//       if (resposta.statusCode == 200 ||
//           resposta.statusCode == 201 ||
//           resposta.statusCode == 204) {

//         if (!mounted) return;

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text(
//               'Histórico excluído com sucesso!',
//             ),
//           ),
//         );

//         await consultarHistorico();
//       } else {
//         if (!mounted) return;

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Erro ao excluir histórico: '
//               '${resultado['message'] ?? 'Erro desconhecido'}',
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Erro ao acessar API: $e',
//           ),
//         ),
//       );
//     }
//   }

//   // ==========================================================
//   // BUILD
//   // ==========================================================

//   @override
//   Widget build(BuildContext context) {

//     // Acessibilidade
//     final acc = Provider.of<AccessibilityProvider>(context);

//     final high = acc.isHighContrast;
//     final f = acc.fontSizeFactor;

//     // Cores da tela
//     final bgPage =
//         high ? DarkPalette.background : Colors.grey[100];

//     final appBarBg =
//         high ? DarkPalette.surface : azul;

//     final appBarBorder = high
//         ? const BorderSide(
//             color: DarkPalette.surfaceBorder,
//             width: 2,
//           )
//         : BorderSide.none;

//     return Scaffold(

//       backgroundColor: bgPage,

//       // ========================================================
//       // APP BAR
//       // ========================================================

//       appBar: AppBar(
//         title: Text(
//           'Relatório de histórico',
//           style: TextStyle(
//             fontSize: 20 * f,
//           ),
//           overflow: TextOverflow.ellipsis,
//         ),

//         backgroundColor: appBarBg,

//         foregroundColor: Colors.white,

//         elevation: 0,

//         shape: Border(
//           bottom: appBarBorder,
//         ),

//         actions: [
//           IconButton(
//             onPressed: () {
//               setState(() {
//                 carregando = true;
//                 erro = null;
//               });

//               consultarHistorico();
//             },
//             icon: const Icon(Icons.refresh),
//           ),

//           const BotaoAcessibilidade(),
//         ],
//       ),

//       // ========================================================
//       // BODY
//       // ========================================================

//       body: carregando

//           // CARREGANDO
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )

//           // ERRO
//           : erro != null
//               ? Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Text(
//                       erro!,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: high
//                             ? DarkPalette.textPrimary
//                             : Colors.red,
//                         fontSize: 16 * f,
//                       ),
//                     ),
//                   ),
//                 )

//           // SEM DADOS
//           : historico.isEmpty
//               ? Center(
//                   child: Text(
//                     'Nenhum histórico encontrado.',
//                     style: TextStyle(
//                       color: high
//                           ? DarkPalette.textPrimary
//                           : Colors.black87,
//                       fontSize: 16 * f,
//                     ),
//                   ),
//                 )

//           // TABELA
//           : Padding(
//               padding: const EdgeInsets.all(24),

//               child: Scrollbar(
//                 controller: horizontalController,
//                 thumbVisibility: true,
//                 trackVisibility: true,
//                 scrollbarOrientation:
//                     ScrollbarOrientation.bottom,

//                 child: SingleChildScrollView(
//                   controller: horizontalController,
//                   scrollDirection: Axis.horizontal,

//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: high
//                           ? DarkPalette.surface
//                           : Colors.white,

//                       borderRadius:
//                           BorderRadius.circular(12),

//                       border: high
//                           ? Border.all(
//                               color:
//                                   DarkPalette.surfaceBorder,
//                               width: 1.5,
//                             )
//                           : null,
//                     ),

//                     padding: const EdgeInsets.all(16),

//                     child: DataTable(

//                       // ==================================================
//                       // CABEÇALHO
//                       // ==================================================

//                       headingRowColor:
//                           WidgetStateProperty.all(
//                         high
//                             ? DarkPalette.surfaceElevated
//                             : const Color(0xFFE7F0F2),
//                       ),

//                       headingTextStyle: TextStyle(
//                         color: high
//                             ? Colors.cyanAccent
//                             : azul,
//                         fontWeight:
//                             FontWeight.bold,
//                         fontSize: 14 * f,
//                       ),

//                       dataTextStyle: TextStyle(
//                         color: high
//                             ? DarkPalette.textSecondary
//                             : Colors.black87,
//                         fontSize: 13 * f,
//                       ),

//                       border: TableBorder.all(
//                         color: high
//                             ? DarkPalette.surfaceBorder
//                             : const Color(0xFFE0E5E7),

//                         borderRadius:
//                             BorderRadius.circular(8),
//                       ),

//                       // ==================================================
//                       // COLUNAS
//                       // ==================================================

//                       columns: const [

//                         DataColumn(
//                           label: Text('ID'),
//                         ),

//                         DataColumn(
//                           label: Text('DATA'),
//                         ),

//                         DataColumn(
//                           label: Text('HORA'),
//                         ),

//                         DataColumn(
//                           label: Text('DURAÇÃO'),
//                         ),

//                         DataColumn(
//                           label: Text('VOLUME'),
//                         ),

//                         DataColumn(
//                           label: Text('ACIONAMENTO'),
//                         ),

//                         DataColumn(
//                           label: Text('STATUS'),
//                         ),

//                         DataColumn(
//                           label: Text('PLANTA'),
//                         ),

//                         DataColumn(
//                           label: Text('DISPOSITIVO'),
//                         ),

//                         DataColumn(
//                           label: Text('Ações'),
//                         ),
//                       ],

//                       // ==================================================
//                       // LINHAS
//                       // ==================================================

//                       rows: historico
//                           .map<DataRow>((registro) {

//                         return DataRow(
//                           cells: [

//                             // ID
//                             DataCell(
//                               Text(
//                                 '${registro['IRR_ID'] ?? ''}',
//                               ),
//                             ),

//                             // DATA
//                             DataCell(
//                               Text(
//                                 '${registro['IRR_DATA'] ?? ''}',
//                               ),
//                             ),

//                             // HORA
//                             DataCell(
//                               Text(
//                                 '${registro['IRR_HORA'] ?? ''}',
//                               ),
//                             ),

//                             // DURAÇÃO
//                             DataCell(
//                               Text(
//                                 '${registro['IRR_DURACAO'] ?? ''} min',
//                               ),
//                             ),

//                             // VOLUME
//                             DataCell(
//                               Text(
//                                 '${registro['IRR_VOLUME'] ?? ''} L',
//                               ),
//                             ),

//                             // ACIONAMENTO
//                             DataCell(
//                               Row(
//                                 mainAxisSize:
//                                     MainAxisSize.min,
//                                 children: [

//                                   Icon(
//                                     registro[
//                                                 'IRR_ACIONAMENTO'] ==
//                                             'Automático'
//                                         ? Icons.smart_toy
//                                         : Icons.touch_app,

//                                     size: 17,

//                                     color: high
//                                         ? DarkPalette
//                                             .textSecondary
//                                         : Colors.black54,
//                                   ),

//                                   const SizedBox(width: 5),

//                                   Text(
//                                     '${registro['IRR_ACIONAMENTO'] ?? ''}',
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             // STATUS
//                             DataCell(
//                               _statusWidget(
//                                 registro[
//                                         'IRR_STATUS'] ??
//                                     '',
//                                 high,
//                                 f,
//                               ),
//                             ),

//                             // PLANTA
//                             DataCell(
//                               Text(
//                                 '${registro['FK_PLANTA_ID'] ?? ''}',
//                               ),
//                             ),

//                             // DISPOSITIVO
//                             DataCell(
//                               Text(
//                                 '${registro['FK_DIS_ID'] ?? ''}',
//                               ),
//                             ),

//                             // AÇÕES
//                             DataCell(
//                               Row(
//                                 children: [

//                                   // EDITAR
//                                   IconButton(
//                                     icon: const Icon(
//                                       Icons.edit,
//                                       color: Color.fromARGB(
//                                         255,
//                                         3,
//                                         83,
//                                         148,
//                                       ),
//                                     ),

//                                     onPressed: () {

//                                       final id =
//                                           registro[
//                                               'IRR_ID'];

//                                       print(
//                                         'Editar histórico: $id',
//                                       );
//                                     },
//                                   ),

//                                   // EXCLUIR
//                                   IconButton(
//                                     icon: const Icon(
//                                       Icons.delete,
//                                       color: Colors.red,
//                                     ),

//                                     onPressed:
//                                         () async {

//                                       final id =
//                                           registro[
//                                               'IRR_ID'];

//                                       final confirmar =
//                                           await showDialog<
//                                               bool>(
//                                         context:
//                                             context,

//                                         builder:
//                                             (context) {

//                                           return AlertDialog(

//                                             backgroundColor:
//                                                 high
//                                                     ? DarkPalette
//                                                         .surface
//                                                     : null,

//                                             title:
//                                                 Text(
//                                               'Excluir histórico?',
//                                               style:
//                                                   TextStyle(
//                                                 color: high
//                                                     ? DarkPalette
//                                                         .textPrimary
//                                                     : null,
//                                               ),
//                                             ),

//                                             content:
//                                                 Text(
//                                               'Deseja excluir o histórico da irrigação ${registro['IRR_ID'] ?? ''}?',
//                                               style:
//                                                   TextStyle(
//                                                 color: high
//                                                     ? DarkPalette
//                                                         .textSecondary
//                                                     : null,
//                                               ),
//                                             ),

//                                             actions: [

//                                               TextButton(
//                                                 onPressed:
//                                                     () {
//                                                   Navigator.pop(
//                                                     context,
//                                                     false,
//                                                   );
//                                                 },
//                                                 child:
//                                                     const Text(
//                                                   'Cancelar',
//                                                 ),
//                                               ),

//                                               TextButton(
//                                                 onPressed:
//                                                     () {
//                                                   Navigator.pop(
//                                                     context,
//                                                     true,
//                                                   );
//                                                 },
//                                                 child:
//                                                     const Text(
//                                                   'Excluir',
//                                                   style:
//                                                       TextStyle(
//                                                     color:
//                                                         Colors.red,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           );
//                                         },
//                                       );

//                                       if (confirmar ==
//                                           true) {
//                                         await excluirHistorico(
//                                           id,
//                                         );
//                                       }
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }

//   // ==========================================================
//   // STATUS
//   // ==========================================================

//   Widget _statusWidget(
//     String status,
//     bool high,
//     double f,
//   ) {

//     Color statusColor;

//     if (status == 'Concluído') {
//       statusColor =
//           high ? Colors.greenAccent : Colors.green;
//     } else {
//       statusColor =
//           high ? Colors.redAccent : Colors.red;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 10,
//         vertical: 4,
//       ),

//       decoration: BoxDecoration(
//         color: high
//             ? statusColor.withOpacity(0.18)
//             : statusColor,

//         borderRadius:
//             BorderRadius.circular(20),

//         border: high
//             ? Border.all(
//                 color: statusColor,
//                 width: 1.5,
//               )
//             : null,
//       ),

//       child: Text(
//         status,
//         style: TextStyle(
//           color: high
//               ? statusColor
//               : Colors.white,

//           fontSize: 11 * f,

//           fontWeight:
//               FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _dados = [
    {
      "data": "14/04 - 06:00",
      "setor": "Estufa 1 (Tomate)",
      "duracao": "30 min",
      "volume": "150L",
      "icon": Icons.smart_toy,
      "tipo": "Automático",
      "status": "Concluído",
      "color": Colors.green,
    },
    {
      "data": "13/04 - 18:00",
      "setor": "Campo (Milho)",
      "duracao": "15 min",
      "volume": "250L",
      "icon": Icons.smart_toy,
      "tipo": "Automático",
      "status": "Falha",
      "color": Colors.red,
    },
    {
      "data": "13/04 - 14:30",
      "setor": "Estufa 2 (Morango)",
      "duracao": "45 min",
      "volume": "80L",
      "icon": Icons.touch_app,
      "tipo": "Manual",
      "status": "Concluído",
      "color": Colors.green,
    },
  ];

  String _query = "";
  static const azul = Color(0xFF002855);

  // ---------------- LOGOUT ----------------
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Escutando as configurações do Provider de acessibilidade
    final acc = Provider.of<AccessibilityProvider>(context);
    final high = acc.isHighContrast;
    final f = acc.fontSizeFactor;

    final bgPage = high ? DarkPalette.background : Colors.grey[100];
    final appBarBg = high ? DarkPalette.surface : azul;
    final appBarBorder = high
        ? const BorderSide(color: DarkPalette.surfaceBorder, width: 2)
        : BorderSide.none;

    return Scaffold(
      backgroundColor: bgPage,

      appBar: AppBar(
        title: Text(
          "Histórico de Ativações",
          style: TextStyle(fontSize: 20 * f),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: appBarBg,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: Border(bottom: appBarBorder),
        actions: const [BotaoAcessibilidade()],
      ),

      drawer: _buildDrawer(context, high, f),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFilterWidget(high, f),
            const SizedBox(height: 20),
            _buildHistoryTable(high, f),
          ],
        ),
      ),
    );
  }

  // ---------------- FILTROS ----------------
  Widget _buildFilterWidget(bool high, double f) {
    return Card(
      elevation: high ? 0 : 3,
      color: high ? DarkPalette.surface : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: high ? const BorderSide(color: DarkPalette.surfaceBorder, width: 1.5) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.filter_list, color: high ? Colors.cyanAccent : azul),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "Filtros de Busca",
                    style: TextStyle(
                      fontSize: 16 * f,
                      fontWeight: FontWeight.bold,
                      color: high ? DarkPalette.textPrimary : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _query = value.toLowerCase();
                });
              },
              style: TextStyle(color: high ? DarkPalette.textPrimary : Colors.black, fontSize: 14 * f),
              decoration: InputDecoration(
                hintText: "Buscar por setor, data ou status...",
                hintStyle: TextStyle(color: high ? DarkPalette.textSecondary : Colors.black38, fontSize: 14 * f),
                prefixIcon: Icon(Icons.search, color: high ? Colors.cyanAccent : Colors.black45),
                filled: true,
                fillColor: high ? DarkPalette.surfaceElevated : const Color(0xFFF5F7FA),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: high ? DarkPalette.surfaceBorder : Colors.grey.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: high ? Colors.cyanAccent : azul, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- TABELA ----------------
  Widget _buildHistoryTable(bool high, double f) {
    final filtrados = _dados.where((item) {
      return item["setor"].toLowerCase().contains(_query) ||
          item["status"].toLowerCase().contains(_query) ||
          item["data"].toLowerCase().contains(_query);
    }).toList();

    return Card(
      elevation: high ? 0 : 3,
      color: high ? DarkPalette.surface : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: high ? const BorderSide(color: DarkPalette.surfaceBorder, width: 1.5) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.assignment, color: high ? Colors.cyanAccent : azul),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "Registros de Irrigação",
                    style: TextStyle(
                      fontSize: 18 * f,
                      fontWeight: FontWeight.bold,
                      color: high ? DarkPalette.textPrimary : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Divider(color: high ? DarkPalette.surfaceBorder : Colors.grey[300]),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                  high ? DarkPalette.surfaceElevated : null,
                ),
                headingTextStyle: TextStyle(
                  color: high ? Colors.cyanAccent : azul,
                  fontWeight: FontWeight.bold,
                  fontSize: 14 * f,
                ),
                dataTextStyle: TextStyle(
                  color: high ? DarkPalette.textSecondary : Colors.black87,
                  fontSize: 13 * f,
                ),
                columns: const [
                  DataColumn(label: Text("Data e Hora")),
                  DataColumn(label: Text("Setor / Cultura")),
                  DataColumn(label: Text("Duração")),
                  DataColumn(label: Text("Volume")),
                  DataColumn(label: Text("Acionamento")),
                  DataColumn(label: Text("Status")),
                ],
                rows: filtrados.map((item) {
                  return _historyRow(
                    item["data"],
                    item["setor"],
                    item["duracao"],
                    item["volume"],
                    item["icon"],
                    item["tipo"],
                    item["status"],
                    item["color"],
                    high,
                    f,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _historyRow(
    String data,
    String setor,
    String duracao,
    String vol,
    IconData icon,
    String tipo,
    String status,
    Color statusColor,
    bool high,
    double f,
  ) {
    // CORRIGIDO: no modo escuro o status usava sempre branco e perdia
    // a distinção visual entre "Concluído" (verde) e "Falha" (vermelho).
    // Agora usa uma versão mais clara da própria cor do status.
    final Color highStatusColor = statusColor == Colors.green ? Colors.greenAccent : Colors.redAccent;

    return DataRow(
      cells: [
        DataCell(Text(
          data,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: high ? DarkPalette.textPrimary : Colors.black,
          ),
        )),
        DataCell(Text(setor)),
        DataCell(Text(duracao)),
        DataCell(Text(vol)),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: high ? DarkPalette.textSecondary : Colors.black54),
            const SizedBox(width: 5),
            Text(tipo),
          ],
        )),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: high ? highStatusColor.withOpacity(0.18) : statusColor,
              borderRadius: BorderRadius.circular(20),
              border: high ? Border.all(color: highStatusColor, width: 1.5) : null,
            ),
            child: Text(
              status,
              style: TextStyle(
                color: high ? highStatusColor : Colors.white,
                fontSize: 11 * f,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- DRAWER ----------------
  Widget _buildDrawer(BuildContext context, bool high, double f) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: high
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [DarkPalette.background, DarkPalette.surface],
                )
              : null,
          color: high ? null : azul,
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Text(
              "HYDROFLOW",
              style: TextStyle(
                color: high ? Colors.cyanAccent : Colors.white,
                fontSize: 24 * f,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: high ? DarkPalette.surfaceBorder : Colors.white24),

            _drawerItem(context, Icons.home, "Painel", f, () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            }),
            _drawerItem(context, Icons.park, "Plantas", f, () {
              Navigator.pushReplacementNamed(context, '/plantas');
            }),
            _drawerItem(context, Icons.history, "Histórico", f, () {
              Navigator.pushReplacementNamed(context, '/historico');
            }),
            _drawerItem(context, Icons.memory, "Equipamentos", f, () {
              Navigator.pushReplacementNamed(context, '/equipamentos');
            }),

            const Spacer(),
            Divider(color: high ? DarkPalette.surfaceBorder : Colors.white24),

            _drawerItem(context, Icons.logout, "Sair", f, () {
              _logout(context);
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    double f,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 14 * f)),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  // Correção do nome interno do método auxiliar chamado pelo drawer
  Widget _drawerItem(BuildContext context, IconData icon, String title, double f, VoidCallback onTap) {
    return _buildDrawerItem(context, icon, title, f, onTap);
  }
}