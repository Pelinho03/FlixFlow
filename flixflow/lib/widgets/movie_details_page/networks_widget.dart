import 'package:flutter/material.dart';
import '../../services/movie_service.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_text.dart';

class MovieNetworksWidget extends StatefulWidget {
  final int movieId;

  const MovieNetworksWidget({super.key, required this.movieId});

  @override
  _MovieNetworksWidgetState createState() => _MovieNetworksWidgetState();
}

class _MovieNetworksWidgetState extends State<MovieNetworksWidget> {
  // Future que armazena os dados das plataformas de streaming para o filme
  late Future<List<dynamic>> _movieNetworks;
  // Serviço para obter as plataformas de streaming
  final MovieService _movieService = MovieService();

  @override
  void initState() {
    super.initState();
    // Inicializa a future com a chamada ao serviço para obter as plataformas
    _movieNetworks = _movieService.getMovieNetworks(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _movieNetworks, // Passa a future para o FutureBuilder
      builder: (context, snapshot) {
        // Caso a requisição ainda esteja a carregar
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // Caso haja um erro na requisição
        else if (snapshot.hasError) {
          return const Text('Erro ao carregar as plataformas.');
        }
        // Se a requisição foi bem-sucedida e há dados
        else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          // Remove plataformas duplicadas
          var uniqueNetworks = snapshot.data!.toSet().toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Disponível em',
                style: AppTextStyles.bigText.copyWith(color: AppColors.roxo),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                // Exibe as plataformas de streaming
                children: uniqueNetworks.map((network) {
                  return Chip(
                    label: Text(network['provider_name'],
                        style: AppTextStyles.regularText),
                    // Exibe o logo da plataforma
                    avatar: network['logo_path'] != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                              'https://image.tmdb.org/t/p/w200${network['logo_path']}',
                            ),
                          )
                        : null,
                    backgroundColor: AppColors.caixas,
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Text(
                '· Dados fornecidos por JustWatch',
                style:
                    AppTextStyles.smallText.copyWith(color: AppColors.cinza2),
              ),
            ],
          );
        } else {
          // Caso não existam plataformas para o filme
          const SizedBox(height: 20);
          return Center(
              child: Text('Plataforma disponível brevemente.',
                  style: AppTextStyles.mediumText
                      .copyWith(color: AppColors.cinza2)));
        }
      },
    );
  }
}
