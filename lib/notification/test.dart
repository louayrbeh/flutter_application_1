// ignore_for_file: avoid_print, prefer_const_constructors, avoid_single_cascade_in_expression_statements

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("========================================");
        print(message.notification!.title);
        print(message.notification!.body);
        print("========================================");

        AwesomeDialog(
            context: context,
            title: message.notification!.title,
            body: Text("${message.notification!.body}"),
            dialogType: DialogType.error)
          ..show();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("notification"),
        ),
        body: MaterialButton(
          onPressed: () async {
            await sendMessage("hi", "how are you");
          },
          child: Text('enzelllllllllllll'),
        ));
  }
}

sendMessage(title, message) async {
  var headersList = {
    'Accept': '*/*',
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAADi4Xxd4:APA91bH0J_DcRHPml1s4UuUUTgJQ39DifY-dONW5IqnSfAU67fdScDDVlxI7a-djkEtV4b5aJ3R2gJAhDNGqINPdCQL8iOSM9NX4eGEYVmqPHiHzRPL5nzr2UiKC_O4nd5zG6_vkisbQ'
  };
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  var body = {
    "to":
        "fEpPKrJzSSSyTiBAxDJIkH:APA91bFxc6Iz1mubXNedbdJ7o-eGmDoOg8KxvXX-wQDkyC_aWEYX9B4zgTGvQbm6hjU_5iy3UDcM292WfQ7URu1-WK1ySg1xnHt903syUCZq4lmcyC6Nbr6ywdBj6U3F6rgVwkW6tnZt",
    "notification": {"title": title, "body": message}
  };

  var req = http.Request('POST', url);
  req.headers.addAll(headersList);
  req.body = json.encode(body);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    print(resBody);
  } else {
    print(res.reasonPhrase);
  }
  print("00000000000000000000000000000000000000000000000");
}
