import 'package:flutter/material.dart';
import 'auth_service.dart'; // Importa o serviço de autenticação

class NavigationService {
  // Função para controlar a navegação e logout
  static Future<void> handleNavigation(BuildContext context, int index) async {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/'); // Vai para a HomePage
        break;
      case 1:
        Navigator.pushNamed(context, '/favorites'); // Vai para a FavoritePage
        break;
      case 2:
        // Confirmar se o utilizador realmente quer fazer logout
        final shouldLogout = await AuthService.confirmLogout(context);
        if (shouldLogout) {
          await AuthService.logout(context); // Faz logout e redireciona
        }
        break;
      default:
        break;
    }
  }
}
