import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_text.dart';
import '../username_dialog.dart';

class SearchBanner extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;

  const SearchBanner({super.key, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: double.infinity,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/imgs/teste.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/imgs/login_logo.png',
                      height: 35,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      autofocus: false,
                      onChanged: onSearchChanged,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.primeiroPlano,
                        hintText: 'Procurar filme',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon:
                            const Icon(Icons.search, color: AppColors.cinza),
                      ),
                      style: AppTextStyles.mediumText.copyWith(
                        color: AppColors.cinza,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: -10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(Icons.account_circle,
                        color: AppColors.primeiroPlano, size: 40),
                    onPressed: () {
                      _showUsernameDialog(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showUsernameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UsernameDialog();
      },
    );
  }
}
