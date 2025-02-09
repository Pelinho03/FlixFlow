import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text.dart';

class MovieDetailsWidget extends StatelessWidget {
  // Recebe informações sobre os créditos do filme, idioma original e produtores.
  final Map<String, String> credits;
  final String originalLanguage; // Idioma original do filme.
  final String producerNames; // Nomes das companhias produtoras.

  // Construtor do widget
  const MovieDetailsWidget({
    super.key,
    required this.credits,
    required this.originalLanguage,
    required this.producerNames,
  });

  @override
  Widget build(BuildContext context) {
    // Cria um widget RichText, que permite usar múltiplos estilos de texto em uma única linha.
    return RichText(
      text: TextSpan(
        style: TextStyle(
          height: 1.5, // Altura da linha para melhorar a legibilidade.
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'Diretor: ',
            style: AppTextStyles.mediumBoldText.copyWith(
              color: AppColors.primeiroPlano,
            ),
          ),
          TextSpan(
            text: '${credits['director'] ?? 'Diretor não disponível'}\n',
            style: AppTextStyles.mediumText.copyWith(
              color: AppColors.primeiroPlano,
            ),
            // Exibe o nome do diretor ou um texto padrão se não houver informação.
          ),
          TextSpan(
            text: 'Idioma: ', // Rótulo "Idioma".
            style: AppTextStyles.mediumBoldText.copyWith(
              color: AppColors.primeiroPlano,
            ),
          ),
          TextSpan(
            text: '${originalLanguage.toUpperCase()}\n',
            style: AppTextStyles.mediumText.copyWith(
              color: AppColors.primeiroPlano,
            ),
            // Exibe o idioma original em maiúsculas.
          ),
          TextSpan(
            text: 'Companhia(s) produtora(s): ', // Rótulo para as produtoras.
            style: AppTextStyles.mediumBoldText.copyWith(
              color: AppColors.primeiroPlano,
            ), // Negrito para o rótulo.
          ),
          TextSpan(
            text: '$producerNames\n',
            style: AppTextStyles.mediumText.copyWith(
              color: AppColors.primeiroPlano,
            ),
            // Exibe os nomes das produtoras.
          ),
          TextSpan(
            text: 'Música: ', // Rótulo "Música".
            style: AppTextStyles.mediumBoldText.copyWith(
              color: AppColors.primeiroPlano,
            ),
          ),
          TextSpan(
            text: '${credits['composer'] ?? 'Música não disponível'}\n',
            style: AppTextStyles.mediumText.copyWith(
              color: AppColors.primeiroPlano,
            ),
          ),
        ],
      ),
    );
  }
}
