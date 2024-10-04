import '../styles/app_text.dart';
import '../styles/app_colors.dart';
import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../widgets/movie_list_widget.dart'; // Importa o widget

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
        return MovieListWidget(
          popularMovies: _popularMovies,
          topMovies: _topMovies,
        ); // Chama o widget que criaste
      case 1:
        return Center(child: Text('Favoritos'));
      case 2:
        return Center(child: Text('Sair'));
      default:
        return MovieListWidget(
          popularMovies: _popularMovies,
          topMovies: _topMovies,
        ); // Chama o widget que criaste
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Banner com a barra de pesquisa
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 50, vertical: 40), // Espaçamento interno
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/imgs/banner_modify.png'),
                fit: BoxFit.cover, // Para cobrir todo o espaço do Container
              ),
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/imgs/login_logo.png',
                  height: 35,
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                    height:
                        8), // Espaçamento entre o título e a barra de pesquisa
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors
                        .primeiroPlano, // Cor de fundo da barra de pesquisa
                    hintText: 'Procurar filme',
                    // hintStyle: TextStyle(color: AppColors.cinza),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none, // Sem bordas
                    ),
                    prefixIcon: Icon(Icons.search, color: AppColors.cinza),
                  ),
                  style:
                      AppTextStyles.mediumText, // Aplique o estilo corretamente
                ),
              ],
            ),
          ),

          // Resto do conteúdo da página
          Expanded(
            child: _getSelectedPage(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 86,
        decoration: const BoxDecoration(
          color: AppColors.caixas, // A cor de fundo da BottomNavigationBar
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
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
          selectedItemColor: AppColors.roxo,
          unselectedItemColor: AppColors.primeiroPlano,
          backgroundColor: Colors
              .transparent, // Define como transparente para a cor vir do Container
          selectedLabelStyle: AppTextStyles.navBarTextBold,
          unselectedLabelStyle: AppTextStyles.navBarText,
          iconSize: 28.0,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      backgroundColor: AppColors.fundo,
    );
  }
}
