// ignore_for_file: must_call_super, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/auth/homepage.dart';
import 'package:flutter_application_1/auth/signup.dart';
import 'package:flutter_application_1/auth/signin.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/geo/geolocalisation.dart';
import 'package:flutter_application_1/home/aboutus.dart';
import 'package:flutter_application_1/home/help.dart';
import 'package:flutter_application_1/home/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('**************************User is currently signed out!');
      } else {
        print('**************************User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Montserrat"),
      home: Geolocalisation(),
      /*(FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? const Home()
          : const HomePage(),*/
      routes: {
        'homepage': (context) => const HomePage(),
        'signin': (context) => const SignIn(),
        'signup': (context) => const SignUP(),
        'home': (context) => const Home(),
        'help': (context) => const Help(),
        'aboutus': (context) => const AboutUS(),
        'geolocalisation': (context) => const Geolocalisation(),
      },
    );
  }
}
