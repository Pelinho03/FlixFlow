import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Adicionar Firebase
import 'login_page.dart'; // Importar a página de Login
import '../styles/app_colors.dart';
import '../styles/app_text.dart';

class RegisterPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController =
      TextEditingController(); // Modificar para email
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  RegisterPage({super.key});

  // Função de registo
  void _register(BuildContext context) async {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      try {
        final UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        print("Registo bem-sucedido: ${userCredential.user!.email}");
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
        print('Erro: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${e.message}')),
        );
      }
    } else {
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
                image: AssetImage(
                    'assets/imgs/login_bg2.png'), // Caminho da sua imagem
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
                  // Adicionando o logo acima de tudo
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
                      obscureText:
                          true, // Mantenha isto para ocultar a password
                    ),
                  ),
                  const SizedBox(height: 16),
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
                      obscureText:
                          true, // Mantenha isto para ocultar a password
                    ),
                  ),
                  const SizedBox(height: 20),
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
                            borderRadius: BorderRadius.circular(
                                6), // Ajuste o valor conforme necessário
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
                  const SizedBox(
                      height: 20), // Espaçamento entre o botão e o texto
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Clica aqui para voltar ao login',
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
