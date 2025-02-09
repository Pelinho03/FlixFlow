import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../styles/app_colors.dart';
import '../styles/app_text.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController =
      TextEditingController(); // Controlador do campo de email
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Instância do Firebase Auth

  // Função para enviar o email de recuperação de senha
  void _resetPassword() async {
    // Verifica se o campo de email está vazio
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Por favor, insere o teu email.')), // Exibe uma mensagem de erro
      );
      return;
    }

    try {
      // Tenta enviar o email de recuperação
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Email de recuperação enviado!')), // Sucesso
      );
      Navigator.pop(context); // Volta para a página de login
    } on FirebaseAuthException catch (e) {
      // Em caso de erro, exibe uma mensagem com o erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo da página
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/imgs/login_bg2.png'),
                fit: BoxFit.cover, // A imagem cobre todo o ecra
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo da aplicação
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    child: Image.asset(
                      'assets/imgs/login_logo.png',
                      height: 53,
                      fit: BoxFit.contain, // Ajuste da imagem
                    ),
                  ),
                  Text(
                    'Recuperar', // Título da página
                    style: AppTextStyles.bigTextLoginRegist.copyWith(
                      color: AppColors.roxo, // Cor do texto
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Introduz o teu email e enviaremos um link para recuperares a tua palavra-passe.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles
                        .ligthTextLoginRegist, // Descrição abaixo do título
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      textAlign: TextAlign.center, // Alinha o texto ao centro
                      controller:
                          _emailController, // Controlador do campo de email
                      decoration: InputDecoration(
                        labelText: 'Email', // Rótulo do campo
                        labelStyle: AppTextStyles.ligthTextLoginRegist,
                        filled: true, // Preenchimento do campo
                        fillColor:
                            AppColors.caixas_login_registo, // Cor do fundo
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none, // Remove a borda
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _resetPassword, // Ação ao pressionar o botão
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            AppColors.roxo), // Cor de fundo do botão
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      child: Text(
                        'Enviar Email', // Texto do botão
                        style: AppTextStyles.mediumTextLoginRegist.copyWith(
                          color: AppColors
                              .caixas_login_registo, // Cor do texto no botão
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(context), // Volta para a página de login
                    child: Text(
                      'Voltar ao Login', // Texto do botão
                      style: AppTextStyles.ligthTextLoginRegist.copyWith(
                        color: AppColors.primeiroPlano, // Cor do texto
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context,
                          '/register'); // Navega para a página de registo
                    },
                    child: Text(
                      'Novo Registo', // Texto do botão
                      style: AppTextStyles.ligthTextLoginRegist.copyWith(
                        color: AppColors.primeiroPlano, // Cor do texto
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent, // Fundo transparente
    );
  }
}
