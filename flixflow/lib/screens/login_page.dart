import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Adiciona a firebase
import 'register_page.dart';
import 'home_page.dart';
import '../styles/app_colors.dart';
import '../styles/app_text.dart';

class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instância do FirebaseAuth
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Função para login com Firebase
  void _login(BuildContext context) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print("Login bem-sucedido: ${userCredential.user!.email}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bem-vindo, ${userCredential.user!.email}!')),
      );
      // Redirecionar para a home_page após login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      print('Erro: $e');
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
          // Imagem de fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/imgs/login_bg2.png'),
                fit: BoxFit.cover, // para cobrir toda a área
              ),
            ),
          ),
          // Conteúdo da página
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //logoyipo flixflow
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    child: Image.asset(
                      'assets/imgs/login_logo.png',
                      height: 53,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  //titulo simples com os meus estilos
                  Text(
                    'Login',
                    style: AppTextStyles.bigTextLoginRegist.copyWith(
                      color: AppColors.roxo,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      textAlign: TextAlign.center, // Alinhamento do texto
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Digita o teu Email',
                        alignLabelWithHint:
                            true, // para alinhar o texto com o campo
                        labelStyle: AppTextStyles.ligthTextLoginRegist
                            .copyWith(color: AppColors.primeiroPlano),
                        filled: true,
                        fillColor: AppColors.caixas_login_registo,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
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
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _login(context); // Chama a função de login
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            AppColors.roxo), // Cor de fundo
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(6), // Raio da borda
                          ),
                        ),
                      ),
                      child: Text(
                        'Entrar',
                        style: AppTextStyles.mediumTextLoginRegist.copyWith(
                          color: AppColors.caixas_login_registo,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 20), // Espaçamento entre o botão e o texto
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        // Navega para o registo
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Clica aqui para te registares',
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
      backgroundColor: Colors.transparent, // Remove a cor de fundo do Scaffold
    );
  }
}
