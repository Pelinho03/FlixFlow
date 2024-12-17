import 'package:flutter/material.dart';
import '../styles/app_text.dart';
import '../styles/app_colors.dart';
import '../screens/movie_details_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class MovieTile extends StatelessWidget {
  final dynamic movie;
  final Future<bool> Function(dynamic movie) isFavorite;
  final Future<void> Function(dynamic movie) toggleFavorite;

  const MovieTile({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.toggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 6.0),
      child: Stack(
        alignment: const Alignment(-0.48, 0.95), // posição do ícon
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagem do filme
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: movie['poster_path'] != null
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                          fit: BoxFit.cover,
                          width: 148,
                          height: 200,
                        )
                      : const Icon(Icons.movie, size: 80),
                ),
                const SizedBox(width: 10.0),
                // Títulos e detalhes
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie['title'] ?? 'Título não disponível',
                        style: AppTextStyles.mediumText.copyWith(
                          color: AppColors.primeiroPlano,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        '${movie['release_date']?.substring(0, 4) ?? 'N/A'}',
                        style: AppTextStyles.smallText.copyWith(
                          color: AppColors.roxo,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        movie['overview'] ?? 'Sinopse não disponível',
                        style: AppTextStyles.smallText
                            .copyWith(color: AppColors.primeiroPlano),
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Botão de favoritos
          Positioned(
            // bottom: 8,
            // right: 1,
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
    );
  }
}
