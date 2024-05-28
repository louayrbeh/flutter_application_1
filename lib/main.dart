// ignore_for_file: avoid_print, prefer_const_constructors, use_key_in_widget_constructors

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_application_1/comp/animated_menu/entry_point.dart';
import 'package:flutter_application_1/firebase_options.dart';

import 'package:flutter_application_1/home/COMMUNITY/community.dart';
import 'package:flutter_application_1/home/CONTACT/contact.dart';

import 'package:flutter_application_1/home/HOME/home.dart';
import 'package:flutter_application_1/home/TODO/todo.dart';

import 'package:flutter_application_1/home/TRACKED/tracked.dart';
import 'package:flutter_application_1/notification/local_notification_service.dart';
import 'package:flutter_application_1/notification/test.dart';
import 'package:flutter_application_1/notification/work_manager_service.dart';

import 'package:flutter_application_1/signin/screens/onboding/onboding_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Future.wait([
    LocalNotificationService.init(),
    WorkManagerService().init(),
  ]);
  //await LocalNotificationService.init();
  // await WorkManagerService().init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        addUserDocument(user);
        addAppToken(user);
      }
    });
  }

  // Fonction pour ajouter un document utilisateur à Firestore
  Future<void> addUserDocument(User user) async {
    // Référence à la collection "users" dans Firestore
   if ( user != null) {
     CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Vérifier si un document existe déjà pour cet utilisateur
    DocumentSnapshot userDoc = await users.doc(user.uid).get();

    // Si aucun document n'existe, ajouter un nouveau document pour cet utilisateur
    if (!userDoc.exists) {
      await users.doc(user.uid).set({
        'email': user.email,
        'name': '',
        'icon': 'assets/avaters/Avatar Default.jpg',
      });
      print('Document utilisateur ajouté avec succès pour ${user.uid}');
    } else {
      print('Le document utilisateur pour ${user.uid} existe déjà.');
    }
  }
   }
   

  // Fonction pour ajouter un document utilisateur à Firestore
  Future<void> addAppToken(User user) async {
    if ( user != null) {
      CollectionReference TokenCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('token');

    String? mytoken = await FirebaseMessaging.instance.getToken();
    print("000000000000000000000000000000000000000000");
    print(mytoken);

    await TokenCollection.add({
      "token": mytoken,
    });
  }
    }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 248, 247, 247),
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
          'help': (context) => Test(),
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
