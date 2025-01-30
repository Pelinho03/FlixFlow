import 'package:flutter/material.dart';
import '../services/navigation_service.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../services/movie_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_text.dart';
import '../widgets/comments_widget.dart';
import '../widgets/movie_images_widget.dart';
import '../widgets/movie_rating_widget.dart';
import '../widgets/movie_genres_widget.dart';
import '../widgets/movie_details_widget.dart';
import '../widgets/youtube_player_widget.dart';
import '../widgets/movie_cast_widget.dart';

class MovieDetailPage extends StatefulWidget {
  final dynamic movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Future<List<dynamic>> _movieImages;
  late Future<List<String>> _movieGenres;
  late Future<Map<String, String>> _movieCredits;
  late Future<dynamic> _movieDetails;
  late Future<String?> _movieTrailer;
  late Future<List<dynamic>> _movieCast;
  final MovieService _movieService = MovieService();

  @override
  void initState() {
    super.initState();
    _movieImages = _movieService.fetchMovieImages(widget.movie['id']);
    _movieGenres = _getMovieGenres(widget.movie['genre_ids']);
    _movieCredits = _movieService.getMovieCredits(widget.movie['id']);
    _movieDetails = _movieService.getMovieById(widget.movie['id']);
    _movieTrailer = _movieService.fetchMovieTrailer(widget.movie['id']);
    _movieCast = _movieService.getMovieCast(widget.movie['id']);
  }

  Future<List<String>> _getMovieGenres(List<dynamic> genreIds) async {
    try {
      final genresMap = await _movieService.fetchGenres();
      return genreIds.map((id) => genresMap[id] ?? 'Desconhecido').toList();
    } catch (error) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie['title'] ?? 'Detalhes do Filme'),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagens do Filme
              FutureBuilder<List<dynamic>>(
                future: _movieImages,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Erro ao carregar imagens.'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return MovieImagesWidget(
                      images: snapshot.data!,
                      posterPath: widget.movie['poster_path'],
                    );
                  } else {
                    return const Center(
                        child: Text('Sem imagens disponíveis.'));
                  }
                },
              ),

              const SizedBox(height: 11.0),

              // Título do Filme
              Text(
                widget.movie['title'] ?? 'Título não disponível',
                style: AppTextStyles.bigText.copyWith(
                  color: AppColors.roxo,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 5),

              // Sistema de classificação por estrelas (dinâmico)
              FutureBuilder<dynamic>(
                future: _movieDetails,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  } else if (snapshot.hasError) {
                    return const SizedBox.shrink();
                  } else if (snapshot.hasData) {
                    final rating = snapshot.data!['vote_average'] ?? 0.0;
                    return MovieRatingWidget(rating: rating);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const SizedBox(height: 5),

              // Géneros do Filme
              FutureBuilder<List<String>>(
                future: _movieGenres,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text('Erro ao carregar os géneros.');
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return MovieGenresWidget(genres: snapshot.data!);
                  } else {
                    return const Text('Géneros não disponíveis.');
                  }
                },
              ),
              const SizedBox(height: 8),

              // Ano de Lançamento e Duração
              // Ano de Lançamento e País de Origem
              Row(
                children: [
                  // Ano de Lançamento
                  Text(
                    '${widget.movie['release_date']?.substring(0, 4) ?? 'N/A'}',
                    style: AppTextStyles.mediumText.copyWith(
                      color: AppColors.primeiroPlano,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // País de Origem
                  FutureBuilder<dynamic>(
                    future: _movieDetails,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      } else if (snapshot.hasError) {
                        return const Text('N/A');
                      } else if (snapshot.hasData) {
                        final countries =
                            snapshot.data!['production_countries'];
                        final countryName = countries.isNotEmpty
                            ? countries[0]['name'] ?? 'N/A'
                            : 'N/A';
                        return Text(
                          countryName.toUpperCase(),
                          style: AppTextStyles.mediumText.copyWith(
                            color: AppColors.primeiroPlano,
                          ),
                        );
                      } else {
                        return const Text('N/A');
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '|',
                    style: AppTextStyles.mediumText
                        .copyWith(color: AppColors.roxo),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.roxo,
                  ),
                  const SizedBox(width: 8),
                  // Duração do Filme
                  FutureBuilder<dynamic>(
                    future: _movieDetails,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      } else if (snapshot.hasError) {
                        return const Text('N/A');
                      } else if (snapshot.hasData) {
                        final runtime = snapshot.data!['runtime'];
                        return Text(
                          runtime != null ? '$runtime min' : 'N/A',
                          style: AppTextStyles.mediumText.copyWith(
                            color: AppColors.primeiroPlano,
                          ),
                        );
                      } else {
                        return const Text('N/A');
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 11.0),

              // Descrição do Filme
              Text(
                widget.movie['overview'] ?? 'Sem descrição disponível.',
                style: AppTextStyles.regularText
                    .copyWith(color: AppColors.primeiroPlano),
              ),

              const Divider(
                height: 40,
                color: AppColors.roxo,
                thickness: 0.1,
              ),

              // Detalhes do Filme (Diretor, Produtoras, Música)
              FutureBuilder<dynamic>(
                future: _movieDetails,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text('Erro ao carregar detalhes do filme.');
                  } else if (snapshot.hasData) {
                    final movieDetails = snapshot.data!;
                    final productionCompanies =
                        movieDetails['production_companies'] as List<dynamic>;
                    final producerNames = productionCompanies
                        .map((company) => company['name'])
                        .join(', ');

                    return FutureBuilder<Map<String, String>>(
                      future: _movieCredits,
                      builder: (context, creditsSnapshot) {
                        if (creditsSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (creditsSnapshot.hasError) {
                          return const Text(
                              'Erro ao carregar créditos do filme.');
                        } else if (creditsSnapshot.hasData) {
                          return MovieDetailsWidget(
                            credits: creditsSnapshot.data!,
                            originalLanguage: widget.movie['original_language'],
                            producerNames: producerNames,
                          );
                        } else {
                          return const Text('Créditos não disponíveis.');
                        }
                      },
                    );
                  } else {
                    return const Text('Detalhes do filme não disponíveis.');
                  }
                },
              ),

              const Divider(
                height: 40,
                color: AppColors.roxo,
                thickness: 0.1,
              ),
              const SizedBox(height: 20),

              // Elenco - Lista Horizontal
              FutureBuilder<List<dynamic>>(
                future: _movieCast,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Erro ao carregar elenco.'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return MovieCastWidget(cast: snapshot.data!);
                  } else {
                    return const Center(child: Text('Sem elenco disponível.'));
                  }
                },
              ),

              const SizedBox(height: 20),

              //Trailer
              FutureBuilder<String?>(
                future: _movieTrailer,
                builder: (context, snapshot) {
                  if (snapshot.hasError || snapshot.data == null) {
                    return const Center(child: Text('Trailer não disponível.'));
                  } else {
                    final videoId = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trailer',
                          style: AppTextStyles.bigText
                              .copyWith(color: AppColors.roxo),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 250,
                          width: double.infinity,
                          child: YoutubePlayerWidget(videoId: videoId),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }
                },
              ),

              const SizedBox(height: 50),

              // Comentários
              Center(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.caixas,
                  ),
                  height: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Comentários',
                        style: AppTextStyles.bigText
                            .copyWith(color: AppColors.roxo),
                      ),
                      const SizedBox(height: 10),
                      const Expanded(
                        child: Comentarios(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 0,
        onItemTapped: (index) async {
          await NavigationService.handleNavigation(context, index);
        },
      ),
    );
  }
}
