// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

class MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.menu,
        color: Color(0xFFF6F3E7),
      ),
      onSelected: (value) {
        switch (value) {
          case 'About Us':
            Navigator.of(context).pushReplacementNamed("aboutus");
            break;
          case 'Help':
            Navigator.of(context).pushReplacementNamed("help");
            break;
          case 'LogOut':
            GoogleSignIn googleSignIn = GoogleSignIn();
            googleSignIn.disconnect();
            FirebaseAuth.instance.signOut();

            Navigator.of(context)
                .pushNamedAndRemoveUntil("homepage", (route) => false);
            break;
        }
      },
      offset: Offset(0, 50), // Décalage de la position du menu
      // Hauteur de chaque élément du menu
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'About Us',
          child: Row(
            children: [
              Icon(Icons.info,
                  color: Color.fromARGB(1000, 16, 76, 100), size: 30),
              SizedBox(width: 10),
              Text('About Us ',
                  style: TextStyle(
                      color: Color.fromARGB(1000, 16, 76, 100), fontSize: 20)),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Help',
          child: Row(
            children: [
              Icon(Icons.help,
                  color: Color.fromARGB(1000, 16, 76, 100), size: 30),
              SizedBox(width: 10),
              Text('Help',
                  style: TextStyle(
                      color: Color.fromARGB(1000, 16, 76, 100), fontSize: 20)),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'LogOut',
          child: Row(
            children: [
              Icon(Icons.exit_to_app_rounded,
                  color: Color.fromARGB(1000, 16, 76, 100), size: 30),
              SizedBox(width: 10),
              Text('LogOut',
                  style: TextStyle(
                      color: Color.fromARGB(1000, 16, 76, 100), fontSize: 20)),
            ],
          ),
        ),
      ],
    );
  }
}
