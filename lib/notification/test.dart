// ignore_for_file: avoid_print, prefer_const_constructors, avoid_single_cascade_in_expression_statements

import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/HELP/help.dart';
import 'package:flutter_application_1/notification/local_notification_service.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenToNoticationStrean();
  }

  void listenToNoticationStrean() {
    LocalNotificationService.streamController.stream
        .listen((notificationResponse) {
      print(notificationResponse.id!.toString());
      print(notificationResponse.payload!.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  NotificationOnTap(response: notificationResponse)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("notifff"),
        backgroundColor: Colors.amberAccent,
      ),
      body: Center(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                LocalNotificationService.showBasicNotification();
              },
              leading: Icon(Icons.notifications),
              title: Text("basic not"),
              trailing: IconButton(
                icon: Icon(
                  Icons.cancel,
                ),
                onPressed: () {},
              ),
            ),
            ListTile(
              onTap: () {
                LocalNotificationService.showRepeatedNotification();
              },
              leading: Icon(Icons.notifications),
              title: Text("Repeated not"),
              trailing: IconButton(
                icon: Icon(
                  Icons.cancel,
                ),
                onPressed: () {
                  LocalNotificationService.cancelNotification(0);
                },
              ),
            ),
            /*   ListTile(
              onTap: () {
                LocalNotificationService.showScheluledNotification();
              },
              leading: Icon(Icons.notifications),
              title: Text("Scheduled notif"),
              trailing: IconButton(
                icon: Icon(
                  Icons.cancel,
                ),
                onPressed: () {},
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
