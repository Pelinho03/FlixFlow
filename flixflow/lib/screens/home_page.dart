import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../widgets/movie_list_widget.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../services/navigation_service.dart';
import '../styles/app_colors.dart';
// import '../styles/app_text.dart';
// import 'movie_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/search_banner_widget.dart';
import '../widgets/movie_tile_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> _popularMovies;
  late Future<List<dynamic>> _topMovies;
  Future<List<dynamic>>? _searchMovies;
  String _searchQuery = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Inicializa as listas de filmes
    _popularMovies = MovieService().getPopularMovies();
    _topMovies = MovieService().getTopMovies();
  }

  // Método para lidar com pesquisa
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _searchMovies = query.isNotEmpty
          ? MovieService().searchMovies(query)
          : null; // Se a pesquisa estiver vazia, limpa os resultados
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Usa o widget SearchBanner diretamente
            SearchBanner(onSearchChanged: _onSearchChanged),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: _searchQuery.isNotEmpty
                  ? _buildSearchResults() // Resultados da pesquisa
                  : _buildDefaultLists(), // Listas padrão
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

  // Resultados da pesquisa
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

  // Listas padrão (filmes populares e top-rated)
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

  // Exibição de lista de filmes
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
