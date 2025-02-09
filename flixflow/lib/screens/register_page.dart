import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import '../styles/app_colors.dart';
import '../styles/app_text.dart';

class RegisterPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController =
      TextEditingController(); // Controlador para o campo de email
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController(); // Controlador para a confirmação de password

  RegisterPage({super.key});

  // Função de registo no Firebase
  void _register(BuildContext context) async {
    // Verificar se as passwords coincidem
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      try {
        // Criar o utilizador no Firebase com o email e password fornecidos
        final UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        print("Registo bem-sucedido: ${userCredential.user!.email}");
        // Mostrar uma mensagem de sucesso após o registo
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Registo bem-sucedido, por favor faça login.')),
        );
        // Redireciona para a página de login após o registo
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } on FirebaseAuthException catch (e) {
        // Caso ocorra um erro, mostra a mensagem de erro
        print('Erro: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${e.message}')),
        );
      }
    } else {
      // Caso as passwords não coincidam, mostra uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As passwords não coincidem.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/imgs/login_bg2.png'),
                fit: BoxFit.cover, // Ajusta a imagem para cobrir toda a área
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Exibe o logo na parte superior da tela
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    child: Image.asset(
                      'assets/imgs/login_logo.png',
                      height: 53,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Registo',
                    style: AppTextStyles.bigTextLoginRegist.copyWith(
                      color: AppColors.roxo,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Campo de input para o email
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Digita o teu Email',
                        alignLabelWithHint: true,
                        labelStyle: AppTextStyles.ligthTextLoginRegist
                            .copyWith(color: AppColors.primeiroPlano),
                        filled: true,
                        fillColor: AppColors.caixas_login_registo,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Campo de input para a password
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Digita a tua Password',
                        labelStyle: AppTextStyles.ligthTextLoginRegist
                            .copyWith(color: AppColors.primeiroPlano),
                        filled: true,
                        fillColor: AppColors.caixas_login_registo,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: true, // Oculta a password
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Campo de input para confirmar a password
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Repete a tua Password',
                        labelStyle: AppTextStyles.ligthTextLoginRegist
                            .copyWith(color: AppColors.primeiroPlano),
                        filled: true,
                        fillColor: AppColors.caixas_login_registo,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: true, // Oculta a password
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Botão de registo
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _register(context); // Chama a função de registo
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            AppColors.roxo), // Cor de fundo
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      child: Text(
                        'Registar',
                        style: AppTextStyles.mediumTextLoginRegist
                            .copyWith(color: AppColors.caixas_login_registo),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Espaço entre o botão e o texto
                  // Link para voltar à página de login
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      'Voltar ao login',
                      style: AppTextStyles.ligthTextLoginRegist
                          .copyWith(color: AppColors.primeiroPlano),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
