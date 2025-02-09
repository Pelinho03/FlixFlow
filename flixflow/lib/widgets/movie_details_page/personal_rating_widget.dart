import 'package:flixflow/styles/app_colors.dart';
import 'package:flixflow/styles/app_text.dart';
import 'package:flutter/material.dart';
import '../../services/user_service.dart';

class RatingWidget extends StatefulWidget {
  final String movieId;

  const RatingWidget({super.key, required this.movieId});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  // Variável que guarda a avaliação atual do utilizador
  double _currentRating = 0.0;
  // Serviço para obter e definir avaliações de filmes
  final UserService _movieService = UserService();

  @override
  void initState() {
    super.initState();
    // Carrega a avaliação já existente do utilizador
    _loadUserRating();
  }

  Future<void> _loadUserRating() async {
    double? rating = await _movieService.getMovieRating(widget.movieId);
    // Se a avaliação existir, atualiza o estado com a avaliação carregada
    if (rating != null) {
      setState(() {
        _currentRating = rating;
      });
    }
  }

  // Função assíncrona para salvar a avaliação do utilizador
  Future<void> _rateMovie(double rating) async {
    // Envia a avaliação para o serviço salvar
    await _movieService.rateMovie(widget.movieId, rating);
    // Atualiza o estado com a nova avaliação
    setState(() {
      _currentRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Texto de título do widget
        Text(
          "Avalia-me",
          style: AppTextStyles.mediumBoldText.copyWith(
            color: AppColors.roxo,
          ),
        ),
        const SizedBox(height: 3),
        // Linha de botões para avaliar com estrelas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < _currentRating ? Icons.star : Icons.star_border,
                color: AppColors.laranja,
              ),
              // Chama a função de avaliação passando o valor da estrela
              onPressed: () => _rateMovie(index + 1.0),
            );
          }),
        ),
      ],
    );
  }
}
