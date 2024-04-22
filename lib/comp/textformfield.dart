// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController mycontroller;
  const CustomTextFormField({
    super.key, // Ajout de la clé key manquante
    required this.label,
    required this.mycontroller,
  });

  // Correction de l'appel au constructeur super
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: mycontroller,
      style: TextStyle(
        color:
            Color.fromARGB(255, 37, 13, 13), // Couleur personnalisée du texte
        fontSize: 16,
        fontWeight: FontWeight.w900,
      ),
      cursorColor: Color(0xFF0D1D25), // Couleur du curseur
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Color(0xFF0D1D25), // Couleur du texte du label
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(
                1000, 16, 76, 100), // Couleur de la ligne en dessous du texte
            width: 1.0,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(1000, 16, 76,
                100), // Couleur de la ligne lorsque le champ est activé
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
