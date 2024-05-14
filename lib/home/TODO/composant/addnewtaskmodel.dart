// ignore_for_file: prefer_null_aware_operators

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/TODO/composant/date_time_widget.dart';
import 'package:flutter_application_1/home/TODO/composant/radiowedget.dart';
import 'package:flutter_application_1/home/TODO/composant/textfieldform.dart';
import 'package:flutter_application_1/home/TODO/model/todo_model.dart';
import 'package:flutter_application_1/home/TODO/provider/radio_provider.dart';
import 'package:flutter_application_1/home/TODO/provider/date_time_provider.dart';
import 'package:flutter_application_1/home/TODO/provider/service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskData {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  TaskData({
    required this.titleController,
    required this.descriptionController,
  });
}

class AddNewTaskModel extends ConsumerWidget {
  final TaskData taskData;

  const AddNewTaskModel({Key? key, required this.taskData}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? user = FirebaseAuth.instance.currentUser;
    final dateProv = ref.watch(dateProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        padding: EdgeInsets.all(30),
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                'New Task Todo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Divider(
              thickness: 1.2,
              color: Colors.grey.shade200,
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 200),
              child: Text(
                'Title Task :',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 6),
            Textfieldform(
              maxLine: 1,
              hintText: "Add Task Name",
              txtController: taskData.titleController,
            ),
            SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(right: 180),
              child: Text(
                'Description :',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Textfieldform(
              maxLine: 3,
              hintText: "Add Description",
              txtController: taskData.descriptionController,
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 190),
              child: Text(
                'Category :',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioWidget(
                    categColor: Color(0xFF7553F6),
                    titleRadio: 'Medecament',
                    valueInput: 1,
                    onChangeValue: () =>
                        ref.read(radioProvider.notifier).update((state) => 1),
                  ),
                ),
                Expanded(
                  child: RadioWidget(
                    categColor: Color(0xFF80A4FF),
                    titleRadio: 'Rendez vous ',
                    valueInput: 2,
                    onChangeValue: () =>
                        ref.read(radioProvider.notifier).update((state) => 2),
                  ),
                ),
                Expanded(
                  child: RadioWidget(
                    categColor: Color(0xFFF77D8E),
                    titleRadio: 'Other',
                    valueInput: 3,
                    onChangeValue: () =>
                        ref.read(radioProvider.notifier).update((state) => 3),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DateTimeWedget(
                  titleText: 'Date',
                  valueText: dateProv,
                  iconSection: CupertinoIcons.calendar,
                  onTap: () async {
                    final getValue = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2025),
                    );
                    if (getValue != null) {
                      final format = DateFormat.yMd();
                      ref
                          .read(dateProvider.notifier)
                          .update((state) => format.format(getValue));
                    }
                  },
                ),
                SizedBox(width: 22),
                DateTimeWedget(
                  titleText: 'Time',
                  valueText: ref.watch(timeProvider),
                  iconSection: CupertinoIcons.clock,
                  onTap: () async {
                    final getTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (getTime != null) {
                      ref
                          .read(timeProvider.notifier)
                          .update((state) => getTime.format(context));
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade800,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide(color: Colors.blue.shade800),
                      padding: EdgeInsetsDirectional.symmetric(
                        vertical: 14,
                      ),
                    ),
                    onPressed: () {}, //=> Navigator.pop(context),
                    child: Text("Cancel"),
                  ),
                ),
                SizedBox(width: 22),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsetsDirectional.symmetric(
                        vertical: 14,
                      ),
                    ),
                    onPressed: () {
                      final getRadioValue = ref.read(radioProvider);

                      String category = '';

                      switch (getRadioValue) {
                        case 1:
                          category = 'Medecament';
                          break;
                        case 2:
                          category = 'Rendez vous';
                          break;
                        case 3:
                          category = 'Other';
                          break;
                      }

                      ref.read(serviceProvider).addNewTask(
                            TodoModel(
                              category: category,
                              dateTask: ref.read(dateProvider),
                              description: taskData.descriptionController.text,
                              timeTask: ref.read(timeProvider),
                              titleTask: taskData.titleController.text,
                              isDone: false,
                            ),
                            user != null
                                ? user.uid
                                : null, // Ajout de l'ID de l'utilisateur
                          );

                      taskData.titleController.clear();
                      taskData.descriptionController.clear();
                      ref.read(radioProvider.notifier).update((state) => 0);
                      Navigator.pop(context);
                    },
                    child: Text("Create"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
