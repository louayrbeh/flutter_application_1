// ignore_for_file: equal_keys_in_map, prefer_const_constructors, avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_application_1/comp/animated_menu/entry_point.dart';
import 'package:flutter_application_1/firebase_options.dart';

import 'package:flutter_application_1/home/COMMUNITY/community.dart';
import 'package:flutter_application_1/home/CONTACT/contact.dart';
import 'package:flutter_application_1/home/HELP/help.dart';

import 'package:flutter_application_1/home/HOME/home.dart';
import 'package:flutter_application_1/home/TODO/todo.dart';
import 'package:flutter_application_1/home/TRACKED/tracked.dart';

import 'package:flutter_application_1/signin/screens/onboding/onboding_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
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
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFEEF1F8),
          primarySwatch: Colors.blue,
          fontFamily: "Intel",
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            errorStyle: TextStyle(height: 0),
            border: defaultInputBorder,
            enabledBorder: defaultInputBorder,
            focusedBorder: defaultInputBorder,
            errorBorder: defaultInputBorder,
          ),
        ),
        home: (FirebaseAuth.instance.currentUser != null &&
                FirebaseAuth.instance.currentUser!.emailVerified)
            ? EntryPoint(
                email: '',
                password: '',
              )
            : OnboardingScreen(),
        routes: {
          'onboding_screen': (context) => const OnboardingScreen(),
          'entry_point': (context) => EntryPoint(
                email: '',
                password: '',
              ),
          'home': (context) => const Home(),
          'tracked': (context) => Tracked(),
          'todo': (context) => Todo(),
          'contact': (context) => Contact(),
          'community': (context) => const Community(),
          'help': (context) => const Help(),
          'todo': (context) => Todo(),
        },
      ),
    );
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);
