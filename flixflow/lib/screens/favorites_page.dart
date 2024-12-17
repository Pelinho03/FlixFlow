import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/movie_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_text.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../services/navigation_service.dart';
import 'movie_details_page.dart';
import '../widgets/movie_tile_widget.dart'; // Usando o MovieTile

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

          // Exibindo os filmes em duas colunas
          return GridView.builder(
            padding: const EdgeInsets.symmetric(
                horizontal: 45), // Espaçamento lateral
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Duas colunas
              crossAxisSpacing: 3, // Espaçamento horizontal entre colunas
              mainAxisSpacing: 16, // Espaçamento vertical entre linhas
              childAspectRatio: 0.9, // Controla a proporção largura/altura
            ),
            itemCount: favoriteMovies.length,
            itemBuilder: (context, index) {
              final movie = favoriteMovies[index];
              return _buildFavoriteTile(movie);
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

  // Método para construir cada item de filme
  Widget _buildFavoriteTile(dynamic movie) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailPage(movie: movie),
              ),
            );
          },
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: movie['poster_path'] != null
                    ? Image.network(
                        'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                        fit: BoxFit.cover,
                        width: 148,
                        height: 180, // Altura ajustável
                      )
                    : const Icon(Icons.movie, size: 80),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primeiroPlano,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: FutureBuilder<bool>(
                    future: isFavorite(movie),
                    builder: (context, snapshot) {
                      final isFav = snapshot.data ?? false;
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? AppColors.roxo : AppColors.cinza,
                        ),
                        onPressed: () async {
                          await toggleFavorite(movie);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Título do filme
        SizedBox(
          width: 148,
          child: Text(
            movie['title'] ?? 'Título não disponível',
            style: AppTextStyles.mediumText.copyWith(
              color: AppColors.primeiroPlano,
            ),
            maxLines: 1, // Limita a uma linha
            overflow: TextOverflow.ellipsis, // Trunca o texto se necessário
          ),
        ),
        SizedBox(
          width: 148,
          child: Text(
            '${movie['release_date']?.substring(0, 4) ?? 'N/A'}',
            style: AppTextStyles.smallText.copyWith(
              color: AppColors.roxo,
            ),
            maxLines: 1, // Limita a uma linha
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Verificar se o filme é favorito
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

  // Alternar estado de favoritos
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
