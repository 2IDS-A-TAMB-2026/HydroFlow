/*import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // biblioteca http
import 'dart:convert'; // Pacote para gerar JSON

class Relatoriodados_sensoresPage extends StatefulWidget {
  const Relatoriodados_sensoresPage({super.key});

  @override
  State<Relatoriodados_sensoresPage> createState() => _Relatoriodados_sensoresPageState();
}

class _Relatoriodados_sensoresPageState extends State<Relatoriodados_sensoresPage> {
  final ScrollController horizontalController = ScrollController();
  
  //Criar uma lista que armazenará os componentes retornados da API
  List<dynamic> dados_sensores = [];

  //Criar uma variável para indicar se os dados estão carregando
  bool carregando = true;

  //armazenar uma possível mensagem de erro da API
  String? erro;

  //Criar uma função para rodar toda vez que abrir a página
  @override initState(){
    super.initState();
    consultardados_sensores();
  }


  Future<void> consultardados_sensores() async {
    try{
      //Faz uma requisição http do tipo GET para a API
      final resposta = await http.get(
        Uri.parse(
          'http://desktop-38ilvp3/HydroFlow/public/api/sensores' //MUDAR ESSA BOMBA AQUIIIIIIIIIIIIIIIIIIII
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
          dados_sensores = resultado['data'] ?? [];
          carregando = false;
        });
      }
      else {
       setState((){
          //Salva uma mensagem de erro
          dados_sensores = resultado['message'] ?? 'Erro ao consultar dados_sensores';
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

  Future<void> excluirdados_sensores(dynamic dados_sensoresID) async {
    try{
      //Faz uma requisição http do tipo Delete para a API
      final resposta = await http.delete(
        Uri.parse(
          'http://desktop-38ilvp3/HydroFlow/public/api/$dados_sensoresID' //MUDAR ESSA BAGAÇA
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
          SnackBar(content: Text('dados_sensores excluído com sucesso!')),
        );

        await consultardados_sensores(); // Atualizar a tela após excluir
      }
      else {
        //Exibe uma mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir dados_sensores: ${resultado['message'] ?? 'Erro desconhecido'}')),
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
        title: const Text('Relatório de dados_sensores'),
        //Adicionar um botão de atualização
        actions: [
          IconButton(
            onPressed: (){
              setState((){
                carregando = true;
                erro = null;
              });
              consultardados_sensores();
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
              rows: dados_sensores.map<DataRow> ((dados_sensores) {
                return DataRow(
                  cells: [
                    DataCell(Text(dados_sensores['ID'] ?? '')),
                    DataCell(Text(dados_sensores['CODIGO'] ?? '')),
                    DataCell(Text(dados_sensores['NOME'] ?? '')),
                    DataCell(Text(dados_sensores['ESTOQUE'] ?? '')),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Color.fromARGB(255, 3, 83, 148)),
                            onPressed: () {
                              // Lógica para editar o modelo
                              final id = dados_sensores['ID'];
                            }
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              // Lógica para excluir o modelo
                              final id = dados_sensores['ID'];

                              //Exibir uma mensagem de confirmação antes de excluir o modelo
                              final confirmar = await showDialog<bool>(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    title: const Text("Excluir Modelo?"),
                                    content: Text("Deseja excluir o modelo ${dados_sensores['NOME']}"),
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
                                await excluirdados_sensores(id);
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
import 'package:http/http.dart' as http; // biblioteca http
import 'dart:convert'; // Pacote para gerar JSON
import 'package:provider/provider.dart';
import 'package:tcc/botao_acessibilidade.dart';
import 'accessibility_provider.dart';

/// ─────────────────────────────────────────────
///  PALETA DO MODO ESCURO (mesma dos demais telas)
/// ─────────────────────────────────────────────
class DarkPalette {
  static const Color background = Color(0xFF0A1A2B);
  static const Color surface = Color(0xFF10263D);
  static const Color surfaceElevated = Color(0xFF16324B);
  static const Color surfaceBorder = Color(0xFF1E3B57);
  static const Color textPrimary = Color(0xFFF2F6FA);
  static const Color textSecondary = Color(0xFFA9C0D6);
}

class Relatoriodados_sensoresPage extends StatefulWidget {
  const Relatoriodados_sensoresPage({super.key});

  @override
  State<Relatoriodados_sensoresPage> createState() => _Relatoriodados_sensoresPageState();
}

class _Relatoriodados_sensoresPageState extends State<Relatoriodados_sensoresPage> {
  final ScrollController horizontalController = ScrollController();

  static const azul = Color(0xFF002855);

  //Criar uma lista que armazenará os componentes retornados da API
  List<dynamic> dados_sensores = [];

  //Criar uma variável para indicar se os dados estão carregando
  bool carregando = true;

  //armazenar uma possível mensagem de erro da API
  String? erro;

  //Criar uma função para rodar toda vez que abrir a página
  @override initState(){
    super.initState();
    consultardados_sensores();
  }


  Future<void> consultardados_sensores() async {
    try{
      //Faz uma requisição http do tipo GET para a API
      final resposta = await http.get(
        Uri.parse(
          'http://desktop-38ilvp3/HydroFlow/public/api/sensores' //MUDAR ESSA BOMBA AQUIIIIIIIIIIIIIIIIIIII
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
          dados_sensores = resultado['data'] ?? [];
          carregando = false;
        });
      }
      else {
       setState((){
          //Salva uma mensagem de erro
          dados_sensores = resultado['message'] ?? 'Erro ao consultar dados_sensores';
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

  Future<void> excluirdados_sensores(dynamic dados_sensoresID) async {
    try{
      //Faz uma requisição http do tipo Delete para a API
      final resposta = await http.delete(
        Uri.parse(
          'http://desktop-38ilvp3/HydroFlow/public/api/$dados_sensoresID' //MUDAR ESSA BAGAÇA
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
          SnackBar(content: Text('dados_sensores excluído com sucesso!')),
        );

        await consultardados_sensores(); // Atualizar a tela após excluir
      }
      else {
        //Exibe uma mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir dados_sensores: ${resultado['message'] ?? 'Erro desconhecido'}')),
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
  void dispose() {
    horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Escutando as configurações do Provider de acessibilidade
    final acc = Provider.of<AccessibilityProvider>(context);
    final high = acc.isHighContrast;
    final f = acc.fontSizeFactor;

    final bgPage = high ? DarkPalette.background : Colors.grey[100];
    final appBarBg = high ? DarkPalette.surface : azul;
    final bgContainer = high ? DarkPalette.surface : Colors.white;
    final appBarBorder = high
        ? const BorderSide(color: DarkPalette.surfaceBorder, width: 2)
        : BorderSide.none;

    return Scaffold(
      backgroundColor: bgPage,
      appBar: AppBar(
        title: Text('Relatório de Sensores', style: TextStyle(fontSize: 20 * f)),
        backgroundColor: appBarBg,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: Border(bottom: appBarBorder),
        //Adicionar um botão de atualização
        actions: [
          IconButton(
            onPressed: (){
              setState((){
                carregando = true;
                erro = null;
              });
              consultardados_sensores();
            },
            icon: const Icon(Icons.refresh),
          ),
          const BotaoAcessibilidade(),
        ],
      ),
      body: 
      carregando
      ? Center(
        child: CircularProgressIndicator(
          color: high ? Colors.cyanAccent : azul,
        ),
      )
      :
      Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgContainer,
            borderRadius: BorderRadius.circular(12),
            border: high ? Border.all(color: DarkPalette.surfaceBorder, width: 1.5) : null,
            boxShadow: high
                ? []
                : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
          ),
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
                  high ? DarkPalette.surfaceElevated : const Color(0xFFE7F0F2),
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
                border: TableBorder.all(
                  color: high ? DarkPalette.surfaceBorder : const Color(0xFFE0E5E7),
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
                rows: dados_sensores.map<DataRow> ((dados_sensores) {
                  return DataRow(
                    cells: [
                      DataCell(Text(dados_sensores['ID'] ?? '')),
                      DataCell(Text(dados_sensores['CODIGO'] ?? '')),
                      DataCell(Text(dados_sensores['NOME'] ?? '')),
                      DataCell(Text(dados_sensores['ESTOQUE'] ?? '')),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: high ? Colors.cyanAccent : const Color.fromARGB(255, 3, 83, 148)),
                              onPressed: () {
                                // Lógica para editar o modelo
                                final id = dados_sensores['ID'];
                              }
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: high ? Colors.redAccent : Colors.red),
                              onPressed: () async {
                                // Lógica para excluir o modelo
                                final id = dados_sensores['ID'];

                                //Exibir uma mensagem de confirmação antes de excluir o modelo
                                final confirmar = await showDialog<bool>(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      backgroundColor: high ? DarkPalette.surface : Colors.white,
                                      title: Text(
                                        "Excluir Modelo?",
                                        style: TextStyle(color: high ? DarkPalette.textPrimary : Colors.black87),
                                      ),
                                      content: Text(
                                        "Deseja excluir o modelo ${dados_sensores['NOME']}",
                                        style: TextStyle(color: high ? DarkPalette.textSecondary : Colors.black87),
                                      ),
                                      actions: [
                                        //Botão de cancelar a ação
                                        TextButton(
                                          onPressed:() {
                                            Navigator.pop(context, false);
                                          },
                                          child: Text("Cancelar", style: TextStyle(color: high ? Colors.cyanAccent : azul))
                                        ),
                                        
                                        //Botão de excluir
                                        TextButton(
                                          onPressed:() {
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text("excluir", style: TextStyle(color: Colors.red))
                                        ),
                                      ],
                                    );
                                  }
                                );
                                //Se o usuário confimar a exclusão, chama a função
                                if(confirmar == true){
                                  await excluirdados_sensores(id);
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
      ),
    );
  }
}