import 'package:flutter/material.dart';

class MovieImagesWidget extends StatelessWidget {
  final List<dynamic> images;
  final String posterPath;

  const MovieImagesWidget({
    super.key,
    required this.images,
    required this.posterPath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 278,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: posterPath != null
                    ? Image.network(
                        'https://image.tmdb.org/t/p/w500$posterPath',
                        fit: BoxFit.cover,
                        height: 278,
                      )
                    : const Icon(Icons.movie, size: 80),
              ),
            );
          }
          final image = images[index - 1];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${image['file_path']}',
                fit: BoxFit.cover,
                width: 458,
              ),
            ),
          );
        },
      ),
    );
  }
}
