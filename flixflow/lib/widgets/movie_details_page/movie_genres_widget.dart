import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_text.dart';

class MovieGenresWidget extends StatelessWidget {
  // lista de géneros
  final List<String> genres;

  // Construtor do widget que exige uma lista de gêneros como parâmetro.
  const MovieGenresWidget({
    super.key,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      genres
          .join(', '), // Junta os géneros com uma vírgula e espaço entre eles.
      style: AppTextStyles.mediumText.copyWith(color: AppColors.cinza2),
    );
  }
}
