import 'package:flutter/material.dart';

class MovieDetailsWidget extends StatelessWidget {
  final Map<String, String> credits;
  final String originalLanguage;
  final String producerNames;

  const MovieDetailsWidget({
    super.key,
    required this.credits,
    required this.originalLanguage,
    required this.producerNames,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.white,
          height: 1.5,
        ),
        children: <TextSpan>[
          const TextSpan(
            text: 'Diretor: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '${credits['director'] ?? 'Diretor não disponível'}\n',
          ),
          const TextSpan(
            text: 'Idioma: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '${originalLanguage.toUpperCase()}\n',
          ),
          const TextSpan(
            text: 'Companhia(s) produtora(s): ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '$producerNames\n',
          ),
          const TextSpan(
            text: 'Música: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '${credits['composer'] ?? 'Música não disponível'}\n',
          ),
        ],
      ),
    );
  }
}
