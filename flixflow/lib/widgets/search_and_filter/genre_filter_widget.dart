import 'package:flutter/material.dart';
// import '../services/movie_service.dart';
import '../../styles/app_colors.dart';

class GenreFilterWidget extends StatelessWidget {
  final Future<Map<int, String>>? genresFuture;
  final int? selectedGenreId;
  final Function(int) onGenreSelected;

  const GenreFilterWidget({
    Key? key,
    required this.genresFuture,
    required this.selectedGenreId,
    required this.onGenreSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<int, String>>(
      future: genresFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar géneros.'));
        }

        final genres = snapshot.data ?? {};
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: genres.length,
            itemBuilder: (context, index) {
              final genreId = genres.keys.elementAt(index);
              final genreName = genres.values.elementAt(index);

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    onGenreSelected(
                        genreId); // Chama a função quando um género é selecionado
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedGenreId == genreId
                        ? AppColors.roxo
                        : AppColors.caixas,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    genreName,
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
