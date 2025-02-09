import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Adiciona um comentário ao filme no perfil do utilizador
  Future<void> addComment(String movieId, String comment) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore.collection('users').doc(user.uid);
    final userDoc = await docRef.get();
    final username = userDoc.data()?['profile']?['name'] ?? user.email;

    final newComment = {
      'username': username, // Nome do utilizador associado ao comentário
      'text': comment,
      'timestamp': Timestamp.now(),
    };

    // Guarda o comentário na coleção do utilizador
    await docRef.set({
      'comments': {
        movieId: FieldValue.arrayUnion([newComment]),
      },
    }, SetOptions(merge: true));
  }

  // Obtém todos os comentários do utilizador para um filme específico
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

  // Edita um comentário existente
  Future<void> editComment(String movieId, int index, String newComment) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (doc.exists) {
      final comments = List<Map<String, dynamic>>.from(
          (doc.data()?['comments']?[movieId] as List<dynamic>?) ?? []);

      if (index < comments.length) {
        final updatedComment = {
          'username': comments[index]['username'], // Mantém o mesmo nome
          'text': newComment,
          'timestamp': Timestamp.now(),
        };

        comments[index] = updatedComment;

        await docRef.update({'comments.$movieId': comments});
      }
    }
  }

  // Remove um comentário do filme
  Future<void> deleteComment(String movieId, int index) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (doc.exists) {
      final comments = List<Map<String, dynamic>>.from(
          (doc.data()?['comments']?[movieId] as List<dynamic>?) ?? []);

      if (index < comments.length) {
        comments.removeAt(index);
        await docRef.update({'comments.$movieId': comments});
      }
    }
  }

  // Obtém a avaliação do filme dada pelo utilizador
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

  // Guarda a avaliação do utilizador para um filme
  Future<void> rateMovie(String movieId, double rating) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore.collection('users').doc(userId).set({
      'ratings': {movieId: rating}
    }, SetOptions(merge: true));
  }

  // Obtém a referência ao documento do utilizador no Firestore
  DocumentReference<Map<String, dynamic>> _getUserDoc() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Utilizador não autenticado.");
    }
    return _firestore.collection('users').doc(user.uid);
  }

  // Guarda ou atualiza as informações do perfil do utilizador
  Future<void> saveUserProfile(Map<String, dynamic> profileData) async {
    try {
      final userDoc = _getUserDoc();
      await userDoc.set(
        {'profile': profileData},
        SetOptions(merge: true),
      );
    } catch (e) {
      // print("Erro ao guardar perfil: $e");
    }
  }

  // Obtém os dados do perfil do utilizador autenticado
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final userDoc = _getUserDoc();
      final docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        Map<String, dynamic> userData = docSnapshot.data()?['profile'] ?? {};
        userData['email'] = user.email;
        return userData;
      }
    } catch (e) {
      // print("Erro ao obter perfil: $e");
    }
    return null;
  }

  // Faz upload da imagem de perfil do utilizador para o Firebase Storage
  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final ref = _storage.ref().child('profile_images/${user.uid}.jpg');
      await ref.putFile(imageFile);
      final imageUrl = await ref.getDownloadURL();

      // Atualiza a imagem no Firestore
      await _getUserDoc().set(
        {
          'profile': {'photoUrl': imageUrl}
        },
        SetOptions(merge: true),
      );

      return imageUrl;
    } catch (e) {
      // print("Erro ao fazer upload da imagem: $e");
      return null;
    }
  }
}
