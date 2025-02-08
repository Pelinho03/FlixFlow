import 'package:flutter/material.dart';
import 'package:flixflow/services/user_service.dart';
import 'package:flixflow/styles/app_colors.dart';
import 'package:flixflow/styles/app_text.dart';

class UsernameDialog extends StatefulWidget {
  @override
  _UsernameDialogState createState() => _UsernameDialogState();
}

class _UsernameDialogState extends State<UsernameDialog> {
  final TextEditingController usernameController = TextEditingController();
  final UserService userService = UserService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    String? username = await userService.getUsername();
    if (username != null) {
      usernameController.text = username; // Preenche o campo se houver username
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          'Escolhe um username',
          style: AppTextStyles.bigText.copyWith(color: AppColors.primeiroPlano),
        ),
      ),
      content: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(), // Mostra loading enquanto carrega
            )
          : TextField(
              controller: usernameController,
              decoration: const InputDecoration(hintText: "Username"),
            ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: Text(
                'Cancelar',
                style: AppTextStyles.mediumText.copyWith(color: AppColors.roxo),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Salvar',
                style: AppTextStyles.mediumText.copyWith(color: AppColors.roxo),
              ),
              onPressed: () async {
                if (usernameController.text.isNotEmpty) {
                  await userService.saveUsername(usernameController.text);
                  Navigator.of(context).pop(); // Fecha o popup
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
