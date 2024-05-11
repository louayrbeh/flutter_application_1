import 'package:flutter_application_1/home/TODO/model/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoService {
  final todoCollection = FirebaseFirestore.instance.collection('todoApp');

//create
  void addNewTask(TodoModel model) {
    todoCollection.add(model.toMap());
  }

  // update
  void updateTask(String? docId, bool? valueUpdate) {
    todoCollection.doc(docId).update({
      'isDone': valueUpdate,
    });
  }

//delete

  void deleteTask(String? docId) {
    todoCollection.doc(docId).delete();
  }
}
