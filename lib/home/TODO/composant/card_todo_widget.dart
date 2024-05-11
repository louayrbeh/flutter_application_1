// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_const_constructors_in_immutables

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/TODO/provider/service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardTodoListWidget extends ConsumerWidget {
  CardTodoListWidget({
    super.key,
    required this.getIndex,
  });
  final int getIndex;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoData = ref.watch(fetchStreamProvider);
    return todoData.when(
        data: (todoData) {
          Color categoryColor = Colors.white;
          final getCategory = todoData[getIndex].category;
          switch (getCategory) {
            case 'Medecament':
              categoryColor = Color(0xFF7553F6);
              break;
            case 'Rendez vous':
              categoryColor = Color(0xFF80A4FF);
              break;
            case 'Other':
              categoryColor = Color.fromARGB(255, 225, 128, 255);
              break;
          }

          return Container(
            margin: EdgeInsets.symmetric(vertical: 6),
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  width: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: IconButton(
                            icon: Icon(CupertinoIcons.delete),
                            onPressed: () => ref
                                .read(serviceProvider)
                                .deleteTask(todoData[getIndex].docId),
                          ),
                          title: Text(
                            todoData[getIndex].titleTask,
                            maxLines: 1,
                            style: TextStyle(
                                decoration: todoData[getIndex].isDone
                                    ? TextDecoration.lineThrough
                                    : null),
                          ),
                          subtitle: Text(
                            todoData[getIndex].description,
                            maxLines: 1,
                            style: TextStyle(
                                decoration: todoData[getIndex].isDone
                                    ? TextDecoration.lineThrough
                                    : null),
                          ),
                          trailing: Transform.scale(
                            scale: 1.5,
                            child: Checkbox(
                              activeColor: Colors.blue.shade800,
                              shape: CircleBorder(),
                              value: todoData[getIndex].isDone,
                              onChanged: (value) {
                                ref.read(serviceProvider).updateTask(
                                    todoData[getIndex].docId, value);
                              },
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(0, -12),
                          child: Container(
                            child: Column(
                              children: [
                                Divider(
                                  thickness: 1.5,
                                  color: Colors.grey.shade200,
                                ),
                                Row(
                                  children: [
                                    Text(todoData[getIndex].dateTask),
                                    SizedBox(width: 12),
                                    Text(todoData[getIndex].timeTask),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) => const Center(
              child: Text(' errrrrrrorrr'),
            ),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }
}
