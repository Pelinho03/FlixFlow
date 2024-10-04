import 'package:flutter/material.dart';
import '../styles/app_text.dart'; // Suponho que tenhas um ficheiro para os estilos de texto
import '../styles/app_colors.dart'; // Suponho que tenhas um ficheiro para as cores

class MovieListWidget extends StatelessWidget {
  final List<dynamic> popularMovies; // Agora uma lista em vez de Future
  final List<dynamic> topMovies; // Agora uma lista em vez de Future

  const MovieListWidget({
    super.key,
    required this.popularMovies,
    required this.topMovies,
  });

  // Mantém o método _buildMovieList igual, mas agora aceita uma lista de filmes
  Widget _buildMovieList(String title, List<dynamic> movies) {
    if (movies.isEmpty) {
      return const Center(child: Text('Nenhum filme disponível.'));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: AppTextStyles.bigText.copyWith(
                color: AppColors.primeiroPlano,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 227,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Container(
                width: 130,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  alignment: const Alignment(1.0, 0.60),
                  children: [
                    Column(
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
          _buildMovieList('Mais Populares', popularMovies),
          const SizedBox(height: 40.0),
          _buildMovieList('Top Filmes', topMovies),
        ],
      ),
    );
  }
}
