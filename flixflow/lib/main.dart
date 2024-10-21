import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'screens/login_page.dart';
// import 'screens/register_page.dart';
import 'screens/home_page.dart';
// import 'screens/movie_details_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform, // Configurado pelo flutterfire
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlixFlow',
      theme: ThemeData.dark(),
      // home: MovieDetailPage(movie: 917496)
      home: HomePage(),
      // home: LoginPage(),
      // home: RegisterPage(),
    );
  }
}
