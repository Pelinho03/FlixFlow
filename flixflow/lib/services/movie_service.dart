import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  final String _apiKey = '121f94d9eb19d3c9b11709ea229d3a63'; // Tua chave API
  final String _baseUrl = 'https://api.themoviedb.org/3';

  // OS MAIS POPULARES
  Future<List<dynamic>> getPopularMovies() async {
    final url =
        Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=pt-PT');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['results'] ?? [];
    } else {
      throw Exception(
          'Erro ao carregar filmes populares: ${response.statusCode}');
    }
  }

  // TOP FILMES
  Future<List<dynamic>> getTopMovies() async {
    final url =
        Uri.parse('$_baseUrl/movie/top_rated?api_key=$_apiKey&language=pt-PT');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['results'] ?? [];
    } else {
      throw Exception('Erro ao carregar Top filmes: ${response.statusCode}');
    }
  }

  // PESQUISA DE FILMES
  Future<List<dynamic>> searchMovies(String query) async {
    final url = Uri.parse(
        '$_baseUrl/search/movie?api_key=$_apiKey&query=$query&language=pt-PT');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['results'] ?? [];
    } else {
      throw Exception('Erro ao pesquisar filmes: ${response.statusCode}');
    }
  }

  // DETALHES DO FILME PELO ID
  Future<dynamic> getMovieById(int id) async {
    final url =
        Uri.parse('$_baseUrl/movie/$id?api_key=$_apiKey&language=pt-PT');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Detalhes do filme
    } else {
      throw Exception(
          'Erro ao buscar detalhes do filme: ${response.statusCode}');
    }
  }

  // IMAGENS PARA OS DETALHES DO FILME
  Future<List<dynamic>> fetchMovieImages(int movieId) async {
    final url = Uri.parse('$_baseUrl/movie/$movieId/images?api_key=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['backdrops'] ?? [];
    } else {
      throw Exception(
          'Erro ao carregar as imagens do filme: ${response.statusCode}');
    }
  }

  // GÉNEROS DE FILMES
  Future<Map<int, String>> fetchGenres() async {
    final url =
        Uri.parse('$_baseUrl/genre/movie/list?api_key=$_apiKey&language=pt-PT');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      print('Gêneros recebidos: ${data['genres']}');
      final genres = data['genres'] as List<dynamic>;
      return {
        for (var genre in genres) genre['id'] as int: genre['name'] as String
      };
    } else {
      throw Exception('Erro ao carregar os géneros: ${response.statusCode}');
    }
  }
}
