import 'package:flutter_application_1/home/TODO/model/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  // Méthode pour ajouter une nouvelle tâche
  Future<void> addNewTask(TodoModel model, String? s) async {
    try {
      if (_user != null) {
        await _firestore
            .collection('users')
            .doc(_user.uid)
            .collection('todoApp')
            .add(model.toMap());
      } else {
        throw Exception('User not logged in');
      }
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  // Méthode pour mettre à jour une tâche
  Future<void> updateTask(String? docId, bool? valueUpdate) async {
    try {
      if (_user != null) {
        await _firestore
            .collection('users')
            .doc(_user.uid)
            .collection('todoApp')
            .doc(docId)
            .update({'isDone': valueUpdate});
      } else {
        throw Exception('User not logged in');
      }
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  // Méthode pour supprimer une tâche
  Future<void> deleteTask(String? docId) async {
    try {
      if (_user != null) {
        await _firestore
            .collection('users')
            .doc(_user.uid)
            .collection('todoApp')
            .doc(docId)
            .delete();
      } else {
        throw Exception('User not logged in');
      }
    } catch (e) {
      print('Error deleting task: $e');
    }
  }
}
