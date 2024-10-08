import 'package:flutter/material.dart';
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
  late Future<List<String>>
      _movieGenres; // Adiciona uma variável para os géneros
  final MovieService _movieService =
      MovieService(); // Cria uma instância de MovieService

  @override
  void initState() {
    super.initState();
    // Certifica-te que movie['id'] está a retornar um valor válido
    _movieImages = _movieService.fetchMovieImages(widget.movie['id']);
    _movieGenres = _movieService
        .getMovieGenres(widget.movie['id']); // Chama o método para géneros
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie['title'] ?? 'Detalhes do Filme'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 26.0), // Espaçamento lateral de 26 unidades
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
                    return SizedBox(
                      height: 278,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          final image = images[index];
                          return Padding(
                            padding: const EdgeInsets.all(
                                4.0), // Espaçamento entre imagens
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500${image['file_path']}',
                                fit: BoxFit.cover,
                                width: 458,
                                // height: 10,
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

              // Ano de Lançamento
              Text(
                '${widget.movie['release_date']?.substring(0, 4) ?? 'N/A'}',
                style: AppTextStyles.mediumText.copyWith(
                  color: AppColors.primeiroPlano,
                ),
              ),

              // Género do filme
              Text(
                movie['genre_ids']
                style: AppTextStyles.mediumText.copyWith(color: AppColors.primeiroPlano).
              ),

              // Géneros do Filme
              // FutureBuilder<List<String>>(
              //   future: _movieGenres, // Chama a função que retorna os géneros
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const Center(child: CircularProgressIndicator());
              //     } else if (snapshot.hasError) {
              //       return const Text('Erro ao carregar os géneros.');
              //     } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              //       final genres = snapshot.data!;
              //       return Text(
              //         'Géneros: ${genres.join(', ')}', // Concatena os géneros numa string
              //         style: AppTextStyles.mediumText.copyWith(
              //           color: AppColors.primeiroPlano,
              //         ),
              //       );
              //     } else {
              //       return const Text('Géneros não disponíveis.');
              //     }
              //   },
              // ),

              const SizedBox(height: 20.0),

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
