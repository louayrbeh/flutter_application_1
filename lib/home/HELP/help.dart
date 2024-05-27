import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationOnTap extends StatelessWidget {
  const NotificationOnTap({super.key, required this.response});
  final NotificationResponse response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ontap not "),
        backgroundColor: Colors.amberAccent,
      ),
    );
  }
}
