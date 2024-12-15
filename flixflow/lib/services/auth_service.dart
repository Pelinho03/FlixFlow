import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Exibe um diálogo para confirmar o logout
  static Future<bool> confirmLogout(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmação de Logout"),
          content: const Text("Tens a certeza que queres sair?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Sair"),
            ),
          ],
        );
      },
    );
    return result ??
        false; // Retorna false se o diálogo for fechado sem escolha
  }

  // Remove o estado de login e faz logout do Firebase
  static Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); // Remove o estado do SharedPreferences

    await FirebaseAuth.instance.signOut(); // Faz logout do Firebase

    // Redireciona para a página de login
    Navigator.pushReplacementNamed(context, '/login');
  }
}
