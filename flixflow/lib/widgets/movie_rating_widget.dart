import 'package:flixflow/styles/app_colors.dart';
import 'package:flixflow/styles/app_text.dart';
import 'package:flutter/material.dart';

class MovieRatingWidget extends StatelessWidget {
  final double rating;

  const MovieRatingWidget({
    super.key,
    required this.rating,
  });

  int _getFilledStars(double rating) {
    return (rating / 2).round();
  }

  @override
  Widget build(BuildContext context) {
    final filledStars = _getFilledStars(rating);
    return Row(
      children: [
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < filledStars ? Icons.star : Icons.star_border,
              color: AppColors.laranja,
              size: 16.0,
            );
          }),
        ),
        const SizedBox(width: 8), // Espaço entre as estrelas e o texto
        Text(
          '${(rating / 2).toStringAsFixed(1)}/5',
          style: AppTextStyles.mediumText.copyWith(color: AppColors.laranja),
        ),
      ],
    );
  }
}
