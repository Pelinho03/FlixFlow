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
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final UserService userService = UserService();
  bool isLoading = true;
  String? photoUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userData = await userService.getUserProfile();
    if (userData != null) {
      nameController.text = userData['name'] ?? '';
      emailController.text = userData['email'] ?? '';
      photoUrl = userData['photoUrl']; // Carregar foto de perfil
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _saveUserProfile() async {
    await userService.saveUserProfile({
      'name': nameController.text,
      'email': emailController.text,
      'photoUrl': photoUrl,
      'updatedAt': DateTime.now().toIso8601String(),
    });
    Navigator.of(context).pop();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final imageUrl = await userService.uploadProfileImage(imageFile);
      if (imageUrl != null) {
        setState(() {
          photoUrl = imageUrl;
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
          // Imagem de fundo igual à da LoginPage
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
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.cinza,
                      backgroundImage: photoUrl != null
                          ? NetworkImage(photoUrl!)
                          : const AssetImage('assets/imgs/default_actor_v2.png')
                              as ImageProvider,
                      child: photoUrl == null
                          ? const Icon(Icons.camera_alt,
                              color: Colors.white, size: 30)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'O teu perfil',
                    style: AppTextStyles.bigTextLoginRegist.copyWith(
                      color: AppColors.roxo,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                      enabled: false,
                    ),
                  ),
                  const SizedBox(height: 20),
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
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 0,
        onItemTapped: (index) async {
          await NavigationService.handleNavigation(context, index);
        },
      ),
    );
  }
}
