import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../widgets/custom_bottom_navigation_bar.dart'; // Importa o widget
import '../widgets/movie_list_widget.dart';
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
  Future<List<dynamic>>? _searchMovies; // Lista para resultados de pesquisa
  String _searchQuery = ''; // Armazena o termo de pesquisa
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _popularMovies = MovieService().getPopularMovies();
    _topMovies = MovieService().getTopMovies();
  }

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

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return FutureBuilder<List<dynamic>>(
          future: _searchMovies ?? Future.wait([_popularMovies, _topMovies]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Erro na pesquisa.'));
            } else if (_searchMovies != null && snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum filme encontrado.'));
            }

            final List<dynamic> popularMovies =
                _searchMovies != null ? snapshot.data : snapshot.data![0];
            final List<dynamic> topMovies =
                _searchMovies != null ? snapshot.data : snapshot.data![1];

            return MovieListWidget(
              popularMovies: popularMovies,
              topMovies: topMovies,
            );
          },
        );

      case 1:
        return const Center(
          child: Text(
            'Página em Manutenção',
            style: TextStyle(fontSize: 24),
          ),
        );

      case 2:
        return const Center(child: Text('Sair'));
      default:
        return const Center(child: Text('Página não encontrada.'));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
                  const SizedBox(height: 8),
                  TextField(
                    onChanged:
                        _onSearchChanged, // Atualiza a pesquisa em tempo real
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.primeiroPlano,
                      hintText: 'Procurar filme',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon:
                          const Icon(Icons.search, color: AppColors.cinza),
                    ),
                    style: AppTextStyles.mediumText
                        .copyWith(color: AppColors.cinza),
                  ),
                ],
              ),
            ),
            // Conteúdo abaixo do banner
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 26.0), // Aplica o padding lateral de 26 unidades
              child: SizedBox(
                height: MediaQuery.of(context).size.height, // Altura adaptável
                child: _getSelectedPage(),
              ),
            ),
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
