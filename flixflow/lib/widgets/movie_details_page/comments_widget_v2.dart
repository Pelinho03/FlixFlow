import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import 'package:flixflow/styles/app_colors.dart';
import 'package:flixflow/styles/app_text.dart';

class CommentWidget extends StatefulWidget {
  final String movieId;

  const CommentWidget({super.key, required this.movieId});

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final TextEditingController _controller = TextEditingController();
  final UserService _userService = UserService();
  List<Map<String, dynamic>> _comments = [];
  bool _isEditing = false;
  int _editingIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    final comments = await _userService.getComments(widget.movieId);
    setState(() {
      _comments = comments;
    });
  }

  Future<void> _submitComment() async {
    if (_controller.text.trim().isEmpty) return;

    if (_isEditing) {
      await _userService.editComment(
          widget.movieId, _editingIndex, _controller.text.trim());

      setState(() {
        _isEditing = false;
        _editingIndex = -1;
      });
    } else {
      await _userService.addComment(widget.movieId, _controller.text.trim());
    }

    _controller.clear();
    await _loadComments(); // Atualiza a lista de comentários
  }

  Future<void> _deleteComment(int index) async {
    await _userService.deleteComment(widget.movieId, index);
    _loadComments();
  }

  void _editComment(int index) {
    setState(() {
      _controller.text = _comments[index]['text'];
      _isEditing = true;
      _editingIndex = index;
    });
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Confirmação de remoção",
              style: AppTextStyles.bigText.copyWith(color: AppColors.vermelho),
            ),
          ),
          content: Text(
            "Tens a certeza que queres apagar?",
            style: AppTextStyles.mediumText
                .copyWith(color: AppColors.primeiroPlano),
            textAlign: TextAlign
                .center, // Opcional para garantir o alinhamento centralizado
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Cancelar",
                    style: AppTextStyles.mediumText
                        .copyWith(color: AppColors.roxo),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _deleteComment(index);
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
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: _isEditing ? "Editar comentário..." : "Escreve aqui...",
            border: const OutlineInputBorder(),
            hintStyle: AppTextStyles.mediumText
                .copyWith(color: AppColors.primeiroPlano),
          ),
          maxLines: 1,
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: _submitComment,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.roxo, // Cor do botão
              foregroundColor: AppColors.primeiroPlano, // Cor do texto no botão
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
                child: Text("Sê o primeiro a comentar...",
                    style: AppTextStyles.mediumText
                        .copyWith(color: AppColors.primeiroPlano)),
              )
            : Column(
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
                      subtitle: Text(
                        comment['timestamp'] != null
                            ? DateFormat('dd/MM/yyyy HH:mm').format(
                                (comment['timestamp'] as Timestamp).toDate())
                            : "Sem data",
                        style: AppTextStyles.smallText
                            .copyWith(color: AppColors.roxo),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: AppColors.roxo),
                            onPressed: () => _editComment(index),
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.delete, color: AppColors.roxo),
                            onPressed: () =>
                                _confirmDelete(index), // Agora chama o popup
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
