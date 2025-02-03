import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  static const String _apiKey =
      '02c7a898bb4a40059d902833170da120'; // Substitui pela tua chave
  static const String _baseUrl = 'https://newsapi.org/v2/everything';

  Future<List<dynamic>> fetchNews() async {
    final url = Uri.parse(
        '$_baseUrl?q=cinema OR filmes OR séries&language=pt&apiKey=$_apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles']; // Retorna a lista de notícias
    } else {
      throw Exception('Falha ao carregar notícias');
    }
  }
}
