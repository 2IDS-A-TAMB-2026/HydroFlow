import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'accessibility_provider.dart';
import 'botao_acessibilidade.dart';

/// ─────────────────────────────────────────────
/// PALETA DO MODO ESCURO
/// ─────────────────────────────────────────────

class DarkPalette {
  static const Color background = Color(0xFF0A1A2B);
  static const Color surface = Color(0xFF10263D);
  static const Color surfaceElevated = Color(0xFF16324B);
  static const Color surfaceBorder = Color(0xFF1E3B57);
  static const Color textPrimary = Color(0xFFF2F6FA);
  static const Color textSecondary = Color(0xFFA9C0D6);
}

class RelatoriodispositivosPage extends StatefulWidget {
  const RelatoriodispositivosPage({super.key});

  @override
  State<RelatoriodispositivosPage> createState() =>
      _RelatoriodispositivosPageState();
}

class _RelatoriodispositivosPageState extends State<RelatoriodispositivosPage> {
  final ScrollController horizontalController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  List<dynamic> dispositivos = [];
  List<dynamic> dispositivosFiltrados = [];

  bool carregando = true;
  String? erro;

  final String apiUrl =
      'http://DESKTOP-38ILVP3/HydroFlow/public/api/dispositivos';

  static const azul = Color(0xFF002855);

  @override
  void initState() {
    super.initState();
    consultarDispositivos();
  }

  @override
  void dispose() {
    horizontalController.dispose();
    searchController.dispose();
    super.dispose();
  }

  /// ─────────────────────────────────────────────
  /// API CONSULTA & FILTRO
  /// ─────────────────────────────────────────────

  Future<void> consultarDispositivos() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final resposta = await http.get(
        Uri.parse(apiUrl),
        headers: {'Accept': 'application/json'},
      );

      final resultado = jsonDecode(resposta.body);

      if (resposta.statusCode == 200) {
        if (!mounted) return;

        List<dynamic> lista = [];
        if (resultado is List) {
          lista = resultado;
        } else if (resultado is Map) {
          lista = resultado['data'] ?? [];
        }

        setState(() {
          dispositivos = lista;
          dispositivosFiltrados = lista;
          carregando = false;
        });

        if (searchController.text.isNotEmpty) {
          _filtrarDispositivos(searchController.text);
        }
      } else {
        if (!mounted) return;

        String mensagemErro = 'Erro ao consultar dispositivos';
        if (resultado is Map) {
          mensagemErro = resultado['message'] ??
              resultado['messages']?['error'] ??
              'Erro ao consultar dispositivos';
        }

        setState(() {
          erro = mensagemErro;
          carregando = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        erro = 'Erro ao acessar API: $e';
        carregando = false;
      });
    }
  }

  void _filtrarDispositivos(String query) {
    setState(() {
      if (query.isEmpty) {
        dispositivosFiltrados = dispositivos;
      } else {
        dispositivosFiltrados = dispositivos.where((disp) {
          final nome = (disp['DIS_NOME'] ?? '').toString().toLowerCase();
          final dono = nomeDono(disp).toLowerCase();
          final status = (disp['DIS_STATUS'] ?? '').toString().toLowerCase();
          final q = query.toLowerCase();

          return nome.contains(q) || dono.contains(q) || status.contains(q);
        }).toList();
      }
    });
  }

  Future<void> excluirDispositivo(dynamic dispositivoId) async {
    try {
      final resposta = await http.delete(
        Uri.parse('$apiUrl/$dispositivoId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      dynamic resultado;
      try {
        resultado = jsonDecode(resposta.body);
      } catch (_) {
        resultado = {};
      }

      if (resposta.statusCode == 200 ||
          resposta.statusCode == 201 ||
          resposta.statusCode == 204) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[700],
            content: Text(
              resultado is Map
                  ? resultado['mensagem'] ?? 'Dispositivo excluído com sucesso!'
                  : 'Dispositivo excluído com sucesso!',
            ),
          ),
        );

        await consultarDispositivos();
      } else {
        if (!mounted) return;

        String mensagemDetalhe = 'Erro desconhecido';
        if (resultado is Map) {
          mensagemDetalhe = resultado['mensagem'] ??
              resultado['message'] ??
              resultado['messages']?['error'] ??
              'Erro desconhecido';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[700],
            content: Text('Erro ao excluir dispositivo: $mensagemDetalhe'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[700],
          content: Text('Erro ao acessar API: $e'),
        ),
      );
    }
  }

  String nomeDono(dynamic dispositivo) {
    if (dispositivo is! Map) return 'Não atribuído';

    final dono = (dispositivo['nome_dono'] ??
            dispositivo['dono_nome'] ??
            dispositivo['USU_NOME'] ??
            dispositivo['FK_USU_ID'] ??
            '')
        .toString();

    return dono.isEmpty ? 'Não atribuído' : dono;
  }

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

  /// ─────────────────────────────────────────────
  /// UI PRINCIPAL
  /// ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final acc = Provider.of<AccessibilityProvider>(context);
    final high = acc.isHighContrast;
    final f = acc.fontSizeFactor;

    final bgPage = high ? DarkPalette.background : const Color(0xFFF4F6F9);
    final bgCard = high ? DarkPalette.surface : Colors.white;
    final appBarBg = high ? DarkPalette.surface : azul;
    final txtColor = high ? DarkPalette.textPrimary : Colors.black87;

    final appBarBorder = high
        ? const BorderSide(color: DarkPalette.surfaceBorder, width: 2)
        : BorderSide.none;

    return Scaffold(
      backgroundColor: bgPage,
      appBar: AppBar(
        title: Text(
          'Relatório de Dispositivos',
          style: TextStyle(fontSize: 18 * f, fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarBg,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: Border(bottom: appBarBorder),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: consultarDispositivos,
            icon: const Icon(Icons.refresh),
          ),
          const BotaoAcessibilidade(),
        ],
      ),

      drawer: _buildDrawer(context, high, f),

      body: Column(
        children: [
          // BARRA DE PESQUISA SUPERIOR
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: _filtrarDispositivos,
              style: TextStyle(color: txtColor, fontSize: 14 * f),
              decoration: InputDecoration(
                hintText: 'Buscar por nome, dono ou status...',
                hintStyle: TextStyle(
                  color: high ? DarkPalette.textSecondary : Colors.grey[500],
                  fontSize: 14 * f,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: high ? Colors.cyanAccent : azul,
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          _filtrarDispositivos('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: bgCard,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: high
                        ? DarkPalette.surfaceBorder
                        : Colors.black.withOpacity(0.08),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: high
                        ? DarkPalette.surfaceBorder
                        : Colors.black.withOpacity(0.08),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: high ? Colors.cyanAccent : azul,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          // CONTEÚDO PRINCIPAL (LOADING / ERRO / CARDS / TABELA)
          Expanded(
            child: carregando
                ? const Center(child: CircularProgressIndicator())
                : erro != null
                    ? _buildErrorView(high, f)
                    : dispositivosFiltrados.isEmpty
                        ? _buildEmptyView(high, f)
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              // Em ecrãs estreitos (Mobile), desenha Cards
                              if (constraints.maxWidth < 700) {
                                return ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  itemCount: dispositivosFiltrados.length,
                                  itemBuilder: (context, index) {
                                    return _buildDeviceCard(
                                      dispositivosFiltrados[index],
                                      bgCard,
                                      high,
                                      f,
                                    );
                                  },
                                );
                              }
                              // Em ecrãs largos (Tablet/Web), usa a Tabela Estilizada
                              return _buildTableView(bgCard, high, f);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  /// ─────────────────────────────────────────────
  /// COMPONENTE: CARD DO DISPOSITIVO (MOBILE)
  /// ─────────────────────────────────────────────

  Widget _buildDeviceCard(
    dynamic disp,
    Color bgCard,
    bool high,
    double f,
  ) {
    final status = (disp['DIS_STATUS'] ?? 'Desconhecido').toString();
    final nivel = double.tryParse(disp['DIS_NIVEL_TANQUE']?.toString() ?? '');

    final isAtivo = status.toLowerCase() == 'ativo' ||
        status.toLowerCase() == 'operacional' ||
        status.toLowerCase() == 'ligado';

    final statusColor = high
        ? (isAtivo ? Colors.greenAccent : Colors.orangeAccent)
        : (isAtivo ? const Color(0xFF2E7D32) : const Color(0xFFED6C02));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: high
              ? DarkPalette.surfaceBorder
              : Colors.black.withOpacity(0.06),
          width: high ? 1.5 : 1.0,
        ),
        boxShadow: high
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (high ? Colors.cyanAccent : azul)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.memory,
                        size: 20 * f,
                        color: high ? Colors.cyanAccent : azul,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            disp['DIS_NOME']?.toString() ?? 'Sem Nome',
                            style: TextStyle(
                              fontSize: 16 * f,
                              fontWeight: FontWeight.bold,
                              color: high
                                  ? DarkPalette.textPrimary
                                  : Colors.black87,
                            ),
                          ),
                          Text(
                            'ID: #${disp['DIS_ID'] ?? '-'}',
                            style: TextStyle(
                              fontSize: 11 * f,
                              color: high
                                  ? DarkPalette.textSecondary
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // CHIP DE STATUS
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor, width: 1),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10 * f,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          if (disp['DIS_DESCRICAO'] != null &&
              disp['DIS_DESCRICAO'].toString().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              disp['DIS_DESCRICAO'].toString(),
              style: TextStyle(
                fontSize: 13 * f,
                color: high ? DarkPalette.textSecondary : Colors.grey[700],
              ),
            ),
          ],

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // DONO E NÍVEL DO TANQUE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.person,
                      size: 16 * f,
                      color:
                          high ? DarkPalette.textSecondary : Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    nomeDono(disp),
                    style: TextStyle(
                      fontSize: 12 * f,
                      fontWeight: FontWeight.w600,
                      color: high
                          ? DarkPalette.textPrimary
                          : Colors.grey[800],
                    ),
                  ),
                ],
              ),
              if (nivel != null)
                Row(
                  children: [
                    Icon(Icons.water_drop,
                        size: 16 * f,
                        color:
                            high ? Colors.cyanAccent : const Color(0xFF0288D1)),
                    const SizedBox(width: 4),
                    Text(
                      '${nivel.toInt()}% Tanque',
                      style: TextStyle(
                        fontSize: 12 * f,
                        fontWeight: FontWeight.bold,
                        color: high
                            ? Colors.cyanAccent
                            : const Color(0xFF0288D1),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // BARRA VISUAL DE NÍVEL DE TANQUE
          if (nivel != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (nivel / 100).clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: high
                    ? DarkPalette.surfaceElevated
                    : Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  nivel < 20
                      ? Colors.red
                      : (high ? Colors.cyanAccent : const Color(0xFF0288D1)),
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),

          // BOTÕES DE AÇÃO
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: high ? Colors.cyanAccent : azul,
                ),
                icon: const Icon(Icons.edit, size: 18),
                label: Text('Editar', style: TextStyle(fontSize: 13 * f)),
                onPressed: () {
                  final id = disp['DIS_ID'];
                  print('Editar dispositivo ID: $id');
                },
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                ),
                icon: const Icon(Icons.delete_outline, size: 18),
                label: Text('Excluir', style: TextStyle(fontSize: 13 * f)),
                onPressed: () => _confirmarExclusao(disp),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// ─────────────────────────────────────────────
  /// COMPONENTE: TABELA ESTILIZADA (DESKTOP)
  /// ─────────────────────────────────────────────

  Widget _buildTableView(Color bgCard, bool high, double f) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: bgCard,
        elevation: high ? 0 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: high
                ? DarkPalette.surfaceBorder
                : Colors.black.withOpacity(0.06),
          ),
        ),
        child: Scrollbar(
          controller: horizontalController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: horizontalController,
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                high ? DarkPalette.surfaceElevated : const Color(0xFFE7F0F2),
              ),
              columns: const [
                DataColumn(
                    label: Text('ID',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('NOME',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('DESCRIÇÃO',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('STATUS',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('NÍVEL DO TANQUE',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('DONO',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('AÇÕES',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: dispositivosFiltrados.map<DataRow>((disp) {
                final status = (disp['DIS_STATUS'] ?? '').toString();
                return DataRow(
                  cells: [
                    DataCell(Text(disp['DIS_ID']?.toString() ?? '')),
                    DataCell(
                      Text(
                        disp['DIS_NOME']?.toString() ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 240),
                        child: Text(
                          disp['DIS_DESCRICAO']?.toString() ?? '',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(Text(status)),
                    DataCell(
                      Text(
                        disp['DIS_NIVEL_TANQUE'] != null
                            ? '${disp['DIS_NIVEL_TANQUE']}%'
                            : '-',
                      ),
                    ),
                    DataCell(Text(nomeDono(disp))),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Color(0xFF035394)),
                            onPressed: () {
                              print('Editar ID: ${disp['DIS_ID']}');
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmarExclusao(disp),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  /// ─────────────────────────────────────────────
  /// ESTADOS AUXILIARES (ERRO / VAZIO / DIÁLOGO)
  /// ─────────────────────────────────────────────

  Widget _buildErrorView(bool high, double f) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 48 * f, color: high ? Colors.redAccent : Colors.red),
            const SizedBox(height: 12),
            Text(
              "Erro ao carregar dados",
              style: TextStyle(
                fontSize: 16 * f,
                fontWeight: FontWeight.bold,
                color: high ? Colors.redAccent : Colors.red,
              ),
            ),
            const SizedBox(height: 6),
            Text(erro!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13 * f)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: consultarDispositivos,
              icon: const Icon(Icons.refresh),
              label: const Text("Tentar Novamente"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(bool high, double f) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.devices_other,
            size: 56 * f,
            color: high ? DarkPalette.textSecondary : Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'Nenhum dispositivo encontrado.',
            style: TextStyle(
              fontSize: 15 * f,
              fontWeight: FontWeight.w500,
              color: high ? DarkPalette.textSecondary : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarExclusao(dynamic disp) async {
    final id = disp['DIS_ID'];
    final nome = disp['DIS_NOME'] ?? 'este dispositivo';

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Dispositivo?'),
          content: Text('Deseja realmente remover "$nome"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await excluirDispositivo(id);
    }
  }

  /// ─────────────────────────────────────────────
  /// DRAWER
  /// ─────────────────────────────────────────────

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
            _drawerItem(context, Icons.history, "Histórico de Ativações", f, () {
              Navigator.pushReplacementNamed(context, '/historico');
            }),
            _drawerItem(
                context, Icons.show_chart, "Histórico de Medições", f, () {
              Navigator.pushReplacementNamed(context, '/dados_sensores');
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

  Widget _drawerItem(BuildContext context, IconData icon, String title,
      double f, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title:
          Text(title, style: TextStyle(color: Colors.white, fontSize: 14 * f)),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}