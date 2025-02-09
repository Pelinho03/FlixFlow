import 'package:flutter/material.dart';
import '../../styles/app_text.dart';
import '../../styles/app_colors.dart';
import '../../screens/movie_details_page.dart';

class MovieTile extends StatefulWidget {
  // A estrutura que descreve um filme
  final dynamic movie;
  // Função para verificar se o filme é favorito
  final Future<bool> Function(dynamic movie) isFavorite;
  // Função para alternar o estado de favorito do filme
  final Future<void> Function(dynamic movie) toggleFavorite;
  // Um mapa opcional de géneros
  final Map<int, String>? genres;
  // Função callback para notificar quando o favorito for alterado
  final Function()? onFavoriteChanged;

  const MovieTile({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.toggleFavorite,
    this.genres,
    this.onFavoriteChanged,
  });

  @override
  _MovieTileState createState() => _MovieTileState();
}

class _MovieTileState extends State<MovieTile> {
  // Notificador para o estado do favorito
  late ValueNotifier<bool> _isFavNotifier;

  @override
  void initState() {
    super.initState();
    _isFavNotifier = ValueNotifier(false);

    // Verifica se o filme é favorito e atualiza o notificador
    widget.isFavorite(widget.movie).then((isFav) {
      _isFavNotifier.value = isFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 6.0),
      child: Stack(
        alignment: Alignment.center, // Alinhamento centralizado para a Stack
        children: [
          GestureDetector(
            // Quando o filme é clicado, navega para a página de detalhes
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailPage(movie: widget.movie),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Exibe a imagem do poster do filme ou um ícone caso não haja imagem
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: widget.movie['poster_path'] != null
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w500${widget.movie['poster_path']}',
                          fit: BoxFit.cover,
                          width: 148,
                          height: 200,
                        )
                      : const Icon(Icons.movie, size: 80),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Exibe o título do filme
                      Text(
                        widget.movie['title'] ?? 'Título não disponível',
                        style: AppTextStyles.mediumText.copyWith(
                          color: AppColors.primeiroPlano,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      // Exibe o ano de lançamento do filme (extrai do release_date)
                      Text(
                        '${widget.movie['release_date']?.substring(0, 4) ?? 'N/A'}',
                        style: AppTextStyles.smallText.copyWith(
                          color: AppColors.roxo,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Exibe a sinopse do filme, truncada em 6 linhas
                      Text(
                        widget.movie['overview'] ?? 'Sinopse não disponível',
                        style: AppTextStyles.smallText.copyWith(
                          color: AppColors.primeiroPlano,
                        ),
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Botão de favorito, posicionado no canto inferior direito
          Positioned(
            bottom: 4, // Distância do fundo
            right: 4, // Distância da direita
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primeiroPlano,
                borderRadius: BorderRadius.circular(50),
              ),
              child: ValueListenableBuilder<bool>(
                // Observa o estado do favorito
                valueListenable: _isFavNotifier,
                builder: (context, isFav, _) {
                  return IconButton(
                    // Exibe ícone de coração preenchido ou vazio dependendo do estado
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? AppColors.roxo : AppColors.cinza,
                    ),
                    onPressed: () async {
                      // Alterna o estado de favorito
                      await widget.toggleFavorite(widget.movie);
                      _isFavNotifier.value = !_isFavNotifier.value;
                      // Chama o callback para notificar a mudança de favorito
                      widget.onFavoriteChanged?.call();
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
