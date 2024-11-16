import 'package:flutter/material.dart';
import '../styles/app_text.dart';
import '../styles/app_colors.dart';
import '../screens/movie_details_page.dart';

class MovieListWidget extends StatelessWidget {
  final List<dynamic> popularMovies;
  final List<dynamic> topMovies;

  const MovieListWidget({
    super.key,
    required this.popularMovies,
    required this.topMovies,
  });

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

              // container para cada filme
              return Container(
                width: 130, // largura de cada filme
                margin: const EdgeInsets.symmetric(horizontal: 6),
                child: Stack(
                  alignment: const Alignment(
                      1.0, 0.60), // alinha o botão no canto inferior direito
                  children: [
                    GestureDetector(
                      onTap: () {
                        // abrir o filme
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailPage(movie: movie),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // capas
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

                          // titulo e data de lançamento ou padroes
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

                    // icon de favoritos
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primeiroPlano,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border,
                            color: AppColors.roxo),
                        onPressed: () {
                          // Implementa a funcionalidade para adicionar aos favoritos
                        },
                      ),
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
