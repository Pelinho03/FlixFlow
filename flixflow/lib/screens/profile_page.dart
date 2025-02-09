import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flixflow/services/user_service.dart';
import 'package:flixflow/styles/app_colors.dart';
import 'package:flixflow/styles/app_text.dart';
import 'package:flixflow/widgets/custom_app_bar.dart';
import 'package:flixflow/widgets/custom_bottom_navigation_bar.dart';
import '../services/navigation_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final UserService userService = UserService();
  bool isLoading = true;
  String? photoUrl; // URL da foto de perfil do utilizador

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // Carrega os dados do perfil ao iniciar a página
  }

  // Obtém os dados do utilizador a partir do Firestore
  Future<void> _loadUserProfile() async {
    final userData = await userService.getUserProfile();
    if (userData != null) {
      nameController.text = userData['name'] ?? '';
      emailController.text = userData['email'] ?? '';
      photoUrl = userData['photoUrl']; // Carrega a foto de perfil, se existir
    }
    setState(() {
      isLoading = false;
    });
  }

  // Guarda as alterações do perfil no Firestore
  Future<void> _saveUserProfile() async {
    await userService.saveUserProfile({
      'name': nameController.text,
      'email': emailController.text,
      'photoUrl': photoUrl,
      'updatedAt':
          DateTime.now().toIso8601String(), // Regista a data de atualização
    });
    Navigator.of(context).pop(); // Fecha a página após salvar
  }

  // Permite ao utilizador escolher uma imagem da galeria e fazer upload
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final imageUrl = await userService.uploadProfileImage(imageFile);
      if (imageUrl != null) {
        setState(() {
          photoUrl = imageUrl; // Atualiza a imagem de perfil
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Perfil"),
      body: Stack(
        children: [
          // Imagem de fundo do perfil
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/imgs/profile_bg_v2.png'),
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
                  // Avatar do utilizador
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.cinza,
                      backgroundImage: photoUrl != null
                          ? NetworkImage(
                              photoUrl!) // Foto de perfil do Firestore
                          : const AssetImage('assets/imgs/logo_dark_1_1024.png')
                              as ImageProvider, // Imagem padrão
                      // child: photoUrl == null
                      //     ? const Icon(Icons.camera_alt,
                      //         color: Colors.white, size: 30)
                      //     : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Título
                  Text(
                    'O teu perfil',
                    style: AppTextStyles.bigTextLoginRegist.copyWith(
                      color: AppColors.roxo,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // alterar o nome do utilizador
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        labelStyle: AppTextStyles.ligthTextLoginRegist.copyWith(
                          color: AppColors.primeiroPlano,
                        ),
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
                  // Campo para visualizar o email (não editável)
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: AppTextStyles.ligthTextLoginRegist.copyWith(
                          color: AppColors.primeiroPlano,
                        ),
                        filled: true,
                        fillColor: AppColors.caixas_login_registo,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      enabled: false, // O email não pode ser alterado
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Botão para guardar as alterações do perfil
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveUserProfile,
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
                        'Guardar',
                        style: AppTextStyles.mediumTextLoginRegist.copyWith(
                          color: AppColors.caixas_login_registo,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Barra de navegação inferior
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 0,
        onItemTapped: (index) async {
          await NavigationService.handleNavigation(context, index);
        },
      ),
    );
  }
}
