import 'package:flutter/material.dart';
import '../styles/app_text.dart';
import '../widgets/custom_bottom_navigation_bar.dart'; // Importa a barra personalizada

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
      ),
      body: Center(
        child: Text(
          'Página em manutenção',
          style: AppTextStyles.mediumText,
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 1, // Para manter o item Favoritos selecionado
        onItemTapped: (index) {
          // Aqui você pode adicionar a lógica de navegação
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              // Já estamos na página de favoritos, então não faz nada
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
