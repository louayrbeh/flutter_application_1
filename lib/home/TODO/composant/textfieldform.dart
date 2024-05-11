// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';

class Textfieldform extends StatelessWidget {
  const Textfieldform({
    Key? key, // Ajoutez Key? key ici
    required this.maxLine,
    required this.hintText,
    required this.txtController,
  }) : super(key: key);

  final String hintText;
  final int maxLine;
  final TextEditingController txtController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: txtController,
        decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: Colors.grey.shade200,
            hintText: hintText),
        maxLines: maxLine,
      ),
    );
  }
}
