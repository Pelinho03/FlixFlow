import 'package:flutter/material.dart';

class MovieImagesWidget extends StatelessWidget {
  // Lista de imagens adicionais (não o poster) do filme
  final List<dynamic> images;

  // Caminho da imagem do poster do filme
  final String posterPath;

  // Construtor do widget que exige as imagens e o caminho do poster como parâmetros.
  const MovieImagesWidget({
    super.key,
    required this.images,
    required this.posterPath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 278, // Define a altura do widget
      child: ListView.builder(
        scrollDirection:
            Axis.horizontal, // A lista será exibida horizontalmente.
        itemCount: images.length +
            1, // O número de itens será o número de imagens mais 1 (para o poster).
        itemBuilder: (context, index) {
          // Se for o primeiro item, exibe o poster do filme
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                // ignore: unnecessary_null_comparison
                child: posterPath != null
                    ? Image.network(
                        // Carrega a imagem do poster a partir da URL
                        'https://image.tmdb.org/t/p/w500$posterPath',
                        fit: BoxFit.cover,
                        height: 278,
                      )
                    : const Icon(Icons.movie,
                        size: 80), // Caso o poster não exista, exibe um ícone
              ),
            );
          }

          final image = images[
              index - 1]; // Subtrai 1 para compensar o primeiro item (poster)
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.network(
                // Carrega a imagem
                'https://image.tmdb.org/t/p/w500${image['file_path']}',
                fit: BoxFit.cover,
                width: 458, // Largura fixa para as imagens
              ),
            ),
          );
        },
      ),
    );
  }
}
