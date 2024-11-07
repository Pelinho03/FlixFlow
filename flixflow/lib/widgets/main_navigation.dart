
// import 'package:flutter/material.dart';
// import '../styles/app_text.dart';
// import '../screens/home_page.dart';
// import '../screens/favorites_page.dart';
// import '../screens/login_page.dart';
// import '../widgets/custom_bottom_navigation_bar.dart';

// class MainNavigation extends StatefulWidget {
//   @override
//   _MainNavigationState createState() => _MainNavigationState();
// }

// class _MainNavigationState extends State<MainNavigation> {
//   int _selectedIndex = 0;

//   // Callback para o item selecionado na barra de navegação
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });

//     // Navegar para a página correspondente utilizando rotas
//     String route = '/';
//     switch (index) {
//       case 0:
//         route = '/'; // Rota para a HomePage
//         break;
//       case 1:
//         route = '/favorites'; // Rota para a FavoritePage
//         break;
//       case 2:
//         route = '/login'; // Rota para a LoginPage
//         break;
//     }
//     Navigator.pushNamed(context, route); // Navega para a rota definida
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text(
//           'Selecione um ícone!',
//           style: TextStyle(fontSize: 24),
//         ), // Texto de exemplo
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }
// }
