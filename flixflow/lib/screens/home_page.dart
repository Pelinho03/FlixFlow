import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../widgets/movie_list_widget.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../services/navigation_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_text.dart';
import 'movie_details_page.dart';

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
    // Chama os métodos para obter os filmes populares e top
    _popularMovies = MovieService().getPopularMovies();
    _topMovies = MovieService().getTopMovies();
  }

  // Método de pesquisa
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isNotEmpty) {
        _searchMovies = MovieService().searchMovies(_searchQuery);
      } else {
        _searchMovies = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner com a barra de pesquisa
            Container(
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
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.primeiroPlano,
                      hintText: 'Procurar filme',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.search, color: AppColors.cinza),
                    ),
                    style: AppTextStyles.mediumText.copyWith(
                      color: AppColors.cinza,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: _searchQuery.isNotEmpty
                  ? _buildSearchResults() // Mostra resultados da pesquisa
                  : _buildDefaultLists(), // Mostra as listas padrão
            ),
            const SizedBox(height: 29),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) async {
          setState(() {
            _selectedIndex = index; // Atualiza o índice selecionado
          });
          await NavigationService.handleNavigation(
            context,
            index, // Chama a função centralizada de navegação e logout
          );
        },
      ),
      backgroundColor: AppColors.fundo,
    );
  }

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

        return GridView.builder(
          shrinkWrap: true, // Faz a lista ocupar apenas o espaço necessário
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Define 2 colunas
            crossAxisSpacing: 12, // Espaço horizontal entre os itens
            mainAxisSpacing: 12, // Espaço vertical entre os itens
            childAspectRatio:
                0.6, // Ajuste a proporção dos itens (largura/altura)
          ),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final movie = searchResults[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailPage(movie: movie),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12), // Bordas arredondadas
                ),
                elevation: 4, // Sombra para destacar o card
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            12), // Bordas arredondadas nas imagens
                        child: movie['poster_path'] != null
                            ? Image.network(
                                'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150, // Altura da imagem
                              )
                            : const Icon(Icons.movie,
                                size: 80), // Icon caso não tenha imagem
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        movie['title'] ?? 'Título não disponível',
                        style: AppTextStyles.mediumText.copyWith(
                          color: AppColors.primeiroPlano,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '${movie['release_date']?.substring(0, 4) ?? 'N/A'}',
                        style: AppTextStyles.smallText.copyWith(
                          color: AppColors.roxo,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

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
}
