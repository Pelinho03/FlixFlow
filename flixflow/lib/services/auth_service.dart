import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flixflow/styles/app_colors.dart';
import 'package:flixflow/styles/app_text.dart';

class AuthService {
  // Exibe um diálogo para confirmar o logout com o estilo desejado
  static Future<bool> confirmLogout(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Confirmação de Logout",
              style: AppTextStyles.bigText.copyWith(color: AppColors.vermelho),
            ),
          ),
          content: Text(
            "Tens a certeza que queres sair?",
            style: AppTextStyles.mediumText
                .copyWith(color: AppColors.primeiroPlano),
            textAlign: TextAlign
                .center, // Opcional para garantir o alinhamento centralizado
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    "Cancelar",
                    style: AppTextStyles.mediumText
                        .copyWith(color: AppColors.roxo),
                  ),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    "Sair",
                    style: AppTextStyles.mediumText
                        .copyWith(color: AppColors.roxo),
                  ),
                ),
              ],
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
