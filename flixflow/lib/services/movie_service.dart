import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieService {
  final String _apiKey = dotenv.env['MOVIE_API_KEY'] ?? '';
  final String _baseUrl = 'https://api.themoviedb.org/3';

  // Filmes Populares
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

  // Top Filmes
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

  // Pesquisa de Filmes
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

  // Detalhes do Filme
  Future<dynamic> getMovieById(int id) async {
    final url =
        Uri.parse('$_baseUrl/movie/$id?api_key=$_apiKey&language=pt-PT');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final movieData = jsonDecode(response.body);
      return {
        ...movieData,
        'production_companies': movieData['production_companies'] ?? []
      };
    } else {
      throw Exception(
          'Erro ao buscar detalhes do filme: ${response.statusCode}');
    }
  }

  // Imagens do Filme
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

  // Géneros dos Filmes
  Future<Map<int, String>> fetchGenres() async {
    final url =
        Uri.parse('$_baseUrl/genre/movie/list?api_key=$_apiKey&language=pt-PT');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final genres = data['genres'] as List<dynamic>;
      return {
        for (var genre in genres) genre['id'] as int: genre['name'] as String
      };
    } else {
      throw Exception('Erro ao carregar os géneros: ${response.statusCode}');
    }
  }

  // Créditos do Filme (Diretor, Compositor)
  Future<Map<String, String>> getMovieCredits(int movieId) async {
    final url = Uri.parse(
        '$_baseUrl/movie/$movieId/credits?api_key=$_apiKey&language=pt-PT');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final crew = data['crew'] as List<dynamic>;

      final director = crew.firstWhere(
        (person) => person['job'] == 'Director',
        orElse: () => {'name': 'Não disponível'},
      )['name'];

      final composer = crew.firstWhere(
        (person) => person['job'] == 'Original Music Composer',
        orElse: () => {'name': 'Não disponível'},
      )['name'];

      return {
        'director': director,
        'composer': composer,
      };
    } else {
      throw Exception(
          'Erro ao buscar créditos do filme: ${response.statusCode}');
    }
  }

  // Trailer do Filme
  Future<String?> fetchMovieTrailer(int movieId) async {
    final url =
        '$_baseUrl/movie/$movieId/videos?api_key=$_apiKey&language=pt-PT';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final results = jsonResponse['results'] as List<dynamic>;

      if (results.isNotEmpty) {
        final trailer = results.firstWhere(
          (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
          orElse: () => null,
        );

        return trailer != null ? trailer['key'] : null;
      }
    }
    return null;
  }

  // Elenco do Filme
  Future<List<dynamic>> getMovieCast(int movieId) async {
    final url = Uri.parse(
        '$_baseUrl/movie/$movieId/credits?api_key=$_apiKey&language=pt-PT');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['cast'] ?? [];
    } else {
      throw Exception('Erro ao carregar elenco: ${response.statusCode}');
    }
  }

  addComment(String movieId, String trim) {}
}
