import 'package:flutter/material.dart';
import 'screens/home_page.dart'; // Atualiza o caminho para a HomePage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlixFlow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), // Define a HomePage como a página inicial
    );
  }
}
