import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Import das páginas necessárias
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/movie_details_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform, // Configurado pelo FlutterFire
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlixFlow',
      theme: ThemeData.dark(),
      initialRoute: '/', // Define a página inicial
      routes: {
        '/': (context) => HomePage(), // Rota para a Home Page
        // '/favorites': (context) => FavoritesPage(),
        '/login': (context) => LoginPage(), // Rota para a Login Page
        '/register': (context) => RegisterPage(), // Rota para a Register Page
        '/movieDetails': (context) => MovieDetailPage(
              movie: null,
            ), // Rota para a página de detalhes do filme
      },
    );
  }
}
