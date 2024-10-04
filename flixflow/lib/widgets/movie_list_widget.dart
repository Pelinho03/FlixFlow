import 'package:flutter/material.dart';
import '../styles/app_text.dart'; // Suponho que tenhas um ficheiro para os estilos de texto
import '../styles/app_colors.dart'; // Suponho que tenhas um ficheiro para as cores

class MovieListWidget extends StatelessWidget {
  final Future<List<dynamic>> popularMovies;
  final Future<List<dynamic>> topMovies;

  MovieListWidget({required this.popularMovies, required this.topMovies});

  Widget _buildMovieList(String title, Future<List<dynamic>> moviesFuture) {
    return FutureBuilder<List<dynamic>>(
      future: moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Erro ao carregar filmes: ${snapshot.error}'));
        } else {
          final movies = snapshot.data!;
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
              Container(
                height: 300, // Define a altura da lista de filmes
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return Container(
                      width: 140,
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Stack(
                        alignment:
                            Alignment.bottomRight, // Alinhamento do botão
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
                                      : Icon(Icons.movie, size: 80),
                                ),
                              ),
                              SizedBox(height: 4),
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
                          // Botão de like
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primeiroPlano, // Fundo branco
                              borderRadius: BorderRadius.circular(
                                  50), // Bordas arredondadas
                            ),
                            child: IconButton(
                              icon: Icon(Icons.favorite_border,
                                  color: AppColors.roxo), // Cor do ícone
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMovieList('Mais Populares', popularMovies),
          _buildMovieList('Top Filmes', topMovies),
        ],
      ),
    );
  }
}
