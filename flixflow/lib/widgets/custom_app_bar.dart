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
      title: titleWidget ?? Text(title ?? ''),
      titleTextStyle: AppTextStyles.mediumAppBar.copyWith(
        color: AppColors.primeiroPlano,
      ),
      titleSpacing: 0.0,
      centerTitle: true,
      toolbarHeight: 60.2,
      toolbarOpacity: 0.8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      elevation: 0.0,
      backgroundColor: AppColors.caixas,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.2);
}
