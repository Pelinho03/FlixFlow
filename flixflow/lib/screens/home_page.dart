import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../widgets/movie_list_widget.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../services/navigation_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_text.dart';
import 'movie_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> _popularMovies;
  late Future<List<dynamic>> _topMovies;
  Future<List<dynamic>>? _searchMovies;
  String _searchQuery = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Inicializa as listas de filmes
    _popularMovies = MovieService().getPopularMovies();
    _topMovies = MovieService().getTopMovies();
  }

  // Método para lidar com pesquisa
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _searchMovies = query.isNotEmpty
          ? MovieService().searchMovies(query)
          : null; // Se a pesquisa estiver vazia, limpa os resultados
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchBanner(), // Banner com barra de pesquisa
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: _searchQuery.isNotEmpty
                  ? _buildSearchResults() // Resultados da pesquisa
                  : _buildDefaultLists(), // Listas padrão
            ),
            const SizedBox(height: 29),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) async {
          setState(() {
            _selectedIndex = index;
          });
          await NavigationService.handleNavigation(context, index);
        },
      ),
      backgroundColor: AppColors.fundo,
    );
  }

  // Construção do banner de pesquisa
  Widget _buildSearchBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/imgs/banner_modify.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/imgs/login_logo.png',
            height: 35,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 12),
          TextField(
            autofocus: false,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.primeiroPlano,
              hintText: 'Procurar filme',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search, color: AppColors.cinza),
            ),
            style: AppTextStyles.mediumText.copyWith(
              color: AppColors.cinza,
            ),
          ),
        ],
      ),
    );
  }

  // Resultados da pesquisa
  Widget _buildSearchResults() {
    return FutureBuilder<List<dynamic>>(
      future: _searchMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erro na pesquisa.'));
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum filme encontrado.'));
        }

        final searchResults = snapshot.data ?? [];
        return _buildMovieList(searchResults);
      },
    );
  }

  // Listas padrão (filmes populares e top-rated)
  Widget _buildDefaultLists() {
    return FutureBuilder<List<List<dynamic>>>(
      future: Future.wait([_popularMovies, _topMovies]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar filmes.'));
        }

        final popularMovies = snapshot.data![0];
        final topMovies = snapshot.data![1];

        return MovieListWidget(
          popularMovies: popularMovies,
          topMovies: topMovies,
        );
      },
    );
  }

  // Exibição de lista de filmes
  Widget _buildMovieList(List<dynamic> movies) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _buildMovieTile(movie);
      },
    );
  }

  // Item individual de filme
  Widget _buildMovieTile(dynamic movie) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Stack(
        alignment: const Alignment(1.0, 0.60),
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailPage(movie: movie),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagem do filme
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: movie['poster_path'] != null
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 150,
                        )
                      : const Icon(Icons.movie, size: 80),
                ),
                const SizedBox(width: 12.0),
                // Títulos e detalhes
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie['title'] ?? 'Título não disponível',
                        style: AppTextStyles.mediumText.copyWith(
                          color: AppColors.primeiroPlano,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        '${movie['release_date']?.substring(0, 4) ?? 'N/A'}',
                        style: AppTextStyles.smallText.copyWith(
                          color: AppColors.roxo,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        movie['overview'] ?? 'Sinopse não disponível',
                        style: AppTextStyles.smallText
                            .copyWith(color: AppColors.cinza),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Botão de favoritos
          Container(
            decoration: BoxDecoration(
              color: AppColors.primeiroPlano,
              borderRadius: BorderRadius.circular(50),
            ),
            child: FutureBuilder<bool>(
              future: isFavorite(movie),
              builder: (context, snapshot) {
                final isFav = snapshot.data ?? false;

                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? AppColors.roxo : AppColors.cinza,
                  ),
                  onPressed: () async {
                    await toggleFavorite(movie);
                    setState(() {}); // Atualiza a UI após a mudança
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Verificar se o filme é favorito
  Future<bool> isFavorite(dynamic movie) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return false; // Se o usuário não estiver autenticado
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        return false; // Se não encontrar o usuário na coleção
      }

      final data = doc.data() as Map<String, dynamic>;
      final favorites = List<int>.from(data['favorites'] ?? []);

      return favorites.contains(movie['id']);
    } catch (e) {
      print('Erro ao verificar se é favorito: $e');
      return false;
    }
  }

  // Alternar estado de favoritos
  Future<void> toggleFavorite(dynamic movie) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Utilizador não autenticado.');
    }

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          // Caso o documento não exista, criamos um novo com o filme
          transaction.set(docRef, {
            'favorites': [movie['id']]
          });
          return;
        }

        final data = snapshot.data() as Map<String, dynamic>;
        final favorites = List<int>.from(data['favorites'] ?? []);

        // Alterna a presença do filme nos favoritos
        if (favorites.contains(movie['id'])) {
          favorites.remove(movie['id']); // Remove do favorito
        } else {
          favorites.add(movie['id']); // Adiciona aos favoritos
        }

        transaction.update(docRef, {'favorites': favorites});
      });
    } catch (e, stackTrace) {
      print('Erro ao alternar favoritos: $e');
      print('Stack trace: $stackTrace'); // Exibe o stack trace
      rethrow; // Relança a exceção para ser capturada por outros handlers
    }
  }
}
