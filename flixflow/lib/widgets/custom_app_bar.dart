import 'package:flutter/material.dart';
import '../styles/app_colors.dart';
import '../styles/app_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;

  const CustomAppBar({super.key, this.title, this.titleWidget});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Exibe o título
      title: titleWidget ?? Text(title ?? ''),

      titleTextStyle: AppTextStyles.mediumAppBar.copyWith(
        color: AppColors.primeiroPlano,
      ),

      // Impede o título de ter espaçamento extra
      titleSpacing: 0.0,

      // Alinha o título no centro da AppBar
      centerTitle: true,

      // Altura do AppBar
      toolbarHeight: 60.2,

      // Define a opacidade do fundo do AppBar
      toolbarOpacity: 0.8,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),

      // Define a sombra
      elevation: 0.0,

      // Define a cor de fundo do AppBar
      backgroundColor: AppColors.caixas,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.2);
}
