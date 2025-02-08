import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/movie_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_text.dart';
import '../widgets/custom_app_bar.dart';
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

  Future<bool> isFavorite(dynamic movie) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists || doc.data() == null) return false;

    final data = doc.data() as Map<String, dynamic>;
    final favoriteIds = (data['favorites'] as List<dynamic>? ?? [])
        .map((e) => e as int)
        .toList();

    return favoriteIds.contains(movie['id']);
  }

  Future<void> toggleFavorite(dynamic movie) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final doc = await userRef.get();

    if (!doc.exists || doc.data() == null) {
      await userRef
          .set({'favorites': []}); // Garante que há um campo 'favorites'
    }

    final data = doc.data() as Map<String, dynamic>;
    final favoriteIds = (data['favorites'] as List<dynamic>? ?? [])
        .map((e) => e as int)
        .toList();

    if (favoriteIds.contains(movie['id'])) {
      favoriteIds.remove(movie['id']);
    } else {
      favoriteIds.add(movie['id']);
    }

    await userRef.update({'favorites': favoriteIds});

    setState(() {
      _favoriteMovies = _getFavoriteMovies(); // Atualiza a lista na UI
    });
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
          movies.add(movie);
        }
      } catch (e) {
        // print('Erro ao buscar filme com ID $id: $e');
      }
    }

    return movies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Meus Favoritos"),
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
            return Center(
                child: Text('Ainda sem favoritos :(',
                    style: AppTextStyles.mediumText
                        .copyWith(color: AppColors.cinza2)));
          }

          final favoriteMovies = snapshot.data ?? [];

          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.50,
            ),
            itemCount: favoriteMovies.length,
            itemBuilder: (context, index) {
              final movie = favoriteMovies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movie: movie),
                    ),
                  );
                },
                child: _buildFavoriteTile(movie),
              );
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
        Container(
          margin: const EdgeInsets.all(8),
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
        const SizedBox(height: 8),
        SizedBox(
          width: 148,
          child: Text(
            movie['title'] ?? 'Título não disponível',
            style: AppTextStyles.mediumText.copyWith(
              color: AppColors.primeiroPlano,
            ),
            maxLines: 3,
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
}
