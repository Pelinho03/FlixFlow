import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  final String _apiKey = '121f94d9eb19d3c9b11709ea229d3a63';
  final String _baseUrl = 'https://api.themoviedb.org/3';

  // OS MAIS POPULARES
  Future<List<dynamic>> getPopularMovies() async {
    final response = await http.get(
        Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=pt-PT'));

    if (response.statusCode == 200) {
      // SE FOR OK, DESCODIFICA O CORPO JSON
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['results'];
    } else {
      // SE NÃO FOR OK, EMITE UM ERRO
      throw Exception(
          'Erro ao carregar filmes populares: ${response.statusCode}');
    }
  }

  //TOP FILMES
  Future<List<dynamic>> getTopMovies() async {
    final response =
        await http.get(Uri.parse('$_baseUrl/movie/top_rated?api_key=$_apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Falha ao carregar Top filmes');
    }
  }

  //PESQUISA
  Future<List<dynamic>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/search/movie?api_key=$_apiKey&query=$query&language=pt-PT'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['results'] is List) {
        return data['results'];
      } else {
        return []; // Retorna uma lista vazia se não houver resultados
      }
    } else {
      throw Exception('Falha ao carregar filmes: ${response.statusCode}');
    }
  }

  //IMAGENS PARA OS DETALHES
  Future<List<dynamic>> fetchMovieImages(int movieId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId/images?api_key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['backdrops']; // Pega nas imagens de fundo
    } else {
      throw Exception('Falha ao carregar as imagens do filme');
    }
  }
}
