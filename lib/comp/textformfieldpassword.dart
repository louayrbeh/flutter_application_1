// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';

class CustomTextFormFieldPassword extends StatefulWidget {
  const CustomTextFormFieldPassword({super.key});

  @override
  State<CustomTextFormFieldPassword> createState() =>
      _CustomTextFormFieldPasswordState();
}

class _CustomTextFormFieldPasswordState
    extends State<CustomTextFormFieldPassword> {
  bool passToggle = true;
  String Passlabel = "";
  final Passcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: Passcontroller,
      decoration: InputDecoration(
        suffixIcon: InkWell(
          onTap: () {
            setState(() {
              passToggle = !passToggle;
            });
          },
          child: Icon(passToggle ? Icons.visibility : Icons.visibility_off),
        ),
        label: Text(
          Passlabel,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color.fromARGB(1000, 13, 29, 37),
          ),
        ),
      ),
    );
  }
}
