import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewsService {
  // Obtém a chave da API armazenada no ficheiro .env
  final String _apiKey = dotenv.env['NEWS_API_KEY'] ?? '';
  final String _baseUrl = 'https://newsapi.org/v2/everything';

  // Obtém notícias relacionadas com cinema, filmes e séries
  Future<List<dynamic>> fetchNews() async {
    final url = Uri.parse(
        '$_baseUrl?q=cinema OR filmes OR séries&language=pt&apiKey=$_apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles']; // Retorna a lista de artigos
    } else {
      throw Exception('Falha ao carregar notícias');
    }
  }
}
