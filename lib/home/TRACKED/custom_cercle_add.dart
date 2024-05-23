// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/TRACKED/add_cercle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importer ProviderScope

Future<Object?> customAddCircle(
  BuildContext context, {
  required ValueChanged onCLosed,
}) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: "Circles Zones",
    context: context,
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: (_, animation, __, child) {
      Tween<Offset> tween;
      tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        ),
        child: child,
      );
    },
    pageBuilder: (context, _, __) => ProviderScope(
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.80,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.94),
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            border: Border.all(
              color: Colors.black, // Couleur de la bordure
              width: 3, // Épaisseur de la bordure en pixels
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    const Text(
                      " Circles Zones",
                      style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                    ),
                    AddCircles(),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Positioned(
                    left: 0,
                    right: 0,
                    bottom: -48,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ).then(onCLosed);
}
