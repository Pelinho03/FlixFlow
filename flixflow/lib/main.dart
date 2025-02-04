import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

import 'screens/home_page.dart';
import 'screens/favorites_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/movie_details_page.dart';
import 'screens/news_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'dados_sensiveis.env'); // Carrega o arquivo .env
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Verifica o estado do login antes de iniciar a app
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlixFlow',
      theme: ThemeData.dark(),
      initialRoute: isLoggedIn ? '/' : '/login',
      routes: {
        '/': (context) => const HomePage(),
        '/favorites': (context) => const FavoritePage(),
        '/news': (context) => const NewsPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/movieDetails': (context) => const MovieDetailPage(movie: null),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
