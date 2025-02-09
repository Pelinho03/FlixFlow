import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../widgets/movie_list_widget.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../services/navigation_service.dart';
import '../styles/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/search_and_filter/search_banner_widget.dart';
import '../widgets/search_and_filter/movie_tile_widget.dart';
import '../widgets/search_and_filter/genre_filter_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> _popularMovies;
  late Future<List<dynamic>> _topMovies;
  late Future<List<dynamic>> _upcomingMovies;
  late Future<List<dynamic>> _trendingMovies;
  Future<List<dynamic>>? _searchMovies;
  Future<Map<int, String>>? _genresFuture;
  List<dynamic>? _filteredMovies; // Lista de filmes filtrados
  String _searchQuery = ''; // Variável para armazenar a consulta de pesquisa
  int _selectedIndex = 0; // Índice da navegação inferior
  int? _selectedGenreId; // ID do género selecionado para filtrar filmes

  @override
  void initState() {
    super.initState();
    // Inicializa as listas de filmes com os dados da API
    _popularMovies = MovieService().getPopularMovies();
    _topMovies = MovieService().getTopMovies();
    _upcomingMovies = MovieService().getUpcomingMovies();
    _trendingMovies = MovieService().getTrendingMovies();
    _genresFuture = MovieService().fetchGenres(); // Carrega géneros disponíveis
  }

  // Função chamada sempre que o utilizador altera o texto na barra de pesquisa
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      // Se o campo de pesquisa estiver vazio, limpa os resultados
      _searchMovies =
          query.isNotEmpty ? MovieService().searchMovies(query) : null;
    });
  }

  // Método para filtrar filmes por género
  void _filterMoviesByGenre(int genreId) async {
    if (_selectedGenreId == genreId) {
      // Se o mesmo género for clicado novamente, limpa o filtro
      setState(() {
        _filteredMovies = null; // Remove o filtro
        _selectedGenreId = null;
      });
      return;
    }

    try {
      // Filtra os filmes populares pelo género selecionado
      final movies = await MovieService().getPopularMovies();
      final filtered = movies.where((movie) {
        final genreIds = movie['genre_ids'] as List<dynamic>;
        return genreIds.contains(genreId);
      }).toList();

      setState(() {
        _filteredMovies = filtered;
        _selectedGenreId = genreId; // Atualiza o género selecionado
      });
    } catch (e) {
      // Se houver erro, não faz nada
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Widget para o banner de pesquisa
            SearchBanner(onSearchChanged: _onSearchChanged),
            // Widget para os filtros de género
            GenreFilterWidget(
              genresFuture: _genresFuture,
              selectedGenreId: _selectedGenreId,
              onGenreSelected: _filterMoviesByGenre, // Passa a função de filtro
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: _searchQuery.isNotEmpty
                  ? _buildSearchResults() // resultados da pesquisa
                  : _filteredMovies != null
                      ? _buildMovieList(_filteredMovies!) // filmes filtrados
                      : _buildDefaultLists(), // as listas padrão de filmes
            ),
            const SizedBox(height: 29), // Espaço no final da tela
          ],
        ),
      ),
      // Barra de navegação inferior
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) async {
          setState(() {
            _selectedIndex = index;
          });
          // Navega para a página correspondente
          await NavigationService.handleNavigation(context, index);
        },
      ),
      backgroundColor: AppColors.fundo, // Cor de fundo da página
    );
  }

  // Função para exibir os resultados da pesquisa
  Widget _buildSearchResults() {
    return FutureBuilder<List<dynamic>>(
      future: _searchMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erro na pesquisa.'));
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum filme encontrado.'));
        }

        final searchResults = snapshot.data ?? [];
        return _buildMovieList(searchResults); // Exibe os filmes encontrados
      },
    );
  }

  // Função para exibir as listas de filmes padrão
  Widget _buildDefaultLists() {
    return FutureBuilder<List<List<dynamic>>>(
      future: Future.wait([
        _popularMovies,
        _topMovies,
        _upcomingMovies,
        _trendingMovies,
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar filmes.'));
        }

        // Carrega as listas de filmes
        final popularMovies = snapshot.data![0];
        final topMovies = snapshot.data![1];
        final upcomingMovies = snapshot.data![2];
        final trendingMovies = snapshot.data![3];

        return MovieListWidget(
          popularMovies: popularMovies,
          topMovies: topMovies,
          upcomingMovies: upcomingMovies,
          trendingMovies: trendingMovies,
        );
      },
    );
  }

  // Função para construir uma lista de filmes
  Widget _buildMovieList(List<dynamic> movies) {
    return FutureBuilder<Map<int, String>>(
      future: _genresFuture, // Carrega os géneros dos filmes
      builder: (context, snapshot) {
        final genres = snapshot.data; // Mapa de géneros

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return MovieTile(
              movie: movie,
              isFavorite: isFavorite,
              toggleFavorite: toggleFavorite,
              genres: genres, // Passa os géneros para o MovieTile
            );
          },
        );
      },
    );
  }

  // Verifica se um filme é favorito
  Future<bool> isFavorite(dynamic movie) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null)
        return false; // Se o utilizador não estiver logado, não pode ser favorito

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) return false;

      final data = doc.data() as Map<String, dynamic>;
      final favorites = List<int>.from(data['favorites'] ?? []);
      return favorites
          .contains(movie['id']); // Verifica se o filme está nos favoritos
    } catch (e) {
      return false; // Caso haja erro, retorna false
    }
  }

  // Função para adicionar/remover filmes dos favoritos
  Future<void> toggleFavorite(dynamic movie) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Utilizador não autenticado.');

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          transaction.set(docRef, {
            'favorites': [movie['id']] // Adiciona o filme aos favoritos
          });
          return;
        }

        final data = snapshot.data() as Map<String, dynamic>;
        final favorites = List<int>.from(data['favorites'] ?? []);

        if (favorites.contains(movie['id'])) {
          favorites.remove(movie['id']); // Remove o filme dos favoritos
        } else {
          favorites.add(movie['id']); // Adiciona o filme aos favoritos
        }

        transaction.update(docRef, {'favorites': favorites});
      });
    } catch (e) {
      rethrow; // Lança o erro novamente
    }
  }
}
