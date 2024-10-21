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

  // Exemplo de dados de comentários
  List<Map<String, String>> filedata = [
    {
      'name': 'Utilizador A',
      'pic': '',
      'message': 'Filme incrivel!',
      'date': '2024-10-09 12:08:00'
    },
    {
      'name': 'Utilizador B',
      'pic': '',
      'message': 'Gostava que tivesse mais ação, mas bom filme.',
      'date': '2024-10-21 15:45:00'
    },
    {
      'name': 'Utilizador C',
      'pic': '',
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
          leading: CircleAvatar(
            backgroundImage: NetworkImage(data[index]['pic'] ?? ''),
          ),
          title: Text(
            data[index]['name'] ?? 'Nome desconhecido',
            style: AppTextStyles.mediumBoldText.copyWith(color: AppColors.roxo),
          ),
          subtitle: Text(
            data[index]['message'] ?? '',
            style: AppTextStyles.regularText
                .copyWith(color: AppColors.primeiroPlano),
          ),
          trailing: Text(
            data[index]['date'] ?? '',
            style: AppTextStyles.smallText.copyWith(color: AppColors.roxo),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommentBox(
      userImage: CommentBox.commentImageParser(
          imageURLorPath:
              ""), // Imagem do utilizador //https://picsum.photos/300/30
      child: commentChild(filedata), // Lista de comentários
      labelText: 'Comentário...',
      errorText: 'O comentário não pode ser vazio!',
      sendButtonMethod: () {
        if (formKey.currentState!.validate()) {
          setState(() {
            var value = {
              'name': 'Paulo',
              'pic': '',
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
      sendWidget: Icon(Icons.send, size: 30, color: Colors.white),
    );
  }
}
