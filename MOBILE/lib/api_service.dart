import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ATENÇÃO PARA O IP:
  // - Emulador Android: 'http://10.0.2.2:3000'
  // - Celular no Wi-Fi: 'http://192.168.X.X:3000' (IP do seu PC)
  static const String baseUrl = 'http://10.141.130.54/HydroFlow/public/api';

  // 1. GET Dashboard
  Future<Map<String, dynamic>> getDashboard() async {
    final response = await http.get(Uri.parse('$baseUrl/dados_sensores'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Erro ao carregar Dashboard');
  }

  // 2. GET Plantas
  Future<List<dynamic>> getPlantas() async {
      final response = await http.get(
          Uri.parse(
            '$baseUrl/plantas'
          ),
        );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

    throw Exception('Erro ao carregar Plantas');
  }

  // 3. GET Equipamentos
  Future<List<dynamic>> getEquipamentos() async {
    final response = await http.get(Uri.parse('$baseUrl/equipamentos'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Erro ao carregar Equipamentos');
  }

  // 4. GET Histórico
  Future<List<dynamic>> getHistorico() async {
    final response = await http.get(Uri.parse('$baseUrl/historico'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Erro ao carregar Histórico');
  }
}