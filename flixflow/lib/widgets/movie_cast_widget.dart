import 'package:flutter/material.dart';

class MovieCastWidget extends StatelessWidget {
  final List<dynamic> cast;

  const MovieCastWidget({Key? key, required this.cast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Elenco',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150, // Ajuste o tamanho conforme necessário
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cast.length,
            itemBuilder: (context, index) {
              final actor = cast[index];
              final actorName = actor['name'] ?? 'Desconhecido';
              final actorPhoto = actor['profile_path'] != null
                  ? 'https://image.tmdb.org/t/p/w500${actor['profile_path']}'
                  : 'https://via.placeholder.com/150'; // Foto padrão se não houver foto

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(actorPhoto),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      actorName,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
