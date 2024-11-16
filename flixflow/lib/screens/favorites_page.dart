import 'package:flutter/material.dart';
import '../styles/app_text.dart';
import '../widgets/custom_bottom_navigation_bar.dart'; // Importa a barra personalizada

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),

      //texto provisorio centrado com estilo pre-definido por mimm
      body: const Center(
        child: Text(
          'Página em manutenção',
          style: AppTextStyles.mediumText,
        ),
      ),

      //carrego a barra personalizada criado anteriormente que esta no widget
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 1, // Para manter o item Favoritos selecionado
        onItemTapped: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              // ja estamos na página de favoritos, por issso não faz nada
              break;
            case 2:
              Navigator.pushNamed(context, '/login');
              break;
          }
        },
      ),
    );
  }
}
