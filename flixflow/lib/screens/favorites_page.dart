import 'package:flutter/material.dart';
import '../styles/app_text.dart';
import '../widgets/custom_bottom_navigation_bar.dart'; // Importa a barra personalizada
import '../services/navigation_service.dart'; // Importe o NavigationService

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),

      // Texto provisório centrado com estilo pre-definido
      body: const Center(
        child: Text(
          'Página em manutenção',
          style: AppTextStyles.mediumText,
        ),
      ),

      // Barra de navegação com a função de navegação centralizada
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 1, // Ícone Favoritos selecionado
        onItemTapped: (index) async {
          await NavigationService.handleNavigation(
              context, index); // Chama a função centralizada para navegação
        },
      ),
    );
  }
}
