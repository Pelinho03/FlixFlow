import 'package:flutter/material.dart';
import '../styles/app_text.dart';
import '../styles/app_colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      decoration: const BoxDecoration(
        color: AppColors.caixas,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Filmes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Sair',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: AppColors.roxo,
        unselectedItemColor: AppColors.primeiroPlano,
        backgroundColor: Colors.transparent,
        selectedLabelStyle: AppTextStyles.navBarTextBold,
        unselectedLabelStyle: AppTextStyles.navBarText,
        iconSize: 28.0,
        onTap: onItemTapped, // Aqui vamos chamar diretamente a função passada
      ),
    );
  }
}
