import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/movie_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_text.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../services/navigation_service.dart';
import 'movie_details_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List<dynamic>> _favoriteMovies;

  @override
  void initState() {
    super.initState();
    _favoriteMovies = _getFavoriteMovies();
  }

  // Método para carregar os filmes favoritos
  Future<List<dynamic>> _getFavoriteMovies() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return []; // Se o utilizador não está autenticado
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) {
      return []; // Caso o utilizador não tenha favoritos
    }

    final data = doc.data() as Map<String, dynamic>;
    final favoriteIds = List<int>.from(data['favorites'] ?? []);

    if (favoriteIds.isEmpty) {
      return []; // Se não houver filmes favoritos
    }

    // Buscar os detalhes dos filmes favoritos (API)
    return _fetchMoviesByIds(favoriteIds);
  }

  // Buscar filmes por ID (pode ser otimizado dependendo da API)
  Future<List<dynamic>> _fetchMoviesByIds(List<int> ids) async {
    final movies = <dynamic>[];
    for (final id in ids) {
      final movie = await MovieService().getMovieById(id);
      if (movie != null) {
        movies.add(movie);
      }
    }
    return movies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _favoriteMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar favoritos.'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum filme nos favoritos.'));
          }

          final favoriteMovies = snapshot.data!;

          return ListView.builder(
            itemCount: favoriteMovies.length,
            itemBuilder: (context, index) {
              final movie = favoriteMovies[index];
              return ListTile(
                leading: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                  fit: BoxFit.cover,
                  width: 50, // Ajuste do tamanho da imagem
                  height: 75, // Ajuste do tamanho da imagem
                ),
                title: Text(movie['title'] ?? 'Título não disponível'),
                subtitle: Text(
                  movie['release_date']?.substring(0, 4) ??
                      'Ano não disponível',
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movie: movie),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 1, // Índice do botão Favoritos
        onItemTapped: (index) async {
          await NavigationService.handleNavigation(context, index);
        },
      ),
    );
  }
}
