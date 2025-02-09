import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import 'package:flixflow/styles/app_colors.dart';
import 'package:flixflow/styles/app_text.dart';

class CommentWidget extends StatefulWidget {
  // Recebe o ID do filme para associar aos comentários.
  final String movieId;

  const CommentWidget({super.key, required this.movieId});

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final TextEditingController _controller =
      TextEditingController(); // Controlador do campo de texto para o comentário.
  final UserService _userService =
      UserService(); // Serviço de manipulação de comentários.
  List<Map<String, dynamic>> _comments =
      []; // Lista de comentários carregada do Firestore.
  bool _isEditing = false; // Flag para saber se estamos a editar um comentário.
  int _editingIndex = -1; // Índice do comentário que está a ser editado.

  @override
  void initState() {
    super.initState();
    _loadComments(); // Carrega os comentários do Firestore quando a página é iniciada.
  }

  // Função assíncrona para carregar os comentários do Firestore.
  Future<void> _loadComments() async {
    final comments = await _userService.getComments(
        widget.movieId); // Chama o serviço para buscar comentários do filme.
    setState(() {
      _comments = comments;
    });
  }

  // Função para enviar um comentário.
  Future<void> _submitComment() async {
    if (_controller.text.trim().isEmpty)
      return; // Não permite enviar comentário vazio.

    if (_isEditing) {
      // Se estamos a editar um comentário, chama a função de edição.
      await _userService.editComment(
          widget.movieId, _editingIndex, _controller.text.trim());

      setState(() {
        _isEditing = false; // Desativa o modo de edição.
        _editingIndex = -1; // Limpa o índice de edição.
      });
    } else {
      // Caso contrário, cria um novo comentário.
      await _userService.addComment(widget.movieId, _controller.text.trim());
    }

    _controller.clear(); // Limpa o campo de texto após o envio.
    await _loadComments(); // Atualiza a lista de comentários.
  }

  // Função para apagar um comentário.
  Future<void> _deleteComment(int index) async {
    await _userService.deleteComment(
        widget.movieId, index); // Chama o serviço para apagar o comentário.
    _loadComments(); // Atualiza a lista após apagar.
  }

  // Função para iniciar a edição de um comentário.
  void _editComment(int index) {
    setState(() {
      _controller.text = _comments[index]
          ['text']; // Carrega o texto do comentário para o campo de edição.
      _isEditing = true; // Habilita o modo de edição.
      _editingIndex = index; // Armazena o índice do comentário a ser editado.
    });
  }

  // Função para confirmar a exclusão do comentário com um pop-up de confirmação.
  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Confirmação de remoção", // Título do pop-up.
              style: AppTextStyles.bigText.copyWith(color: AppColors.vermelho),
            ),
          ),
          content: Text(
            "Tens a certeza que queres apagar?", // Mensagem do pop-up.
            style: AppTextStyles.mediumText
                .copyWith(color: AppColors.primeiroPlano),
            textAlign: TextAlign.center, // Alinha o texto centralizado.
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context)
                      .pop(), // Fecha o pop-up se clicar em "Cancelar".
                  child: Text(
                    "Cancelar",
                    style: AppTextStyles.mediumText
                        .copyWith(color: AppColors.roxo),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context)
                        .pop(); // Fecha o pop-up após a confirmação.
                    await _deleteComment(index); // Apaga o comentário.
                  },
                  child: Text(
                    "Apagar",
                    style: AppTextStyles.mediumText
                        .copyWith(color: AppColors.roxo),
                  ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        // Campo de texto para o comentário.
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: _isEditing ? "Editar comentário..." : "Escreve aqui...",
            border: const OutlineInputBorder(),
            hintStyle: AppTextStyles.mediumText
                .copyWith(color: AppColors.primeiroPlano),
          ),
          maxLines: 1, // Limita o campo a uma linha.
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed:
                _submitComment, // Chama a função para submeter o comentário.
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.roxo, // Cor do botão.
              foregroundColor:
                  AppColors.primeiroPlano, // Cor do texto no botão.
            ),
            child: Text(
              _isEditing ? "Editar Comentário" : "Adicionar Comentário",
              style: AppTextStyles.mediumText.copyWith(
                color: AppColors.primeiroPlano,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Divider(
          height: 20,
          color: AppColors.roxo,
          thickness: 0.1,
        ),
        _comments.isEmpty
            ? Center(
                child: Text(
                    "Sê o primeiro a comentar...", // Mensagem caso não haja comentários.
                    style: AppTextStyles.mediumText
                        .copyWith(color: AppColors.primeiroPlano)),
              )
            : Column(
                // Exibe os comentários existentes.
                children: _comments.asMap().entries.map((entry) {
                  final index = entry.key;
                  final comment = entry.value;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                        comment['text'],
                        style: AppTextStyles.mediumText
                            .copyWith(color: AppColors.primeiroPlano),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment['username'], // Exibe o nome do utilizador.
                            style: AppTextStyles.smallText
                                .copyWith(color: AppColors.roxo),
                          ),
                          Text(
                            comment['timestamp'] != null
                                ? DateFormat('dd/MM/yyyy HH:mm').format(
                                    (comment['timestamp'] as Timestamp)
                                        .toDate())
                                : "Sem data", // Exibe a data de criação do comentário.
                            style: AppTextStyles.smallText
                                .copyWith(color: AppColors.roxo),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: AppColors.roxo),
                            onPressed: () => _editComment(
                                index), // Chama a função de edição.
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.delete, color: AppColors.roxo),
                            onPressed: () => _confirmDelete(
                                index), // Chama o pop-up de confirmação.
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }
}
