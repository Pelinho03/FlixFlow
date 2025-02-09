import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_text.dart';

class SearchBanner extends StatelessWidget {
  // Função callback que é chamada quando a pesquisa é alterada
  final ValueChanged<String> onSearchChanged;

  const SearchBanner({super.key, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder é utilizado para construir o widget com base nas restrições do layout
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: double.infinity, // Garante que a largura será total
          child: Container(
            constraints: BoxConstraints(
              maxWidth:
                  constraints.maxWidth, // Limita a largura ao máximo disponível
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            decoration: const BoxDecoration(
              image: DecorationImage(
                // Define a imagem de fundo para o banner
                image: AssetImage('assets/imgs/teste.png'),
                fit: BoxFit.cover, // Preenche toda a área disponível
              ),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    // Exibe o logo de login ou app no topo
                    Image.asset(
                      'assets/imgs/login_logo.png',
                      height: 35,
                      fit: BoxFit
                          .contain, // Garante que o logo seja exibido corretamente
                    ),
                    const SizedBox(height: 12),
                    // Caixa de texto para pesquisa de filmes
                    TextField(
                      autofocus: false,
                      onChanged:
                          onSearchChanged, // Chama a função callback quando o texto muda
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors
                            .primeiroPlano, // Cor de fundo da caixa de pesquisa
                        hintText:
                            'Procurar filme', // Texto exibido enquanto não houver nada digitado
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.search,
                            color: AppColors.cinza), // Ícone de pesquisa
                      ),
                      style: AppTextStyles.mediumText.copyWith(
                        color: AppColors.cinza, // Cor do texto digitado
                      ),
                    ),
                  ],
                ),
                // Botão de perfil posicionado no canto superior direito
                Positioned(
                  top: -10, // Ajusta a posição para cima
                  right: 10, // Ajusta a posição para a direita
                  child: IconButton(
                    icon: const Icon(Icons.account_circle,
                        color: AppColors.primeiroPlano, size: 40),
                    onPressed: () {
                      _navigateToProfile(
                          context); // Navega para a página de perfil ao clicar
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

  // Função para navegar até a página de perfil
  void _navigateToProfile(BuildContext context) {
    Navigator.pushNamed(context, '/profile');
  }
}
