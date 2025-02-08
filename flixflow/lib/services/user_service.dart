import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Adicionar um comentário (sem substituir os existentes)
  // Adicionar um comentário (sem substituir os existentes)
  Future<void> addComment(String movieId, String comment) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore.collection('users').doc(user.uid);

    // Buscar o username na coleção 'username' do usuário
    final userDoc = await docRef.get();
    final username =
        userDoc.data()?['username'] ?? 'Usuário desconhecido'; // Valor padrão

    // Criar o comentário separadamente
    final newComment = {
      'username': username, // Adiciona o nome do usuário ao comentário
      'text': comment,
      'timestamp': Timestamp.now(),
    };

    await docRef.set({
      'comments': {
        movieId: FieldValue.arrayUnion([newComment]),
      },
    }, SetOptions(merge: true));
  }

  // Obter todos os comentários do utilizador para um filme específico
  Future<List<Map<String, dynamic>>> getComments(String movieId) async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      final comments = doc.data()?['comments']?[movieId] as List<dynamic>?;

      if (comments != null) {
        return comments.map((c) => Map<String, dynamic>.from(c)).toList();
      }
    }
    return [];
  }

  // Editar um comentário
  // Editar um comentário
  Future<void> editComment(String movieId, int index, String newComment) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (doc.exists) {
      final comments = List<Map<String, dynamic>>.from(
          (doc.data()?['comments']?[movieId] as List<dynamic>?) ?? []);

      if (index < comments.length) {
        // Manter o 'username' do comentário original (sem alterar)
        final updatedComment = {
          'username': comments[index]['username'], // Usa o mesmo username
          'text': newComment,
          'timestamp': Timestamp.now(),
        };

        comments[index] = updatedComment;

        await docRef.update({
          'comments.$movieId': comments,
        });
      }
    }
  }

  // Apagar um comentário
  Future<void> deleteComment(String movieId, int index) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (doc.exists) {
      final comments = doc.data()?['comments']?[movieId] as List<dynamic>?;

      if (comments != null && index < comments.length) {
        comments.removeAt(index);

        await docRef.update({
          'comments.$movieId': comments,
        });
      }
    }
  }

  // Obter Avaliação do Filme
  Future<double?> getMovieRating(String movieId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return null;

    final docSnapshot = await _firestore.collection('users').doc(userId).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      final ratings = data['ratings'] as Map<String, dynamic>?;

      return ratings != null && ratings.containsKey(movieId)
          ? (ratings[movieId] as num).toDouble()
          : null;
    }
    return null;
  }

  // Avaliar um Filme
  Future<void> rateMovie(String movieId, double rating) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore.collection('users').doc(userId).set({
      'ratings': {movieId: rating}
    }, SetOptions(merge: true));
  }

  // Salvar o nome de utilizador
  Future<void> saveUsername(String username) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userRef = _firestore.collection('users').doc(user.uid);

    await userRef.set(
        {
          'username':
              username, // Salva o nome de utilizador no campo 'username'
        },
        SetOptions(
            merge:
                true)); // 'merge' garante que outros dados não sejam substituídos
  }

  // Obter o nome de utilizador
  Future<String?> getUsername() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final userRef = _firestore.collection('users').doc(user.uid);
    final doc = await userRef.get();

    if (doc.exists) {
      return doc.data()?['username']; // Retorna o nome de utilizador
    }

    return null;
  }
}
