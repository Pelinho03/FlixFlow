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

  Future<List<dynamic>> _getFavoriteMovies() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return [];
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists || doc.data() == null) {
      return [];
    }

    final data = doc.data() as Map<String, dynamic>;
    final favoriteIds =
        (data['favorites'] as List<dynamic>?)?.map((e) => e as int).toList() ??
            [];

    if (favoriteIds.isEmpty) {
      return [];
    }

    return await _fetchMoviesByIds(favoriteIds);
  }

  Future<List<dynamic>> _fetchMoviesByIds(List<int> ids) async {
    final movies = <dynamic>[];

    for (final id in ids) {
      try {
        final movie = await MovieService().getMovieById(id);

        if (movie != null) {
          movies.add({
            ...movie,
            'genres': (movie['genres'] as List<dynamic>?) ?? [],
            'production_companies':
                (movie['production_companies'] as List<dynamic>?) ?? [],
            'spoken_languages':
                (movie['spoken_languages'] as List<dynamic>?) ?? [],
            'backdrop_path': movie['backdrop_path'] ?? '',
            'poster_path': movie['poster_path'] ?? '',
            'overview': movie['overview'] ?? 'Sem descrição disponível.',
            'belongs_to_collection': movie['belongs_to_collection'] ?? {},
          });
        } else {
          print('Filme com ID $id não encontrado.');
        }
      } catch (e) {
        print('Erro ao buscar filme com ID $id: $e');
      }
    }

    return movies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus favoritos"),
        titleTextStyle: AppTextStyles.mediumAppBar.copyWith(
          color: AppColors.primeiroPlano,
        ),
        titleSpacing: 0.0,
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
        elevation: 0.0,
        backgroundColor: AppColors.caixas,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _favoriteMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Erro ao carregar favoritos: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum filme nos favoritos.'));
          }

          final favoriteMovies = snapshot.data ?? [];

          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16, // Espaçamento horizontal entre os itens
              mainAxisSpacing: 16, // Espaçamento vertical entre os itens
              childAspectRatio: 0.75, // Proporção entre largura e altura
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
        selectedIndex: 1,
        onItemTapped: (index) async {
          await NavigationService.handleNavigation(context, index);
        },
      ),
    );
  }

  Widget _buildFavoriteTile(dynamic movie) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            print('Filme selecionado para detalhes: $movie');

            if (movie != null && movie['title'] != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailPage(movie: movie),
                ),
              );
            } else {
              print('Erro: dados do filme estão incompletos!');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Erro ao carregar detalhes do filme.')),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.all(8), // Margem ao redor de cada item
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: movie['poster_path'] != null
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                          fit: BoxFit.cover,
                          width: 148,
                          height: 228,
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
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 148,
          child: Text(
            movie['title'] ?? 'Título não disponível',
            style: AppTextStyles.mediumText.copyWith(
              color: AppColors.primeiroPlano,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          width: 148,
          child: Text(
            '${movie['release_date']?.substring(0, 4) ?? 'N/A'}',
            style: AppTextStyles.smallText.copyWith(
              color: AppColors.roxo,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
          setState(() {
            _favoriteMovies = Future.value(
                (_favoriteMovies as Future<List<dynamic>>).then((movies) {
              return movies.where((m) => m['id'] != movie['id']).toList();
            }));
          });
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
