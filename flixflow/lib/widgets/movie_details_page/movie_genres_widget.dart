import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_text.dart';

class MovieGenresWidget extends StatelessWidget {
  final List<String> genres;

  const MovieGenresWidget({
    super.key,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    return Text(genres.join(', '),
        style: AppTextStyles.mediumText.copyWith(color: AppColors.cinza2));
  }
}
