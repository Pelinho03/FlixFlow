import 'package:flutter/material.dart';
import '../styles/app_text.dart';
import '../styles/app_colors.dart';
import '../screens/movie_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MovieListWidget extends StatefulWidget {
  final List<dynamic> popularMovies;
  final List<dynamic> topMovies;

  const MovieListWidget({
    super.key,
    required this.popularMovies,
    required this.topMovies,
  });

  @override
  _MovieListWidgetState createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  late List<dynamic> popularMovies;
  late List<dynamic> topMovies;
  final double bannerRatio = 4.0; // Define a proporção do banner

  @override
  void initState() {
    super.initState();
    popularMovies = widget.popularMovies;
    topMovies = widget.topMovies;
  }

  Future<bool> isFavorite(dynamic movie) async {
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
  }

  Future<void> toggleFavorite(dynamic movie) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

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

        favorites.contains(movie['id'])
            ? favorites.remove(movie['id'])
            : favorites.add(movie['id']);
        transaction.update(docRef, {'favorites': favorites});
      });

      setState(() {});
    } catch (e) {
      print('Erro ao alternar favoritos: $e');
    }
  }

  Widget _buildMovieList(
      String title, List<dynamic> movies, BuildContext context) {
    if (movies.isEmpty)
      return const Center(child: Text('Nenhum filme disponível.'));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(title,
                style: AppTextStyles.bigText
                    .copyWith(color: AppColors.primeiroPlano)),
          ),
        ),
        SizedBox(
          height: 228,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];

              return Container(
                width: 130,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                child: Stack(
                  alignment: const Alignment(1.0, 0.60),
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailPage(movie: movie)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
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
                          ),
                          const SizedBox(height: 11.0),
                          Text(movie['title'] ?? 'Título não disponível',
                              style: AppTextStyles.mediumText
                                  .copyWith(color: AppColors.primeiroPlano),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Text(
                              '${movie['release_date']?.substring(0, 4) ?? 'N/A'}',
                              style: AppTextStyles.smallText
                                  .copyWith(color: AppColors.roxo)),
                        ],
                      ),
                    ),
                    FutureBuilder<bool>(
                      future: isFavorite(movie),
                      builder: (context, snapshot) {
                        final isFav = snapshot.data ?? false;
                        final user = FirebaseAuth.instance.currentUser;

                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.primeiroPlano,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            icon: Icon(
                              snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? Icons.favorite_border
                                  : (isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border),
                              color: isFav ? AppColors.roxo : AppColors.cinza,
                            ),
                            onPressed: user != null
                                ? () => toggleFavorite(movie)
                                : null,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMovieList('Mais Populares', popularMovies, context),
          const SizedBox(height: 15.0),
          const Divider(height: 15, color: AppColors.roxo, thickness: 0.1),
          const SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double bannerHeight = constraints.maxWidth / bannerRatio;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/imgs/banner_homepage_v2.png',
                    width: constraints.maxWidth,
                    height: bannerHeight,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 15.0),
          const Divider(height: 15, color: AppColors.roxo, thickness: 0.1),
          _buildMovieList('Top Filmes', topMovies, context),
        ],
      ),
    );
  }
}
