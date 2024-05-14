// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/home/TODO/model/todo_model.dart';
import 'package:flutter_application_1/home/TODO/services/todo_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final serviceProvider = StateProvider<TodoService>((ref) {
  return TodoService();
});

final fetchStreamProvider = StreamProvider<List<TodoModel>>((ref) async* {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final getData = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('todoApp')
        .snapshots()
        .map((event) => event.docs
            .map((snapshot) => TodoModel.fromSnapshot(snapshot))
            .toList());
    yield* getData;
  }
});
