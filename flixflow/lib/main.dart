import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

// Import das páginas necessárias
import 'screens/home_page.dart';
import 'screens/favorites_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/movie_details_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform, // Configurado pelo FlutterFire
  );

  // Verifica o estado do login antes de iniciar a app
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn =
      prefs.getBool('isLoggedIn') ?? false; // Verifica se o usuário está logado

  runApp(MyApp(isLoggedIn: isLoggedIn)); // Passa o estado de login para o MyApp
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlixFlow',
      theme: ThemeData.dark(),
      initialRoute: isLoggedIn
          ? '/'
          : '/login', // Rota inicial baseada no estado de login
      routes: {
        '/': (context) => const HomePage(), // Rota para a Home Page
        '/favorites': (context) => const FavoritePage(),
        '/login': (context) => LoginPage(), // Rota para a Login Page
        '/register': (context) => RegisterPage(), // Rota para a Register Page
        '/movieDetails': (context) => const MovieDetailPage(
            movie: null), // Rota para a página de detalhes do filme
      },
      debugShowCheckedModeBanner: false, // Remove a linha de debug
    );
  }
}
