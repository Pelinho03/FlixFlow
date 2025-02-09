import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

import 'screens/forgot_password_page.dart';
import 'services/auth_service.dart';

import 'screens/home_page.dart';
import 'screens/favorites_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/movie_details_page.dart';
import 'screens/news_page.dart';
import 'screens/profile_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'dados_sensiveis.env'); // Carrega o arquivo .env
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Verifica o estado do login antes de iniciar a app
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Verifica se a sessão ainda é válida
  if (isLoggedIn) {
    bool sessionValid = await AuthService.isSessionValid();
    if (!sessionValid) {
      await AuthService
          .logoutWithoutContext(); // Se a sessão expirou, faz logout sem contexto
      isLoggedIn = false; // Atualiza o estado do login para false
    }
  }

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlixFlow',
      theme: ThemeData.dark(),
      initialRoute: isLoggedIn ? '/' : '/login', // /login
      routes: {
        '/': (context) => const HomePage(),
        '/favorites': (context) => const FavoritePage(),
        '/news': (context) => const NewsPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/movieDetails': (context) => const MovieDetailPage(movie: null),
        '/forgotPassword': (context) => const ForgotPasswordPage(),
        '/profile': (context) => ProfilePage(),
      },

      debugShowCheckedModeBanner: false,
    );
  }
}
