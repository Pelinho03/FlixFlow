import 'package:flutter/material.dart';
import '../services/movie_service.dart';

class RatingWidget extends StatefulWidget {
  final String movieId;

  const RatingWidget({super.key, required this.movieId});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  double _currentRating = 0.0;
  final MovieService _movieService = MovieService();

  @override
  void initState() {
    super.initState();
    _loadUserRating();
  }

  Future<void> _loadUserRating() async {
    double? rating = await _movieService.getMovieRating(widget.movieId);
    if (rating != null) {
      setState(() {
        _currentRating = rating;
      });
    }
  }

  Future<void> _rateMovie(double rating) async {
    await _movieService.rateMovie(widget.movieId, rating);
    setState(() {
      _currentRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _currentRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () => _rateMovie(index + 1.0),
        );
      }),
    );
  }
}
