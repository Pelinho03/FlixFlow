import 'package:flixflow/styles/app_colors.dart';
import 'package:flixflow/styles/app_text.dart';
import 'package:flutter/material.dart';

class MovieRatingWidget extends StatelessWidget {
  final double rating;

  const MovieRatingWidget({
    super.key,
    required this.rating,
  });

  // Função para calcular o número de estrelas preenchidas com base na avaliação
  int _getFilledStars(double rating) {
    return (rating / 2).round(); // Divide a nota por 2. escala de 0 a 5
  }

  @override
  Widget build(BuildContext context) {
    // Obtém o número de estrelas preenchidas
    final filledStars = _getFilledStars(rating);
    return Row(
      children: [
        // Gera 5 ícones de estrelas, preenchidas ou vazias
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < filledStars ? Icons.star : Icons.star_border,
              color: AppColors.laranja,
              size: 16.0,
            );
          }),
        ),
        const SizedBox(width: 8),
        // Exibe a nota formatada
        Text(
          '${(rating / 2).toStringAsFixed(1)}/5',
          style: AppTextStyles.mediumText.copyWith(color: AppColors.laranja),
        ),
      ],
    );
  }
}
