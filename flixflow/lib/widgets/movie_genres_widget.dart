import 'package:flutter/material.dart';

class MovieGenresWidget extends StatelessWidget {
  final List<String> genres;

  const MovieGenresWidget({
    super.key,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      genres.join(', '),
      style: TextStyle(
        color: Colors.grey[600],
      ),
    );
  }
}
