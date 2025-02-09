import 'package:flutter/material.dart';
import '../styles/app_text.dart';
import '../styles/app_colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  // Índice do item selecionado na barra de navegação
  final int selectedIndex;
  // Função que será chamada quando um item for selecionado
  final Function(int) onItemTapped;

  // Construtor para receber o índice selecionado e a função para troca de ícone
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
        // Define o tipo de barra de navegação como fixa (sem animação de transição entre itens).
        type: BottomNavigationBarType.fixed,

        // Define os itens da barra de navegação com ícones e rótulos.
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie), // Ícone de filmes
            label: 'Filmes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite), // Ícone de favoritos
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article), // Ícone para Notícias
            label: 'Notícias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app), // Ícone para sair
            label: 'Sair',
          ),
        ],

        // índice atual que está selecionado na barra de navegação
        currentIndex: selectedIndex,

        // Cor do ícone do item selecionado.
        selectedItemColor: AppColors.roxo,

        // Cor do ícone dos itens não selecionados.
        unselectedItemColor: AppColors.primeiroPlano,

        // fundo da barra de navegação
        backgroundColor: Colors.transparent,

        selectedLabelStyle: AppTextStyles.navBarTextBold,

        unselectedLabelStyle: AppTextStyles.navBarText,

        // tamanho dos ícones.
        iconSize: 28.0,

        onTap: onItemTapped,
      ),
    );
  }
}
