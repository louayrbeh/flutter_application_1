// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, camel_case_types, avoid_print

import 'package:flutter/material.dart';

import 'package:flutter_application_1/comp/menu_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(1000, 16, 76, 100),
          title: Text(
            "Home",
            style: (TextStyle(
              color: Color(0xFFF6F3E7),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            )),
          ),
          centerTitle: true,
          actions: [],
          leading: MenuButton()),
    );
  }
}
