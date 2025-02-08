import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../styles/app_colors.dart';
import '../styles/app_text.dart';
import 'register_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _resetPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insere o teu email.')),
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email de recuperação enviado!')),
      );
      Navigator.pop(context); // Volta para a página de login
    } on FirebaseAuthException catch (e) {
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
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    child: Image.asset(
                      'assets/imgs/login_logo.png',
                      height: 53,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    'Recuperar',
                    style: AppTextStyles.bigTextLoginRegist.copyWith(
                      color: AppColors.roxo,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Introduz o teu email e enviaremos um link para recuperares a tua palavra-passe.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.ligthTextLoginRegist,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: AppTextStyles.ligthTextLoginRegist,
                        filled: true,
                        fillColor: AppColors.caixas_login_registo,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _resetPassword,
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(AppColors.roxo),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      child: Text(
                        'Enviar Email',
                        style: AppTextStyles.mediumTextLoginRegist.copyWith(
                          color: AppColors.caixas_login_registo,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Voltar ao Login',
                      style: AppTextStyles.ligthTextLoginRegist.copyWith(
                        color: AppColors.primeiroPlano,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      'Novo Registo',
                      style: AppTextStyles.ligthTextLoginRegist.copyWith(
                        color: AppColors.primeiroPlano,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
