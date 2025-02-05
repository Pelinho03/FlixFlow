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

  // Filmes em Brevemente
  Future<List<dynamic>> getUpcomingMovies() async {
    final url =
        Uri.parse('$_baseUrl/movie/upcoming?api_key=$_apiKey&language=pt-PT');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['results'] ?? [];
    } else {
      throw Exception(
          'Erro ao carregar filmes brevemente: ${response.statusCode}');
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

  // Redes de TV (Networks)
  Future<List<dynamic>> getMovieNetworks(int movieId) async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/watch/providers?api_key=$_apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Verificar se o país "PT" está presente
        if (data['results'] != null && data['results']['PT'] != null) {
          final providers = data['results']['PT'];

          // Combinar todas as formas de disponibilidade (flatrate, rent, buy)
          List<dynamic> availableProviders = [];
          if (providers.containsKey('flatrate')) {
            availableProviders.addAll(providers['flatrate']);
          }
          if (providers.containsKey('rent')) {
            availableProviders.addAll(providers['rent']);
          }
          if (providers.containsKey('buy')) {
            availableProviders.addAll(providers['buy']);
          }

          // Remover plataformas duplicadas com base no nome do provider ou no ID
          var uniqueProviders = <String, dynamic>{};
          for (var provider in availableProviders) {
            uniqueProviders[provider['provider_id'].toString()] = provider;
          }

          // Retornar a lista sem duplicados
          return uniqueProviders.values.toList();
        } else {
          return []; // Nenhum serviço disponível
        }
      } else {
        // print("Erro na API: ${response.statusCode} - ${response.body}");
        throw Exception('Erro ao obter as plataformas de streaming.');
      }
    } catch (e) {
      // print("Erro na requisição: $e");
      throw Exception('Erro ao conectar à API.');
    }
  }

  addComment(String movieId, String trim) {}
}
