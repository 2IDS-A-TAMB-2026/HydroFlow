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
  List<dynamic> sensores = [];

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
          sensores = resultado['message'] ?? 'Erro ao consultar plantas';
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