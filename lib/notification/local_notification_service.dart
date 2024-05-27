import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
      StreamController();
  static onTap(NotificationResponse notificationResponse) {
    streamController.add(notificationResponse);
  }

  static Future init() async {
    InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings("mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
  }

  static void showBasicNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      "id 1",
      "basic notification",
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails details = const NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin.show(
      0,
      "Good morning",
      "Don't forget to check your todo list",
      details,
    );
  }

  static void showRepeatedNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      "id 2",
      "Repeated notification",
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails details = const NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      "Repeated notif",
      "body",
      RepeatInterval.everyMinute,
      details,
      payload: "payload data",
    );
  }

  static void cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static void showScheduledNotification(
      {required DateTime currentDate, required TimeOfDay scheduledTime}) async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      "id 3",
      "Scheduled notification",
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails details = const NotificationDetails(android: android);
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      currentDate.year,
      currentDate.month,
      currentDate.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    // Ensure the scheduled time is in the future
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      "Title",
      "description",
      scheduledDate,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: "payload data",
    );
  }

  static void showDailyScheduledNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      "id 4",
      "DAILY Scheduled notification",
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails details = const NotificationDetails(android: android);
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    var currentTime = tz.TZDateTime.now(tz.local);
    var scheduledTime = tz.TZDateTime(
      tz.local,
      currentTime.year,
      currentTime.month,
      currentTime.day,
      9,
      0,
    );

    if (scheduledTime.isBefore(currentTime)) {
      scheduledTime = scheduledTime.add(Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      4,
      "Good morning",
      "Don't forget to check your todo list!",
      scheduledTime,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}




/*
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
      StreamController();
  static onTap(NotificationResponse notificationResponse) {
    streamController.add(notificationResponse);
  }

  static Future init() async {
    InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings("mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
  }

  static void showBasicNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      "id 1",
      "basic notification",
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails details = const NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin.show(
      0,
      "Good morning",
      "Don 't forget to check your todo list ",
      details,
    );
  }

  static void showRepeatedNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      "id 2",
      "Repeated notification",
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails details = const NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      "Repeated notif",
      "body",
      RepeatInterval.everyMinute,
      details,
      payload: "payload data",
    );
  }

  static void cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static void showScheduledNotification(
      {required DateTime currentDate, required TimeOfDay scheduledTime}) async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      "id 3",
      "Scheluled notification",
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails details = const NotificationDetails(android: android);
    tz.initializeTimeZones();
    print(tz.local.name);
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    print(currentTimeZone);
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    print(tz.TZDateTime.now(tz.local).hour.toString());
    print(tz.TZDateTime.now(tz.local).minute.toString());

    await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      "Title",
      "description",
      tz.TZDateTime(tz.local, currentDate.year, currentDate.month,
              currentDate.day, scheduledTime.hour, scheduledTime.minute)
          .subtract(Duration(minutes: 1)),
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: "payload data",
    );
  }

  static void showDailyScheduledNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      "id 4",
      "DAILY Scheluled notification",
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails details = const NotificationDetails(android: android);
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Tunis'));
    var currentTime = tz.TZDateTime.now(tz.local);
    var scheduledTime = tz.TZDateTime(
      tz.local,
      currentTime.year,
      currentTime.month,
      currentTime.day,
      9,
      0,
    );
    print(tz.local.name);
    print(tz.TZDateTime.now(tz.local).hour.toString());
    if (scheduledTime.isBefore(currentTime)) {
      scheduledTime = scheduledTime.add(Duration(minutes: 23));
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
      4,
      "Good morning ",
      "Dont forget to check your todo list !",
      scheduledTime,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      // payload: "payload data",
    );
  }
}
*/