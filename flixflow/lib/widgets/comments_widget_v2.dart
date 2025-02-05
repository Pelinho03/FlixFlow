import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/user_service.dart';
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
      // Editar comentário existente
      await _userService.editComment(
          widget.movieId, _editingIndex, _controller.text.trim());
      setState(() {
        _isEditing = false;
        _editingIndex = -1;
      });
    } else {
      // Adicionar novo comentário
      await _userService.addComment(widget.movieId, _controller.text.trim());
    }

    _controller.clear();
    _loadComments();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Comentários:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: _isEditing ? "Editar comentário..." : "Escreve aqui...",
            border: OutlineInputBorder(),
            hintStyle: AppTextStyles.mediumText
                .copyWith(color: AppColors.primeiroPlano),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
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
        const SizedBox(height: 20),
        _comments.isEmpty
            ? const Text("Ainda não há comentários.")
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
                            ? (comment['timestamp'] as Timestamp)
                                .toDate()
                                .toString() // Converte Timestamp em DateTime
                            : "Sem data", // Caso não tenha timestamp
                        style: AppTextStyles.smallText
                            .copyWith(color: AppColors.primeiroPlano),
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
                            onPressed: () => _deleteComment(index),
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
