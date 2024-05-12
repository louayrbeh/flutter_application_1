// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/home/TODO/composant/addnewtaskmodel.dart';
import 'package:flutter_application_1/home/TODO/composant/card_todo_widget.dart';
import 'package:flutter_application_1/home/TODO/provider/service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Todo extends ConsumerWidget {
  Todo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final taskData = TaskData(
      titleController: titleController,
      descriptionController: descriptionController,
    );

    final todoData = ref.watch(fetchStreamProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(
          "TODO",
          style: TextStyle(fontFamily: "Poppins"),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Utilisation de DateFormat pour obtenir le nom du jour suivi de la date
                      Text(
                        DateFormat('EEEE ,').format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        DateFormat('dd MMMM yyyy').format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF80A4FF),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            context: context,
                            builder: (context) =>
                                AddNewTaskModel(taskData: taskData),
                          );
                        },
                        child: Text(
                          "+ New Task",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: todoData.value != null ? todoData.value!.length : 0,
                shrinkWrap: true,
                reverse: true,
                itemBuilder: (context, index) => CardTodoListWidget(
                  getIndex: index,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
