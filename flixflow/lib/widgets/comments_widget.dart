import 'package:comment_box/comment/comment.dart';
import 'package:flixflow/styles/app_colors.dart';
import 'package:flixflow/styles/app_text.dart';
import 'package:flutter/material.dart';

class Comentarios extends StatefulWidget {
  @override
  _ComentariosState createState() => _ComentariosState();
}

class _ComentariosState extends State<Comentarios> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  // comentarios pre-definidos
  List<Map<String, String>> filedata = [
    {
      'name': 'Utilizador A',
      'pic': '../assets/imgs/user_icon.png',
      'message': 'Filme incrivel!',
      'date': '2024-10-09 12:08:00'
    },
    {
      'name': 'Utilizador B',
      'pic': '../assets/imgs/user_icon.png',
      'message': 'Gostava que tivesse mais ação, mas bom filme.',
      'date': '2024-10-21 15:45:00'
    },
    {
      'name': 'Utilizador C',
      'pic': '../assets/imgs/user_icon.png',
      'message': 'Fui ver ao cinema e não recomendo!',
      'date': '2024-10-03 19:34:00'
    },
  ];

  // Função para gerar os comentários
  Widget commentChild(data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ListTile(
          // Imagem do utilizador
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                data[index]['pic'] ?? '../assets/imgs/user_icon.png'),
          ),
          // Nome do utilizador ou o padrao
          title: Text(
            data[index]['name'] ?? 'Nome desconhecido',
            style: AppTextStyles.mediumBoldText.copyWith(color: AppColors.roxo),
          ),
          // Comentário ou o padrao
          subtitle: Text(
            data[index]['message'] ?? 'Sem mensagem',
            style: AppTextStyles.mediumText
                .copyWith(color: AppColors.primeiroPlano),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  size: 24,
                  color: AppColors.roxo,
                ),
                onPressed: () {
                  _editComment(index);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, size: 24, color: AppColors.roxo),
                onPressed: () {
                  _deleteComment(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Função para editar um comentário
  void _editComment(int index) {
    commentController.text = filedata[index]['message'] ??
        ''; // Preenche o campo de texto com o comentário existente
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Editar Comentário',
              style: AppTextStyles.bigText.copyWith(color: AppColors.roxo),
            ),
          ),
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(hintText: 'Novo comentário...'),
            style: AppTextStyles.mediumText
                .copyWith(color: AppColors.primeiroPlano),
          ),
          actions: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centraliza os botões
              children: [
                TextButton(
                  child: Text(
                    'Cancelar',
                    style: AppTextStyles.mediumText
                        .copyWith(color: AppColors.roxo),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 20), // Espaço entre os botões
                TextButton(
                  child: Text(
                    'Salvar',
                    style: AppTextStyles.mediumText
                        .copyWith(color: AppColors.roxo),
                  ),
                  onPressed: () {
                    setState(() {
                      filedata[index]['message'] =
                          commentController.text; // Atualiza o comentário
                    });
                    Navigator.of(context).pop();
                    commentController.clear();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Função para remover um comentário
  void _deleteComment(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Remover Comentário',
              style: AppTextStyles.bigText.copyWith(color: AppColors.vermelho),
            ),
          ),
          content: Text(
            'Queres mesmo remover este comentário?',
            style: AppTextStyles.mediumText
                .copyWith(color: AppColors.primeiroPlano),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    'Cancelar',
                    style: AppTextStyles.mediumText
                        .copyWith(color: AppColors.roxo),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                TextButton(
                  child: Text(
                    'Remover',
                    style: AppTextStyles.mediumText
                        .copyWith(color: AppColors.roxo),
                  ),
                  onPressed: () {
                    setState(() {
                      filedata.removeAt(index); // Remove o comentário
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommentBox(
      userImage: CommentBox.commentImageParser(
          imageURLorPath: "../assets/imgs/user_icon.png"),
      child: commentChild(filedata), // Lista de comentários
      labelText: 'Comentário...',
      errorText: 'O comentário não pode ser vazio!',
      sendButtonMethod: () {
        if (formKey.currentState!.validate()) {
          setState(() {
            var value = {
              'name': 'Paulo Guimarães',
              'pic': '../assets/imgs/user_icon.png',
              'message': commentController.text,
              'date': DateTime.now().toString(),
            };
            filedata.insert(0, value);
          });
          commentController.clear();
          FocusScope.of(context).unfocus();
        }
      },
      formKey: formKey,
      commentController: commentController,
      backgroundColor: AppColors.roxo,
      textColor: AppColors.primeiroPlano,
      sendWidget: Icon(Icons.send, size: 24, color: AppColors.primeiroPlano),
    );
  }
}
