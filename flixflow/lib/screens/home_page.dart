import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../widgets/movie_list_widget.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../styles/app_colors.dart';
import '../styles/app_text.dart';

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
    //aqui chamo a função para ir buscar os filmes populares e em seguida os TOP
    //seriços criados em movie_service
    _popularMovies = MovieService().getPopularMovies();
    _topMovies = MovieService().getTopMovies();
  }

  //método para procurar filmes na barra de pesquisa
  //contem validação caso nao encontre o que pesquisei
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isNotEmpty) {
        //atraves da query de pesquisa e com ajuda do metodo criado para pesquisa no movie_service vai pesquisar o filme da query
        _searchMovies = MovieService().searchMovies(_searchQuery);
      } else {
        _searchMovies = null;
      }
    });
  }

  //define a localizaçao das páginas
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/favorites');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SingleChildScrollView para permitir a mover com o scroll
      body: SingleChildScrollView(
        //column para que eu consiga dar scroll e o banner acompanhar até ficar escondido
        child: Column(
          children: [
            // Banner com a barra de pesquisa
            Container(
              //padding para definir a posicao do banner
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
                    //carrega o metodo da pesquisa
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

            // Resto da página
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: FutureBuilder<List<dynamic>>(
                future:
                    _searchMovies ?? Future.wait([_popularMovies, _topMovies]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Erro na pesquisa.'));
                  } else if (_searchMovies != null && snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Nenhum filme encontrado.'));
                  }

                  final List<dynamic> popularMovies = _searchMovies != null
                      ? snapshot.data!
                      : snapshot.data![0];
                  final List<dynamic> topMovies = _searchMovies != null
                      ? snapshot.data!
                      : snapshot.data![1];

                  return MovieListWidget(
                    popularMovies: popularMovies,
                    topMovies: topMovies,
                  );
                },
              ),
            ),
            SizedBox(height: 29)
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      backgroundColor: AppColors.fundo,
    );
  }
}
