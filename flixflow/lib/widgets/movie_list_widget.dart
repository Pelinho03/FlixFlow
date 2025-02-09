import 'package:flutter/material.dart';
import '../styles/app_text.dart';
import '../styles/app_colors.dart';
import '../screens/movie_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// O MovieListWidget é um widget que exibe uma lista de filmes divididos por categorias.
class MovieListWidget extends StatefulWidget {
  // Listas de filmes em diferentes categorias.
  final List<dynamic> popularMovies;
  final List<dynamic> topMovies;
  final List<dynamic> upcomingMovies;
  final List<dynamic> trendingMovies;

  // Construtor para passar as listas de filmes para o widget.
  const MovieListWidget({
    super.key,
    required this.popularMovies,
    required this.topMovies,
    required this.upcomingMovies,
    required this.trendingMovies,
  });

  @override
  _MovieListWidgetState createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  // Listas de filmes que serão usadas no estado.
  late List<dynamic> popularMovies;
  late List<dynamic> topMovies;
  late List<dynamic> upcomingMovies;
  late List<dynamic> trendingMovies;

  // Proporção usada para calcular a altura do banner.
  final double bannerRatio = 4.0;

  @override
  void initState() {
    super.initState();
    // Inicializando as listas com os dados passados pelo widget.
    popularMovies = widget.popularMovies;
    topMovies = widget.topMovies;
    upcomingMovies = widget.upcomingMovies;
    trendingMovies = widget.trendingMovies;
  }

  Future<bool> isFavorite(dynamic movie) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return false; // Se o utilizador não estiver autenticado, retorna false.

    // Verifica no Firestore os dados do utilizador e se o filme está nos favoritos.
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (!doc.exists) return false;

    final data = doc.data() as Map<String, dynamic>;
    final favorites = List<int>.from(data['favorites'] ?? []);
    return favorites.contains(movie['id']);
  }

  // Alterna o status de favorito de um filme.
  Future<void> toggleFavorite(dynamic movie) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return; // Se não houver utilizador autenticado, não faz nada.

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    try {
      // Inicia uma transação no Firestore para garantir consistência nos dados.
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          transaction.set(docRef, {
            'favorites': [movie['id']]
          });
          return;
        }

        final data = snapshot.data() as Map<String, dynamic>;
        final favorites = List<int>.from(data['favorites'] ?? []);

        // Se o filme já for favorito, remove da lista, senão adiciona.
        favorites.contains(movie['id'])
            ? favorites.remove(movie['id'])
            : favorites.add(movie['id']);
        transaction.update(docRef, {'favorites': favorites});
      });

      setState(() {}); // Atualiza o estado após a alteração.
    } catch (e) {
      // print('Erro ao alternar favoritos: $e');
    }
  }

  // Função para construir a lista de filmes para cada categoria.
  Widget _buildMovieList(
      String title, List<dynamic> movies, BuildContext context) {
    if (movies.isEmpty) {
      return const Center(child: Text('Nenhum filme disponível.'));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(title,
                style: AppTextStyles.bigText
                    .copyWith(color: AppColors.primeiroPlano)),
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Exibe os filmes na horizontal.
            itemCount: movies.length, // Número de filmes a serem exibidos.
            itemBuilder: (context, index) {
              final movie = movies[index]; // Filme atual da lista.

              return Container(
                width: 140, // Largura do card do filme.
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Stack(
                  alignment: const Alignment(
                      0.90, 0.20), // Alinhamento do botão de favorito.
                  children: [
                    GestureDetector(
                      // Ao tocar no card, abre os detalhes do filme.
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailPage(movie: movie)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: movie['poster_path'] != null
                                ? Image.network(
                                    'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                    fit: BoxFit.cover,
                                    width: 148,
                                    height: 200,
                                  )
                                : const Icon(Icons.movie,
                                    size:
                                        80), // Se não houver poster, exibe um ícone.
                          ),
                          const SizedBox(height: 8),
                          // Exibe o título e o ano de lançamento do filme.
                          Container(
                            width: 148,
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    movie['title'] ?? 'Título não disponível',
                                    style: AppTextStyles.mediumText.copyWith(
                                      color: AppColors.primeiroPlano,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${movie['release_date']?.substring(0, 4) ?? 'N/A'}',
                                  style: AppTextStyles.smallText.copyWith(
                                    color: AppColors.roxo,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<bool>(
                      future: isFavorite(
                          movie), // Verifica se o filme está nos favoritos.
                      builder: (context, snapshot) {
                        final isFav = snapshot.data ?? false;
                        final user = FirebaseAuth.instance.currentUser;

                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.primeiroPlano,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            icon: Icon(
                              snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? Icons.favorite_border
                                  : (isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border),
                              color: isFav ? AppColors.roxo : AppColors.cinza,
                            ),
                            onPressed: user != null
                                ? () => toggleFavorite(
                                    movie) // Alterna o favorito se o utilizador estiver autenticado.
                                : null,
                          ),
                        );
                      },
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMovieList('Tendências', trendingMovies, context),
          const SizedBox(height: 15.0),
          const Divider(height: 15, color: AppColors.roxo, thickness: 0.1),
          const SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calcula a altura do banner com base na largura do ecra.
                double bannerHeight = constraints.maxWidth / bannerRatio;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/imgs/banner_homepage_v2.png', // Imagem do banner.
                    width: constraints.maxWidth,
                    height: bannerHeight,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          const Divider(height: 15, color: AppColors.roxo, thickness: 0.1),
          _buildMovieList('Mais Populares', popularMovies, context),
          const Divider(height: 15, color: AppColors.roxo, thickness: 0.1),
          _buildMovieList('Top Filmes', topMovies, context),
          const SizedBox(height: 15.0),
          const Divider(height: 15, color: AppColors.roxo, thickness: 0.1),
          _buildMovieList('Brevemente', upcomingMovies, context),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }
}
