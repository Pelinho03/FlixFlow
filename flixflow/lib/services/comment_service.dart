import 'package:cloud_firestore/cloud_firestore.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addComment(String userId, String movieId, String comment) async {
    try {
      await _firestore
          .collection('users') // Acede à coleção "users"
          .doc(userId) // Documento do utilizador
          .collection('comments') // Subcoleção "comments"
          .doc(movieId) // Documento com o ID do filme
          .collection('user_comments') // Subcoleção para múltiplos comentários
          .add({'message': comment, 'timestamp': FieldValue.serverTimestamp()});
    } catch (e) {
      print('Erro ao adicionar comentário: $e');
    }
  }
}

//PEGAR MAIS TARDE NISTO
