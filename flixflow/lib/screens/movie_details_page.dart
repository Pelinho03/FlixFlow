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
  final MovieService _movieService =
      MovieService(); // Cria uma instância de MovieService

  @override
  void initState() {
    super.initState();
    // Certifica-te que movie['id'] está a retornar um valor válido
    _movieImages = _movieService.fetchMovieImages(
        widget.movie['id']); // Chama o método através da instância
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
                                width: 185,
                                height: 278,
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
              Text(
                widget.movie['title'] ?? 'Título não disponível',
                style: AppTextStyles.mediumText.copyWith(
                  color: AppColors.primeiroPlano,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${widget.movie['release_date']?.substring(0, 4) ?? 'N/A'}',
                style: AppTextStyles.smallText.copyWith(
                  color: AppColors.roxo,
                ),
              ),
              const SizedBox(height: 190.0),
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
