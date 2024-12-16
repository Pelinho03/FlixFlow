import 'package:flutter/material.dart';
import '../styles/app_colors.dart';
import '../styles/app_text.dart';

class SearchBanner extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;

  const SearchBanner({super.key, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/imgs/banner_modify.png'),
          fit: BoxFit.cover,
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
              prefixIcon: const Icon(Icons.search, color: AppColors.cinza),
            ),
            style: AppTextStyles.mediumText.copyWith(
              color: AppColors.cinza,
            ),
          ),
        ],
      ),
    );
  }
}
