import 'package:flutter/material.dart';
import '../styles/app_text.dart';
import '../styles/app_colors.dart';
import '../screens/movie_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MovieListWidget extends StatelessWidget {
  final List<dynamic> popularMovies;
  final List<dynamic> topMovies;

  const MovieListWidget({
    super.key,
    required this.popularMovies,
    required this.topMovies,
  });

  // Função para verificar se o filme é favorito
  Future<bool> isFavorite(dynamic movie) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return false;
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) {
      return false;
    }

    final data = doc.data() as Map<String, dynamic>;
    final favorites = List<int>.from(data['favorites'] ?? []);

    return favorites.contains(movie['id']);
  }

  // Alternar estado de favoritos
  Future<void> toggleFavorite(dynamic movie) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Utilizador não autenticado.');
    }

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
          favorites.remove(movie['id']); // Remove do favorito
        } else {
          favorites.add(movie['id']); // Adiciona aos favoritos
        }

        transaction.update(docRef, {'favorites': favorites});
      });
    } catch (e) {
      print('Erro ao alternar favoritos: $e');
    }
  }

  Widget _buildMovieList(
      String title, List<dynamic> movies, BuildContext context) {
    if (movies.isEmpty) {
      return const Center(child: Text('Nenhum filme disponível.'));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment:
                Alignment.centerLeft, // centerLeft para alinhar a esquerda
            child: Text(
              title,
              style: AppTextStyles.bigText.copyWith(
                color: AppColors.primeiroPlano,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 227, // altura da lista
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // horizontal para a lista
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];

              return Container(
                width: 130, // largura de cada filme
                margin: const EdgeInsets.symmetric(horizontal: 6),
                child: Stack(
                  alignment: const Alignment(1.0, 0.60), // posição do ícon
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navega para a página de detalhes do filme
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailPage(movie: movie),
                          ),
                        );
                      },
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
                                      height: 184,
                                    )
                                  : const Icon(Icons.movie, size: 80),
                            ),
                          ),
                          const SizedBox(height: 11.0),
                          Text(
                            movie['title'] ?? 'Título não disponível',
                            style: AppTextStyles.mediumText.copyWith(
                              color: AppColors.primeiroPlano,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${movie['release_date']?.substring(0, 4) ?? 'N/A'}',
                            style: AppTextStyles.smallText.copyWith(
                              color: AppColors.roxo,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Ícone de favoritos
                    FutureBuilder<bool>(
                      future: isFavorite(movie),
                      builder: (context, snapshot) {
                        final isFav = snapshot.data ?? false;

                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.primeiroPlano,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? AppColors.roxo : AppColors.cinza,
                            ),
                            onPressed: () async {
                              // Alterna o estado do favorito
                              await toggleFavorite(movie);
                            },
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
          const SizedBox(height: 40.0),
          _buildMovieList('Top Filmes', topMovies, context),
        ],
      ),
    );
  }
}
