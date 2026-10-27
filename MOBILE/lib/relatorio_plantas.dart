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
//           'http://.50/HydroFlow/public/api/plantas',
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
//           'http://10.141.131.57/HydroFlow/public/api/plantas/$plantaID',
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

/*import 'package:flutter/material.dart';
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
          'http://10.141.131.57/HydroFlow/public/api/plantas' //MUDAR ESSA BOMBA AQUIIIIIIIIIIIIIIIIIIII
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
          'http://10.141.131.57/HydroFlow/public/api/$plantasID' //MUDAR ESSA BAGAÇA
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
}*/

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:tcc/botao_acessibilidade.dart';
import 'accessibility_provider.dart';

/// ─────────────────────────────────────────────
///  PALETA DO MODO ESCURO (mesma das demais telas)
/// ─────────────────────────────────────────────
class DarkPalette {
  static const Color background = Color(0xFF0A1A2B);
  static const Color surface = Color(0xFF10263D);
  static const Color surfaceElevated = Color(0xFF16324B);
  static const Color surfaceBorder = Color(0xFF1E3B57);
  static const Color textPrimary = Color(0xFFF2F6FA);
  static const Color textSecondary = Color(0xFFA9C0D6);
}

class RelatorioplantasPage extends StatefulWidget {
  const RelatorioplantasPage({super.key});

  @override
  State<RelatorioplantasPage> createState() => _RelatorioplantasPageState();
}

class _RelatorioplantasPageState extends State<RelatorioplantasPage> {
  final ScrollController horizontalController = ScrollController();

  static const azul = Color(0xFF002855);

  static const String _baseUrl = 'http://10.141.131.57/HydroFlow/public/api';

  // Lista completa retornada pela API
  List<dynamic> plantas = [];

  // Lista exibida na tabela (já filtrada)
  List<dynamic> plantasFiltradas = [];

  bool carregando = true;
  String? erro;

  // Controladores do formulário de filtros
  final TextEditingController _buscaController = TextEditingController();
  final TextEditingController _estoqueMinController = TextEditingController();
  final TextEditingController _estoqueMaxController = TextEditingController();
  String _estoqueFiltro = 'todos';

  @override
  void initState() {
    super.initState();
    consultarplantas();
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================
  double _toDouble(dynamic valor) {
    return double.tryParse(valor?.toString().replaceAll(',', '.') ?? '') ?? 0.0;
  }

  // Remove acentos e deixa minúsculo para a busca por texto
  String _normalizar(String texto) {
    const comAcento = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
    const semAcento = 'aaaaaeeeeiiiiooooouuuucn';
    var resultado = texto.toLowerCase();
    for (int i = 0; i < comAcento.length; i++) {
      resultado = resultado.replaceAll(comAcento[i], semAcento[i]);
    }
    return resultado;
  }

  // ===========================================================================
  // FILTRO LOCAL
  // ===========================================================================
  void _aplicarFiltros() {
    final busca = _normalizar(_buscaController.text.trim());
    final double? estoqueMin =
        double.tryParse(_estoqueMinController.text.replaceAll(',', '.'));
    final double? estoqueMax =
        double.tryParse(_estoqueMaxController.text.replaceAll(',', '.'));

    final resultado = plantas.where((e) {
      if (e is! Map) return false;
      final item = Map<String, dynamic>.from(e);

      // Aceita os nomes de campos antigos e os retornados pela API HydroFlow.
      final id = item['ID'] ?? item['PLANTA_ID'] ?? item['id'] ?? '';
      final codigo = item['CODIGO'] ?? item['PLANTA_CODIGO'] ?? item['codigo'] ?? '';
      final nome = item['NOME'] ?? item['PLANTA_NOME'] ?? item['nome'] ?? '';
      final tipo = item['TIPO'] ?? item['PLANTA_TIPO'] ?? item['tipo'] ?? '';
      final cultura = item['CULTURA'] ?? item['PLANTA_CULTURA'] ?? item['cultura'] ?? '';

      // Busca por ID, código, nome, tipo ou cultura.
      if (busca.isNotEmpty) {
        final texto = _normalizar('$id $codigo $nome $tipo $cultura');
        if (!texto.contains(busca)) return false;
      }

      final estoque = _toDouble(
        item['ESTOQUE'] ?? item['PLANTA_ESTOQUE'] ?? item['PLANTA_QTD_AGUA'] ?? 0,
      );

      if (estoqueMin != null && estoque < estoqueMin) return false;
      if (estoqueMax != null && estoque > estoqueMax) return false;

      switch (_estoqueFiltro) {
        case 'com_estoque':
          if (!(estoque > 0)) return false;
          break;
        case 'sem_estoque':
          if (!(estoque <= 0)) return false;
          break;
      }
      return true;
    }).toList();

    setState(() {
      plantasFiltradas = resultado;
    });
  }

  void _limparFiltros() {
    _buscaController.clear();
    _estoqueMinController.clear();
    _estoqueMaxController.clear();
    _estoqueFiltro = 'todos';
    _aplicarFiltros();
  }

  // ===========================================================================
  // API
  // ===========================================================================
  Future<void> consultarplantas() async {
    if (!mounted) return;
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final resposta = await http.get(
        Uri.parse('$_baseUrl/plantas'),
        headers: {'Accept': 'application/json'},
      );

      print('STATUS PLANTAS: ${resposta.statusCode}');
      print('RESPOSTA PLANTAS: ${resposta.body}');

      if (!mounted) return;

      final dynamic resultado = jsonDecode(resposta.body);

      if (resposta.statusCode == 200) {
        List<dynamic> lista = [];
        if (resultado is List) {
          lista = resultado;
        } else if (resultado is Map && resultado['data'] is List) {
          lista = resultado['data'];
        }

        plantas = lista;
        carregando = false;
        _aplicarFiltros(); // mantém os filtros ativos após atualizar
      } else {
        setState(() {
          erro = (resultado is Map ? resultado['message'] : null)
                  ?.toString() ??
              'Erro ao consultar plantas';
          carregando = false;
        });
      }
    } catch (e) {
      print('ERRO PLANTAS: $e');
      if (!mounted) return;
      setState(() {
        erro = 'Erro: $e';
        carregando = false;
      });
    }
  }

  Future<void> excluirplantas(dynamic plantaId) async {
    try {
      final resposta = await http.delete(
        Uri.parse('$_baseUrl/plantas/$plantaId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (!mounted) return;

      String? mensagem;
      try {
        final resultado = jsonDecode(resposta.body);
        if (resultado is Map) mensagem = resultado['message']?.toString();
      } catch (_) {}

      if (resposta.statusCode == 200 ||
          resposta.statusCode == 201 ||
          resposta.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Planta excluída com sucesso!')),
        );
        await consultarplantas();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Erro ao excluir planta: ${mensagem ?? 'Erro desconhecido'}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao acessar API: $e')),
      );
    }
  }

  @override
  void dispose() {
    horizontalController.dispose();
    _buscaController.dispose();
    _estoqueMinController.dispose();
    _estoqueMaxController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    final acc = Provider.of<AccessibilityProvider>(context);
    final high = acc.isHighContrast;
    final f = acc.fontSizeFactor;

    final bgPage = high ? DarkPalette.background : Colors.grey[100];
    final appBarBg = high ? DarkPalette.surface : azul;
    final bgContainer = high ? DarkPalette.surface : Colors.white;
    final appBarBorder = high
        ? const BorderSide(color: DarkPalette.surfaceBorder, width: 2)
        : BorderSide.none;

    final decoracaoCard = BoxDecoration(
      color: bgContainer,
      borderRadius: BorderRadius.circular(12),
      border: high
          ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5)
          : null,
      boxShadow: high
          ? []
          : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
    );

    return Scaffold(
      backgroundColor: bgPage,
      appBar: AppBar(
        title: Text('Relatório de Plantas', style: TextStyle(fontSize: 20 * f)),
        backgroundColor: appBarBg,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: Border(bottom: appBarBorder),
        actions: [
          IconButton(
            onPressed: consultarplantas,
            icon: const Icon(Icons.refresh),
          ),
          const BotaoAcessibilidade(),
        ],
      ),
      body: carregando
          ? Center(
              child: CircularProgressIndicator(
                color: high ? Colors.cyanAccent : azul,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // MENSAGEM DE ERRO
                  if (erro != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child:
                          Text(erro!, style: const TextStyle(color: Colors.red)),
                    ),

                  // CARD 1: FILTROS DE BUSCA
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: decoracaoCard,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.filter_alt,
                                color:
                                    high ? Colors.cyanAccent : Colors.grey[700]),
                            const SizedBox(width: 8),
                            Text(
                              'Filtros de Busca',
                              style: TextStyle(
                                fontSize: 16 * f,
                                fontWeight: FontWeight.bold,
                                color: high
                                    ? DarkPalette.textPrimary
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildTextField('Buscar (nome/código)',
                                _buscaController, 'Ex: Alface', high,
                                width: 220),
                            _buildNumberField('Estoque mínimo',
                                _estoqueMinController, 'Ex: 1', high),
                            _buildNumberField('Estoque máximo',
                                _estoqueMaxController, 'Ex: 50', high),
                            _buildDropdownEstoque(high),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _aplicarFiltros,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00A65A),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                icon: const Icon(Icons.search,
                                    color: Colors.white),
                                label: Text(
                                  'Filtrar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14 * f),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _limparFiltros,
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  foregroundColor:
                                      high ? Colors.cyanAccent : Colors.black87,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                icon: const Icon(Icons.clear),
                                label: Text('Limpar',
                                    style: TextStyle(fontSize: 14 * f)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // CARD 2: TABELA
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: decoracaoCard,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plantas cadastradas (${plantasFiltradas.length})',
                          style: TextStyle(
                            fontSize: 15 * f,
                            fontWeight: FontWeight.bold,
                            color: high ? DarkPalette.textPrimary : azul,
                          ),
                        ),
                        const Divider(height: 20),
                        Scrollbar(
                          controller: horizontalController,
                          thumbVisibility: true,
                          trackVisibility: true,
                          scrollbarOrientation: ScrollbarOrientation.bottom,
                          child: SingleChildScrollView(
                            controller: horizontalController,
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(
                                high
                                    ? DarkPalette.surfaceElevated
                                    : const Color(0xFFE7F0F2),
                              ),
                              headingTextStyle: TextStyle(
                                color: high ? Colors.cyanAccent : azul,
                                fontWeight: FontWeight.bold,
                                fontSize: 14 * f,
                              ),
                              dataTextStyle: TextStyle(
                                color: high
                                    ? DarkPalette.textSecondary
                                    : Colors.black87,
                                fontSize: 13 * f,
                              ),
                              border: TableBorder.all(
                                color: high
                                    ? DarkPalette.surfaceBorder
                                    : const Color(0xFFE0E5E7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              columns: const [
                                DataColumn(label: Text('ID')),
                                DataColumn(label: Text('CODIGO')),
                                DataColumn(label: Text('NOME')),
                                DataColumn(label: Text('ESTOQUE')),
                                DataColumn(label: Text('AÇÕES')),
                              ],
                              rows: plantasFiltradas.isEmpty
                                  ? [
                                      const DataRow(cells: [
                                        DataCell(Text(
                                            'Nenhum registro encontrado.')),
                                        DataCell(Text('')),
                                        DataCell(Text('')),
                                        DataCell(Text('')),
                                        DataCell(Text('')),
                                      ])
                                    ]
                                  : plantasFiltradas.map<DataRow>((rowItem) {
                                      final planta = Map<String, dynamic>.from(
                                          rowItem as Map);
                                      return _buildRow(planta, high);
                                    }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ===========================================================================
  // LINHA DA TABELA
  // ===========================================================================
  DataRow _buildRow(Map<String, dynamic> planta, bool high) {
    return DataRow(
      cells: [
        DataCell(Text(planta['ID']?.toString() ?? '')),
        DataCell(Text(planta['CODIGO']?.toString() ?? '')),
        DataCell(Text(planta['NOME']?.toString() ?? '')),
        DataCell(Text(planta['ESTOQUE']?.toString() ?? '')),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: high
                      ? Colors.cyanAccent
                      : const Color.fromARGB(255, 3, 83, 148),
                ),
                onPressed: () {
                  // TODO: lógica para editar a planta
                  final id = planta['ID'];
                  print('Editar planta: $id');
                },
              ),
              IconButton(
                icon: Icon(Icons.delete,
                    color: high ? Colors.redAccent : Colors.red),
                onPressed: () async {
                  final id = planta['ID'];

                  final confirmar = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) {
                      return AlertDialog(
                        backgroundColor:
                            high ? DarkPalette.surface : Colors.white,
                        title: Text(
                          'Excluir planta?',
                          style: TextStyle(
                              color: high
                                  ? DarkPalette.textPrimary
                                  : Colors.black87),
                        ),
                        content: Text(
                          'Deseja excluir a planta ${planta['NOME'] ?? ''}?',
                          style: TextStyle(
                              color: high
                                  ? DarkPalette.textSecondary
                                  : Colors.black87),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: Text('Cancelar',
                                style: TextStyle(
                                    color: high ? Colors.cyanAccent : azul)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext, true),
                            child: const Text('Excluir',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmar == true) {
                    await excluirplantas(id);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // COMPONENTES AUXILIARES
  // ===========================================================================
  Widget _buildTextField(String label, TextEditingController controller,
      String placeholder, bool isHigh,
      {double width = 150}) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        onChanged: (_) => _aplicarFiltros(), // filtra enquanto digita
        style: TextStyle(color: isHigh ? Colors.white : Colors.black),
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          isDense: true,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.search, size: 18),
        ),
      ),
    );
  }

  Widget _buildNumberField(String label, TextEditingController controller,
      String placeholder, bool isHigh) {
    return SizedBox(
      width: 150,
      child: TextField(
        controller: controller,
        onChanged: (_) => _aplicarFiltros(),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(color: isHigh ? Colors.white : Colors.black),
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          isDense: true,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdownEstoque(bool isHigh) {
    return SizedBox(
      width: 170,
      child: DropdownButtonFormField<String>(
        value: _estoqueFiltro,
        decoration: const InputDecoration(
          labelText: 'Situação do estoque',
          isDense: true,
          border: OutlineInputBorder(),
        ),
        dropdownColor: isHigh ? DarkPalette.surface : Colors.white,
        style: TextStyle(color: isHigh ? Colors.white : Colors.black),
        items: const [
          DropdownMenuItem(value: 'todos', child: Text('Todos')),
          DropdownMenuItem(value: 'com_estoque', child: Text('Com estoque')),
          DropdownMenuItem(value: 'sem_estoque', child: Text('Sem estoque')),
        ],
        onChanged: (val) {
          if (val != null) {
            _estoqueFiltro = val;
            _aplicarFiltros();
          }
        },
      ),
    );
  }
}