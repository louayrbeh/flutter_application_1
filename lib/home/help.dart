// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:flutter_application_1/comp/menu_button.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(1000, 16, 76, 100),
        title: Text(
          "Help",
          style: (TextStyle(
            color: Color(0xFFF6F3E7),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          )),
        ),
        centerTitle: true,
        actions: [],
        leading: MenuButton(),
      ),
    );
  }
}
