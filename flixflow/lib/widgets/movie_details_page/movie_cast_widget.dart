import 'package:flixflow/styles/app_colors.dart';
import 'package:flixflow/styles/app_text.dart';
import 'package:flutter/material.dart';

class MovieCastWidget extends StatelessWidget {
  final List<dynamic> cast;

  const MovieCastWidget({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Elenco',
          style: AppTextStyles.bigText.copyWith(color: AppColors.roxo),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cast.length,
            itemBuilder: (context, index) {
              final actor = cast[index];
              final actorName = actor['name'] ?? 'Desconhecido';
              final characterName =
                  actor['character'] ?? 'Personagem desconhecida';
              // ignore: unused_local_variable
              final actorPhoto = actor['profile_path'] != null
                  ? 'https://image.tmdb.org/t/p/w500${actor['profile_path']}'
                  : 'https://via.placeholder.com/150'; // Foto padrão se não houver foto

              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 90, // Largura total da caixa
                  height: 150, // Altura total da caixa
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Alinha os textos à esquerda
                    children: [
                      // Foto do ator com tamanho e bordas arredondadas

                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: actor['profile_path'] != null &&
                                actor['profile_path'].isNotEmpty
                            ? Image.network(
                                'https://image.tmdb.org/t/p/w500${actor['profile_path']}',
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/imgs/default_actor_v2.png',
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                'assets/imgs/default_actor_v2.png',
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                      ),

                      const SizedBox(
                          height: 8), // Espaço entre a imagem e os textos
                      // Nome da personagem
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 4.0), // Alinha o texto à esquerda
                        child: Text(
                          characterName,
                          style: AppTextStyles.mediumText.copyWith(
                            color: AppColors.roxo,
                            height: 1.2, // Ajuste do espaçamento entre linhas
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Nome do ator
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 4.0), // Alinha o texto à esquerda
                        child: Text(
                          actorName,
                          style: AppTextStyles.regularText.copyWith(
                            color: AppColors.primeiroPlano,
                            height: 1.2, // Ajuste do espaçamento entre linhas
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
