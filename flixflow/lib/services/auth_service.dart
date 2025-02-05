import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flixflow/styles/app_colors.dart';
import 'package:flixflow/styles/app_text.dart';

class AuthService {
  static const String _loginTimestampKey = "login_timestamp";
  static const int sessionDuration = 3600; // Tempo limite de sessão (1 hora)

  // Guarda a hora do login
  static Future<void> saveLoginTimestamp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        _loginTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  // Verifica se a sessão ainda é válida
  static Future<bool> isSessionValid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? loginTimestamp = prefs.getInt(_loginTimestampKey);

    if (loginTimestamp == null)
      return false; // Se não houver timestamp, a sessão expirou.

    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int elapsedTime =
        (currentTime - loginTimestamp) ~/ 1000; // Tempo decorrido em segundos

    return elapsedTime <
        sessionDuration; // Retorna true se a sessão ainda for válida
  }

  // Exibe um pop-up de confirmação antes do logout
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
            textAlign: TextAlign.center,
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
        false; // Retorna false se o utilizador fechar o pop-up sem escolher
  }

  // Remove o estado de login e faz logout do Firebase
  static Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs
        .remove(_loginTimestampKey); // Remove o timestamp do SharedPreferences
    await FirebaseAuth.instance.signOut(); // Faz logout do Firebase

    // Redireciona para a página de login
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  // Faz logout sem precisar do contexto
  static Future<void> logoutWithoutContext() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Remove todas as preferências, incluindo o timestamp
    await FirebaseAuth.instance.signOut(); // Faz logout do Firebase
  }
}
