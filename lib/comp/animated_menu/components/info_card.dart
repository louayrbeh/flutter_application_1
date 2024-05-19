// ignore_for_file: prefer_const_constructors, use_super_parameters, unused_local_variable, sized_box_for_whitespace, non_constant_identifier_names, unnecessary_brace_in_string_interps, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.white24,
          child: Icon(
            CupertinoIcons.person,
            color: Colors.white,
          ),
        ),
        title: Text(
          'UserName',
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          name,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: CircleAvatar(
          backgroundColor: Colors.white24,
          child: IconButton(
            onPressed: () {
              customEditProfil(
                context,
                onClosed: (_) {},
              );
            },
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

String? selectedIconPath;

Future<Object?> customEditProfil(
  BuildContext context, {
  required ValueChanged onClosed,
}) {
  TextEditingController editname = TextEditingController();
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: "Add Phone Number",
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
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.94),
            borderRadius: const BorderRadius.all(Radius.circular(40)),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    const Text(
                      " Edit Profil",
                      style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: editname,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text("choisir un avatar"),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            child: Container(
                                width: 55,
                                height: 55,
                                child: Image.asset('assets/avaters/6.png')),
                            onTap: () {
                              selectedIconPath = 'assets/avaters/6.png';
                            },
                          ),
                          GestureDetector(
                            child: Container(
                                width: 55,
                                height: 55,
                                child: Image.asset('assets/avaters/7.png')),
                            onTap: () {
                              selectedIconPath = 'assets/avaters/7.png';
                            },
                          ),
                          GestureDetector(
                            child: Container(
                                width: 55,
                                height: 55,
                                child: Image.asset('assets/avaters/8.png')),
                            onTap: () {
                              selectedIconPath = 'assets/avaters/8.png';
                            },
                          ),
                          GestureDetector(
                            child: Container(
                                width: 55,
                                height: 55,
                                child: Image.asset('assets/avaters/9.png')),
                            onTap: () {
                              selectedIconPath = 'assets/avaters/9.png';
                            },
                          ),
                          GestureDetector(
                            child: Container(
                                width: 55,
                                height: 55,
                                child: Image.asset('assets/avaters/10.png')),
                            onTap: () {
                              selectedIconPath = 'assets/avaters/10.png';
                            },
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            child: Container(
                                width: 55,
                                height: 55,
                                child: Image.asset('assets/avaters/1.png')),
                            onTap: () {
                              selectedIconPath = 'assets/avaters/1.png';
                            },
                          ),
                          GestureDetector(
                            child: Container(
                                width: 55,
                                height: 55,
                                child: Image.asset('assets/avaters/2.png')),
                            onTap: () {
                              selectedIconPath = 'assets/avaters/2.png';
                            },
                          ),
                          GestureDetector(
                            child: Container(
                                width: 55,
                                height: 55,
                                child: Image.asset('assets/avaters/3.png')),
                            onTap: () {
                              selectedIconPath = 'assets/avaters/3.png';
                            },
                          ),
                          GestureDetector(
                            child: Container(
                                width: 55,
                                height: 55,
                                child: Image.asset('assets/avaters/4.png')),
                            onTap: () {
                              selectedIconPath = 'assets/avaters/4.png';
                            },
                          ),
                          GestureDetector(
                            child: Container(
                                width: 55,
                                height: 55,
                                child: Image.asset('assets/avaters/5.png')),
                            onTap: () {
                              selectedIconPath = 'assets/avaters/5.png';
                            },
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            child: Container(
                                width: 55,
                                height: 55,
                                child: Image.asset('assets/avaters/11.png')),
                            onTap: () {
                              selectedIconPath = 'assets/avaters/11.png';
                            },
                          ),
                          GestureDetector(
                            child: Container(
                                width: 55,
                                height: 55,
                                child: Image.asset('assets/avaters/12.png')),
                            onTap: () {
                              selectedIconPath = 'assets/avaters/12.png';
                            },
                          ),
                          GestureDetector(
                            child: Container(
                                width: 55,
                                height: 55,
                                child: Image.asset('assets/avaters/13.png')),
                            onTap: () {
                              selectedIconPath = 'assets/avaters/13.png';
                            },
                          ),
                          Container(
                            width: 55,
                            height: 55,
                            child: GestureDetector(
                              child: Container(
                                width: 45,
                                height: 45,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                      'assets/avaters/Avatar Default.jpg'),
                                ),
                              ),
                              onTap: () {
                                selectedIconPath =
                                    'assets/avaters/Avatar Default.jpg';
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF80A4FF),
                          ),
                          onPressed: () {
                            //   EditUserDocument(editname, selectedIconPath);
                          },
                          child: Text(
                            "Edit",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
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
      ),
    ),
  ).then(onClosed);
}
/*
EditUserDocument(editname, selectedIconPath) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  // Vérifier si un document existe déjà pour cet utilisateur
  DocumentSnapshot userDoc = await users.doc(userId).get();

  // Si aucun document n'existe, ajouter un nouveau document pour cet utilisateur
  if (!userDoc.exists) {
    await users.doc(userId).update({
      'name': editname,
      'icon': selectedIconPath,
    });
    print('modification ajouté avec succès pour ${userId}');
  } else {
    print('ereeeur modification.');
  }
}*/
