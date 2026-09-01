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

// class RelatorioplantasPage extends StatefulWidget {
//   const RelatorioplantasPage({super.key});

//   @override
//   State<RelatorioplantasPage> createState() =>
//       _RelatorioplantasPageState();
// }

// class _RelatorioplantasPageState
//     extends State<RelatorioplantasPage> {

//   final ScrollController horizontalController =
//       ScrollController();

//   // Lista que armazenará as plantas retornadas da API
//   List<dynamic> plantas = [];

//   // Indica se os dados estão carregando
//   bool carregando = true;

//   // Armazena uma possível mensagem de erro
//   String? erro;

//   static const azul = Color(0xFF002855);

//   // ==========================================================
//   // INICIALIZAÇÃO
//   // ==========================================================

//   @override
//   void initState() {
//     super.initState();
//     consultarPlantas();
//   }

//   // ==========================================================
//   // CONSULTAR PLANTAS
//   // ==========================================================

//   Future<void> consultarPlantas() async {
//     try {
//       final resposta = await http.get(
//         Uri.parse(
//           'http://10.141.130.50/HydroFlow/public/api/plantas',
//         ),
//         headers: {
//           'Accept': 'application/json',
//         },
//       );

//       final resultado = jsonDecode(resposta.body);

//       if (resposta.statusCode == 200) {
//         setState(() {
//           plantas = resultado['data'] ?? [];
//           carregando = false;
//           erro = null;
//         });
//       } else {
//         setState(() {
//           erro = resultado['message'] ??
//               'Erro ao consultar plantas';
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
//   // EXCLUIR PLANTA
//   // ==========================================================

//   Future<void> excluirPlanta(dynamic plantaID) async {
//     try {
//       final resposta = await http.delete(
//         Uri.parse(
//           'http://10.141.130.50/HydroFlow/public/api/plantas/$plantaID',
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
//               'Planta excluída com sucesso!',
//             ),
//           ),
//         );

//         await consultarPlantas();
//       } else {
//         if (!mounted) return;

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Erro ao excluir planta: '
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

//     // ========================================================
//     // CORES
//     // ========================================================

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
//           'Relatório de plantas',
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

//           // ATUALIZAR
//           IconButton(
//             onPressed: () {
//               setState(() {
//                 carregando = true;
//                 erro = null;
//               });

//               consultarPlantas();
//             },
//             icon: const Icon(Icons.refresh),
//           ),

//           // ACESSIBILIDADE
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

//           // SEM PLANTAS
//           : plantas.isEmpty
//               ? Center(
//                   child: Text(
//                     'Nenhuma planta encontrada.',
//                     style: TextStyle(
//                       color: high
//                           ? DarkPalette.textPrimary
//                           : Colors.black87,
//                       fontSize: 16 * f,
//                     ),
//                   ),
//                 )

//           // ====================================================
//           // TABELA
//           // ====================================================

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
//                           label: Text('NOME'),
//                         ),

//                         DataColumn(
//                           label: Text('TIPO'),
//                         ),

//                         DataColumn(
//                           label: Text('QTD. ÁGUA'),
//                         ),

//                         DataColumn(
//                           label: Text('PERIODICIDADE'),
//                         ),

//                         DataColumn(
//                           label: Text('CULTURA'),
//                         ),

//                         DataColumn(
//                           label: Text('USUÁRIO'),
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

//                       rows: plantas
//                           .map<DataRow>((planta) {

//                         return DataRow(
//                           cells: [

//                             // ID
//                             DataCell(
//                               Text(
//                                 '${planta['PLANTA_ID'] ?? ''}',
//                               ),
//                             ),

//                             // NOME
//                             DataCell(
//                               Text(
//                                 '${planta['PLANTA_NOME'] ?? ''}',
//                               ),
//                             ),

//                             // TIPO
//                             DataCell(
//                               Text(
//                                 '${planta['PLANTA_TIPO'] ?? ''}',
//                               ),
//                             ),

//                             // QUANTIDADE DE ÁGUA
//                             DataCell(
//                               Text(
//                                 '${planta['PLANTA_QTD_AGUA'] ?? ''} L',
//                               ),
//                             ),

//                             // PERIODICIDADE
//                             DataCell(
//                               Text(
//                                 '${planta['PLANTA_PERIDIOCIDADE'] ?? ''} dias',
//                               ),
//                             ),

//                             // CULTURA
//                             DataCell(
//                               Text(
//                                 '${planta['PLANTA_CULTURA'] ?? ''}',
//                               ),
//                             ),

//                             // USUÁRIO
//                             DataCell(
//                               Text(
//                                 '${planta['FK_USU_ID'] ?? ''}',
//                               ),
//                             ),

//                             // DISPOSITIVO
//                             DataCell(
//                               Text(
//                                 '${planta['FK_DIS_ID'] ?? ''}',
//                               ),
//                             ),

//                             // ==================================================
//                             // AÇÕES
//                             // ==================================================

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
//                                           planta[
//                                               'PLANTA_ID'];

//                                       print(
//                                         'Editar planta: $id',
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
//                                           planta[
//                                               'PLANTA_ID'];

//                                       // ==================================================
//                                       // CONFIRMAÇÃO
//                                       // ==================================================

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
//                                               'Excluir planta?',
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
//                                               'Deseja excluir a planta ${planta['PLANTA_NOME'] ?? ''}?',
//                                               style:
//                                                   TextStyle(
//                                                 color: high
//                                                     ? DarkPalette
//                                                         .textSecondary
//                                                     : null,
//                                               ),
//                                             ),

//                                             actions: [

//                                               // CANCELAR
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

//                                               // EXCLUIR
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

//                                       // ==================================================
//                                       // EXCLUIR
//                                       // ==================================================

//                                       if (confirmar ==
//                                           true) {

//                                         await excluirPlanta(
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
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // biblioteca http
import 'dart:convert'; // Pacote para gerar JSON

class RelatorioplantasPage extends StatefulWidget {
  const RelatorioplantasPage({super.key});

  @override
  State<RelatorioplantasPage> createState() => _RelatorioplantasPageState();
}

class _RelatorioplantasPageState extends State<RelatorioplantasPage> {
  final ScrollController horizontalController = ScrollController();
  
  //Criar uma lista que armazenará os componentes retornados da API
  List<dynamic> plantas = [];

  //Criar uma variável para indicar se os dados estão carregando
  bool carregando = true;

  //armazenar uma possível mensagem de erro da API
  String? erro;

  //Criar uma função para rodar toda vez que abrir a página
  @override initState(){
    super.initState();
    consultarplantas();
  }


  Future<void> consultarplantas() async {
    try{
      //Faz uma requisição http do tipo GET para a API
      final resposta = await http.get(
        Uri.parse(
          'http://desktop-ts98lnj/industria_automotiva_api/public/api/plantas' //MUDAR ESSA BOMBA AQUIIIIIIIIIIIIIIIIIIII
        ),
        //informar para a API que os dados são em json
        headers: {
        'Accept': 'application/json',
      }
      );
      
      //Converter a resposta em JSON
      final resultado = jsonDecode(resposta.body);

      //Verificar se a resposta da API foi bem sucedida
      if(resposta.statusCode == 200){
        setState((){
          //Salvar os componentes em uma variável
          plantas = resultado['data'] ?? [];
          carregando = false;
        });
      }
      else {
       setState((){
          //Salva uma mensagem de erro
          plantas = resultado['message'] ?? 'Erro ao consultar plantas';
          carregando = false;
        }); 
      }
    }
    catch(e){
      setState((){
        erro = 'Erro: $e';
        carregando = false;
      });
    }
  }

  Future<void> excluirplantas(dynamic plantasID) async {
    try{
      //Faz uma requisição http do tipo Delete para a API
      final resposta = await http.delete(
        Uri.parse(
          'http://desktop-ts98lnj/industria_automotiva_api/public/api/componentes/$plantasID' //MUDAR ESSA BAGAÇA
        ),
        //informar para a API que os dados são em json
        headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
      );
      //Converter a resposta em JSON
      final resultado = jsonDecode(resposta.body);

      //Verificar se a exclusão foi concluída
      if(resposta.statusCode == 200 || resposta.statusCode == 201){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('plantas excluído com sucesso!')),
        );

        await consultarplantas(); // Atualizar a tela após excluir
      }
      else {
        //Exibe uma mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir plantas: ${resultado['message'] ?? 'Erro desconhecido'}')),
        );
      }

    }
    catch(e){
      //Exibe erro da api
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao acessar API: $e')),
        );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de plantas'),
        //Adicionar um botão de atualização
        actions: [
          IconButton(
            onPressed: (){
              setState((){
                carregando = true;
                erro = null;
              });
              consultarplantas();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: 
      carregando
      ? const Center(
        child: CircularProgressIndicator(),
      )
      :
      Padding(
        padding: const EdgeInsets.all(24),
        child: Scrollbar(
          controller: horizontalController,
          thumbVisibility: true,
          trackVisibility: true,
          scrollbarOrientation: ScrollbarOrientation.bottom,
          child: SingleChildScrollView(
            controller: horizontalController,
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                const Color(0xFFE7F0F2),
              ),
              border: TableBorder.all(
                color: const Color(0xFFE0E5E7),
                borderRadius: BorderRadius.circular(8),
              ),
              columns: const [
                DataColumn(
                  label: Text(
                    'ID',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'CODIGO',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'NOME',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'ESTOQUE',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Ações',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              
              // Criar uma lista de linhas da tabela a partir dos componentes
              rows: plantas.map<DataRow> ((plantas) {
                return DataRow(
                  cells: [
                    DataCell(Text(plantas['ID'] ?? '')),
                    DataCell(Text(plantas['CODIGO'] ?? '')),
                    DataCell(Text(plantas['NOME'] ?? '')),
                    DataCell(Text(plantas['ESTOQUE'] ?? '')),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Color.fromARGB(255, 3, 83, 148)),
                            onPressed: () {
                              // Lógica para editar o modelo
                              final id = plantas['ID'];
                            }
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              // Lógica para excluir o modelo
                              final id = plantas['ID'];

                              //Exibir uma mensagem de confirmação antes de excluir o modelo
                              final confirmar = await showDialog<bool>(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    title: const Text("Excluir Modelo?"),
                                    content: Text("Deseja excluir o modelo ${plantas['NOME']}"),
                                    actions: [
                                      //Botão de cancelar a ação
                                      TextButton(
                                        onPressed:() {
                                          Navigator.pop(context, false);
                                        },
                                        child: Text("Cancelar")
                                      ),
                                      
                                      //Botão de excluir
                                      TextButton(
                                        onPressed:() {
                                          Navigator.pop(context, true);
                                        },
                                        child: Text("excluir")
                                      ),
                                    ],
                                  );
                                }
                              );
                              //Se o usuário confimar a exclusão, chama a função
                              if(confirmar == true){
                                await excluirplantas(id);
                              }
                            }
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }). toList()
            ),
          ),
        ),
      ),
    );
  }
}