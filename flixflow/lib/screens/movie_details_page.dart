import 'package:flutter/material.dart';
// import '../widgets/custom_bottom_navigation_bar.dart';
import '../services/movie_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_text.dart';

class MovieDetailPage extends StatefulWidget {
  final dynamic movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Future<List<dynamic>> _movieImages;
  late Future<List<String>> _movieGenres; // Variável para os géneros
  final MovieService _movieService =
      MovieService(); // Instância do MovieService

  @override
  void initState() {
    super.initState();
    // Certifica-te que movie['id'] está a retornar um valor válido
    _movieImages = _movieService.fetchMovieImages(widget.movie['id']);
    _movieGenres = _getMovieGenres(widget.movie['genre_ids']);
  }

  // Função para mapear os IDs dos géneros para os respetivos nomes
  Future<List<String>> _getMovieGenres(List<dynamic> genreIds) async {
    try {
      final genresMap =
          await _movieService.fetchGenres(); // Obtem o mapa de géneros
      return genreIds.map((id) => genresMap[id] ?? 'Desconhecido').toList();
    } catch (error) {
      return []; // Retorna uma lista vazia se houver um erro
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie['title'] ?? 'Detalhes do Filme'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26.0),
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
                    final images = snapshot.data!;

                    // Começa com o cartaz do filme
                    return SizedBox(
                      height: 278,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            images.length + 1, // Adicionamos +1 para o cartaz
                        itemBuilder: (context, index) {
                          // O primeiro item será o cartaz do filme
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: widget.movie['poster_path'] != null
                                    ? Image.network(
                                        'https://image.tmdb.org/t/p/w500${widget.movie['poster_path']}',
                                        fit: BoxFit.cover,
                                        // width: 148, // Largura do cartaz
                                        height:
                                            278, // Altura para manter proporcional
                                      )
                                    : const Icon(Icons.movie, size: 80),
                              ),
                            );
                          }

                          // Itens subsequentes serão as imagens do filme
                          final image = images[
                              index - 1]; // Ajustamos o índice para imagens
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500${image['file_path']}',
                                fit: BoxFit.cover,
                                width: 458, // Largura das imagens adicionais
                              ),
                            ),
                          );
                        },
                      ),
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

              // Géneros do Filme
              FutureBuilder<List<String>>(
                future: _movieGenres, // Chama a função que retorna os géneros
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text('Erro ao carregar os géneros.');
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final genres = snapshot.data!;
                    return Text(
                      '${genres.join(', ')}', // Concatena os géneros numa string
                      style: AppTextStyles.regularText.copyWith(
                        color: AppColors.cinza2,
                      ),
                    );
                  } else {
                    return const Text('Géneros não disponíveis.');
                  }
                },
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  // Ano de Lançamento
                  Text(
                    '${widget.movie['release_date']?.substring(0, 4) ?? 'N/A'}',
                    style: AppTextStyles.mediumText.copyWith(
                      color: AppColors.primeiroPlano,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  // Ano de Lançamento
                  Text(
                    '${widget.movie['release_date']?.substring(0, 4) ?? 'N/A'}',
                    style: AppTextStyles.mediumText.copyWith(
                      color: AppColors.primeiroPlano,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    '|',
                    style: AppTextStyles.mediumText
                        .copyWith(color: AppColors.roxo),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.roxo,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    '${widget.movie['release_date']?.substring(0, 4) ?? 'N/A'}',
                    style: AppTextStyles.mediumText.copyWith(
                      color: AppColors.primeiroPlano,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 11.0),

              // Descrição do Filme
              Text(
                widget.movie['overview'] ?? 'Sem descrição disponível.',
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
