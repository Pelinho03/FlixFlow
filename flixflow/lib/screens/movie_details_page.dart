import 'package:flutter/material.dart';
import '../services/navigation_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/movie_details_page/comments_widget_v2.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../services/movie_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_text.dart';
import '../widgets/movie_details_page/movie_images_widget.dart';
import '../widgets/movie_details_page/movie_rating_widget.dart';
import '../widgets/movie_details_page/movie_genres_widget.dart';
import '../widgets/movie_details_page/movie_details_widget.dart';
import '../widgets/movie_details_page/networks_widget.dart';
import '../widgets/movie_details_page/youtube_player_widget.dart';
import '../widgets/movie_details_page/movie_cast_widget.dart';
import '../widgets/movie_details_page/personal_rating_widget.dart';

class MovieDetailPage extends StatefulWidget {
  final dynamic movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Future<List<dynamic>> _movieImages; // Carregar as imagens do filme
  late Future<List<String>> _movieGenres; // Carregar os géneros do filme
  late Future<Map<String, String>>
      _movieCredits; // Carregar os créditos do filme
  late Future<dynamic> _movieDetails; // Carregar os detalhes do filme
  late Future<String?> _movieTrailer; // Carregar o trailer do filme
  late Future<List<dynamic>> _movieCast; // Carregar o elenco do filme
  final MovieService _movieService =
      MovieService(); // Serviço para obter dados do filme

  @override
  void initState() {
    super.initState();
    // Inicializa as variáveis com os dados do filme
    _movieImages = _movieService.fetchMovieImages(widget.movie['id']);
    _movieGenres =
        _getMovieGenres(widget.movie['genre_ids'] ?? []); // <-- Corrigido aqui
    _movieCredits = _movieService.getMovieCredits(widget.movie['id']);
    _movieDetails = _movieService.getMovieById(widget.movie['id']);
    _movieTrailer = _movieService.fetchMovieTrailer(widget.movie['id']);
    _movieCast = _movieService.getMovieCast(widget.movie['id']);
  }

  // Função para obter os géneros do filme com base no IDs
  Future<List<String>> _getMovieGenres(List<dynamic>? genreIds) async {
    try {
      final genresMap =
          await _movieService.fetchGenres(); // Buscar todos os géneros
      return (genreIds ?? [])
          .map((id) =>
              genresMap[id] ??
              'Desconhecido') // Mapear o ID para o nome do género
          .toList();
    } catch (error) {
      return []; // Retorna lista vazia em caso de erro
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
            widget.movie['title'] ?? 'Detalhes do Filme'), // Título do filme
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exibindo as imagens do filme
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

              Row(
                children: [
                  // Título do filme
                  Expanded(
                    child: Text(
                      widget.movie['title'] ?? 'Título não disponível',
                      style: AppTextStyles.bigText.copyWith(
                        color: AppColors.roxo,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Exibindo a classificação do filme
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
                ],
              ),

              const Divider(
                height: 20,
                color: AppColors.roxo,
                thickness: 0.1,
              ),

              // Sistema de classificação pessoal
              RatingWidget(movieId: widget.movie['id'].toString()),

              const Divider(
                height: 20,
                color: AppColors.roxo,
                thickness: 0.1,
              ),

              // Exibindo os géneros do filme
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

              // Exibindo o ano de lançamento e o país de origem
              Row(
                children: [
                  // Ano de lançamento
                  Text(
                    '${widget.movie['release_date']?.substring(0, 4) ?? 'N/A'}',
                    style: AppTextStyles.mediumText.copyWith(
                      color: AppColors.primeiroPlano,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Exibindo o país de origem
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
                        // Exibe um espaço vazio enquanto os dados são carregados
                        return const SizedBox.shrink();
                      } else if (snapshot.hasError) {
                        // Caso haja um erro, retorna "N/A"
                        return const Text('N/A');
                      } else if (snapshot.hasData) {
                        // Se os dados forem recebidos, exibe a duração
                        final runtime = snapshot.data!['runtime'];
                        return Text(
                          runtime != null ? '$runtime min' : 'N/A',
                          style: AppTextStyles.mediumText.copyWith(
                            color: AppColors.primeiroPlano,
                          ),
                        );
                      } else {
                        // Se não houver dados, retorna "N/A"
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
                    // Exibe um indicador de carregamento enquanto os dados são recebidos
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Caso ocorra um erro, exibe mensagem de erro
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
                height: 30,
                color: AppColors.roxo,
                thickness: 0.1,
              ),

              // Networks (plataformas onde o filme está disponível)
              MovieNetworksWidget(
                movieId: widget.movie['id'],
              ),

              const SizedBox(height: 10),

              const Divider(
                height: 20,
                color: AppColors.roxo,
                thickness: 0.1,
              ),
              const SizedBox(height: 10),

              // Elenco - Lista Horizontal
              FutureBuilder<List<dynamic>>(
                future: _movieCast,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Exibe um indicador de carregamento enquanto os dados do elenco são recebidos
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Se houver erro, exibe uma mensagem de erro
                    return const Center(
                        child: Text('Erro ao carregar elenco.'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    // Caso tenha dados, exibe a lista de atores
                    return MovieCastWidget(cast: snapshot.data!);
                  } else {
                    // Se não houver dados, exibe uma mensagem
                    return Center(
                        child: Text('Elenco não disponível.',
                            style: AppTextStyles.mediumText
                                .copyWith(color: AppColors.cinza2)));
                  }
                },
              ),

              const Divider(
                height: 30,
                color: AppColors.roxo,
                thickness: 0.1,
              ),
              const SizedBox(height: 20),

              // Trailer
              FutureBuilder<String?>(
                future: _movieTrailer,
                builder: (context, snapshot) {
                  if (snapshot.hasError || snapshot.data == null) {
                    // Se não houver trailer, exibe uma mensagem
                    return Center(
                        child: Text('Trailer não disponível.',
                            style: AppTextStyles.mediumText
                                .copyWith(color: AppColors.cinza2)));
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

              const SizedBox(height: 20),

              // Comentários
              Text(
                'Comentários',
                style: AppTextStyles.bigText.copyWith(color: AppColors.roxo),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.caixas,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      // Widget de Comentários para o filme
                      CommentWidget(
                        movieId: widget.movie['id'].toString(),
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
      // Barra de navegação personalizada na parte inferior
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 0,
        onItemTapped: (index) async {
          await NavigationService.handleNavigation(context, index);
        },
      ),
    );
  }
}
