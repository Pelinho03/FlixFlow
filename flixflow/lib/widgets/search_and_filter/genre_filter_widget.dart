import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';

class GenreFilterWidget extends StatelessWidget {
  final Future<Map<int, String>>? genresFuture;
  final int? selectedGenreId;
  final Function(int) onGenreSelected;

  const GenreFilterWidget({
    super.key,
    required this.genresFuture,
    required this.selectedGenreId,
    required this.onGenreSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<int, String>>(
      future: genresFuture, // Recebe o Future que traz os géneros
      builder: (context, snapshot) {
        // Quando o Future ainda está carregando, exibe um indicador de progresso
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // Caso haja erro ao carregar os géneros
        else if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar géneros.'));
        }

        // Quando os géneros são carregados, os dados são extraídos
        final genres = snapshot.data ?? {};
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          height: 50,
          child: ListView.builder(
            scrollDirection:
                Axis.horizontal, // Lista horizontal para os géneros
            itemCount: genres.length, // Conta o número de géneros
            itemBuilder: (context, index) {
              final genreId = genres.keys.elementAt(index); // ID do género
              final genreName =
                  genres.values.elementAt(index); // nome do género

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  // Ao pressionar, chama a função `onGenreSelected` passando o ID do género
                  onPressed: () {
                    onGenreSelected(genreId);
                  },
                  style: ElevatedButton.styleFrom(
                    // Altera a cor do botão com base no género selecionado
                    backgroundColor: selectedGenreId == genreId
                        ? AppColors.roxo
                        : AppColors.caixas,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    genreName, // nome do género no botão
                    style: const TextStyle(color: AppColors.primeiroPlano),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
