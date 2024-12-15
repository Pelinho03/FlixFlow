import 'package:flutter/material.dart';
import '../styles/app_text.dart';
import '../widgets/custom_bottom_navigation_bar.dart'; // Importa a barra personalizada
import '../services/auth_service.dart'; // Importa o AuthService

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
        selectedIndex: 1, // Ícone Favoritos selecionado
        onItemTapped: (index) async {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/'); // Vai para a HomePage
              break;
            case 1:
              // Já estamos na página de Favoritos, não faz nada
              break;
            case 2:
              final shouldLogout = await AuthService.confirmLogout(context);
              if (shouldLogout) {
                await AuthService.logout(context); // Chama o serviço de logout
              }
              break;
          }
        },
      ),
    );
  }
}
