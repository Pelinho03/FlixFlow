import 'package:flutter/material.dart';
import '../../styles/app_text.dart';
import '../../styles/app_colors.dart';
import '../../screens/movie_details_page.dart';

class MovieTile extends StatefulWidget {
  final dynamic movie;
  final Future<bool> Function(dynamic movie) isFavorite;
  final Future<void> Function(dynamic movie) toggleFavorite;
  final Map<int, String>? genres;
  final Function()? onFavoriteChanged; // Callback para atualizar a pesquisa

  const MovieTile({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.toggleFavorite,
    this.genres,
    this.onFavoriteChanged, // Novo parâmetro opcional
  });

  @override
  _MovieTileState createState() => _MovieTileState();
}

class _MovieTileState extends State<MovieTile> {
  late ValueNotifier<bool> _isFavNotifier;

  @override
  void initState() {
    super.initState();
    _isFavNotifier = ValueNotifier(false);

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
                      Text(
                        widget.movie['title'] ?? 'Título não disponível',
                        style: AppTextStyles.mediumText.copyWith(
                          color: AppColors.primeiroPlano,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        '${widget.movie['release_date']?.substring(0, 4) ?? 'N/A'}',
                        style: AppTextStyles.smallText.copyWith(
                          color: AppColors.roxo,
                        ),
                      ),
                      const SizedBox(height: 8.0),
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
          Positioned(
            bottom: 4, // Ajuste a distância do fundo
            right: 4, // Ajuste a distância da direita
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primeiroPlano,
                borderRadius: BorderRadius.circular(50),
              ),
              child: ValueListenableBuilder<bool>(
                valueListenable: _isFavNotifier,
                builder: (context, isFav, _) {
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? AppColors.roxo : AppColors.cinza,
                    ),
                    onPressed: () async {
                      await widget.toggleFavorite(widget.movie);
                      _isFavNotifier.value = !_isFavNotifier.value;
                      widget.onFavoriteChanged?.call(); // Notifica a pesquisa
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
