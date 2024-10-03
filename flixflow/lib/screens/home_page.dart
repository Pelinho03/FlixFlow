import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../styles/app._text.dart';
import '../styles/app_colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> _popularMovies;
  late Future<List<dynamic>> _topMovies; // Adiciona a lista de filmes top
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _popularMovies = MovieService().getPopularMovies();
    _topMovies = MovieService().getTopMovies(); // Carrega os filmes top
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildMovieList();
      case 1:
        return Center(child: Text('Favoritos'));
      case 2:
        return Center(child: Text('Sair'));
      default:
        return _buildMovieList();
    }
  }

  // Método para construir a lista de filmes populares
  Widget _buildMovieList() {
    return SingleChildScrollView(
      // Permite rolar a página para baixo
      child: Column(
        children: [
          // Seção de filmes populares
          FutureBuilder<List<dynamic>>(
            future: _popularMovies,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                        'Erro ao carregar filmes populares: ${snapshot.error}'));
              } else {
                final movies = snapshot.data!;
                return Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Mais Populares',
                            style: AppTextStyles.bigText
                                .copyWith(color: AppColors.primeiroPlano),
                          ),
                        )),
                    Container(
                      height: 200, // Define a altura da lista de filmes
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return Container(
                            width: 148,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: movie['poster_path'] != null
                                        ? Image.network(
                                            'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(Icons.movie, size: 80),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  movie['title'] ?? 'Título não disponível',
                                  style: AppTextStyles.mediumText
                                      .copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Ano: ${movie['release_date']?.substring(0, 4) ?? 'N/A'}',
                                  style: AppTextStyles.smallText
                                      .copyWith(color: AppColors.cinza),
                                ),
                                IconButton(
                                  icon: Icon(Icons.favorite_border),
                                  onPressed: () {
                                    // Implementa a funcionalidade para adicionar aos favoritos
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
            },
          ),

          // Seção de filmes top
          FutureBuilder<List<dynamic>>(
            future: _topMovies,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child:
                        Text('Erro ao carregar filmes top: ${snapshot.error}'));
              } else {
                final movies = snapshot.data!;
                return Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Top filmes',
                            style: AppTextStyles.bigText
                                .copyWith(color: AppColors.primeiroPlano),
                          ),
                        )),
                    Container(
                      height: 300,
                      // Define a altura da lista de filmes
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return Container(
                            width: 140,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: movie['poster_path'] != null
                                        ? Image.network(
                                            'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                            fit: BoxFit.cover,
                                            width: 148,
                                            height: 184,
                                          )
                                        : Icon(Icons.movie, size: 80),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  movie['title'] ?? 'Título não disponível',
                                  style: AppTextStyles.mediumText
                                      .copyWith(color: AppColors.primeiroPlano),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  // movie['realease_date']?.subrtring(0, 4) ?? 'N/A',
                                  '${movie['release_date']?.substring(0, 4) ?? 'N/A'}',
                                  style: AppTextStyles.smallText
                                      .copyWith(color: AppColors.roxo),
                                ),
                                IconButton(
                                  icon: Icon(Icons.favorite_border),
                                  onPressed: () {
                                    // Implementa a funcionalidade para adicionar aos favoritos
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
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlixFlow'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Aqui podes implementar a funcionalidade de pesquisa
            },
          ),
        ],
      ),
      body: _getSelectedPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Filmes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Sair',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFBD93F9),
        unselectedItemColor: const Color(0xFFF8F8F2),
        backgroundColor: Color(0xFF0E0D11),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      backgroundColor: Color(0xFF0E0D11),
    );
  }
}
