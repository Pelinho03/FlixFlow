import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../widgets/movie_list_widget.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../services/navigation_service.dart';
import '../styles/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/search_banner_widget.dart';
import '../widgets/movie_tile_widget.dart';
import '../widgets/genre_filter_widget.dart'; // Importa o novo widget

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> _popularMovies;
  late Future<List<dynamic>> _topMovies;
  Future<List<dynamic>>? _searchMovies;
  Future<Map<int, String>>? _genresFuture;
  List<dynamic>? _filteredMovies; // Lista de filmes filtrados
  String _searchQuery = '';
  int _selectedIndex = 0;
  int? _selectedGenreId;

  @override
  void initState() {
    super.initState();
    _popularMovies = MovieService().getPopularMovies();
    _topMovies = MovieService().getTopMovies();
    _genresFuture = MovieService().fetchGenres();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _searchMovies = query.isNotEmpty
          ? MovieService().searchMovies(query)
          : null; // Se vazio, limpa os resultados
    });
  }

  // Método para filtrar filmes por género
  void _filterMoviesByGenre(int genreId) async {
    try {
      final movies = await MovieService().getPopularMovies();
      final filtered = movies.where((movie) {
        final genreIds = movie['genre_ids'] as List<dynamic>;
        return genreIds.contains(genreId);
      }).toList();

      setState(() {
        _filteredMovies = filtered;
        _selectedGenreId = genreId;
      });
    } catch (e) {
      print('Erro ao filtrar filmes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchBanner(onSearchChanged: _onSearchChanged),
            GenreFilterWidget(
              genresFuture: _genresFuture,
              selectedGenreId: _selectedGenreId,
              onGenreSelected: _filterMoviesByGenre, // Passa a função de filtro
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: _searchQuery.isNotEmpty
                  ? _buildSearchResults()
                  : _filteredMovies != null
                      ? _buildMovieList(_filteredMovies!)
                      : _buildDefaultLists(),
            ),
            const SizedBox(height: 29),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) async {
          setState(() {
            _selectedIndex = index;
          });
          await NavigationService.handleNavigation(context, index);
        },
      ),
      backgroundColor: AppColors.fundo,
    );
  }

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
        return _buildMovieList(searchResults);
      },
    );
  }

  Widget _buildDefaultLists() {
    return FutureBuilder<List<List<dynamic>>>(
      future: Future.wait([_popularMovies, _topMovies]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar filmes.'));
        }

        final popularMovies = snapshot.data![0];
        final topMovies = snapshot.data![1];

        return MovieListWidget(
          popularMovies: popularMovies,
          topMovies: topMovies,
        );
      },
    );
  }

  Widget _buildMovieList(List<dynamic> movies) {
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
        );
      },
    );
  }

  Future<bool> isFavorite(dynamic movie) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) return false;

      final data = doc.data() as Map<String, dynamic>;
      final favorites = List<int>.from(data['favorites'] ?? []);
      return favorites.contains(movie['id']);
    } catch (e) {
      return false;
    }
  }

  Future<void> toggleFavorite(dynamic movie) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Utilizador não autenticado.');

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          transaction.set(docRef, {
            'favorites': [movie['id']]
          });
          return;
        }

        final data = snapshot.data() as Map<String, dynamic>;
        final favorites = List<int>.from(data['favorites'] ?? []);

        if (favorites.contains(movie['id'])) {
          favorites.remove(movie['id']);
        } else {
          favorites.add(movie['id']);
        }

        transaction.update(docRef, {'favorites': favorites});
      });
    } catch (e) {
      rethrow;
    }
  }
}
