import 'package:flutter/material.dart';
import '../styles/app_colors.dart';
import '../styles/app_text.dart';

class SearchBanner extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;

  const SearchBanner({super.key, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: double.infinity, // Ocupar a largura total disponível
          child: Container(
            constraints: BoxConstraints(
              maxWidth:
                  constraints.maxWidth, // Não ultrapassa a largura do ecrã
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/imgs/teste.png'),
                fit: BoxFit.cover, // Ajusta a imagem sem distorcer
              ),
            ),
            child: Column(
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
          ),
        );
      },
    );
  }
}
