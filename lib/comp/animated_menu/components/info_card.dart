import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

Stream<DocumentSnapshot> getUserDataStream() {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  return users.doc(userId).snapshots();
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: getUserDataStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text('No user data found');
        } else {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final userName = userData['name'] ?? 'UserName';
          final userIcon =
              userData['icon'] ?? 'assets/avaters/Avatar Default.png';
          final userEmail = userData['email'] ?? 'email@email.com';

          return Padding(
            padding: const EdgeInsets.only(top: 50),
            child: ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white24,
                    width: 1,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    userIcon,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                userName,
                style: const TextStyle(color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                userEmail, // You can update this to show something dynamic if needed
                style: const TextStyle(color: Colors.white), maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 30),
                child: CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: IconButton(
                    iconSize: 30,
                    onPressed: () {
                      customEditProfil(
                        context,
                        onClosed: (_) {},
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
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
    barrierLabel: "Edit profil",
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
          height: MediaQuery.of(context).size.height * 0.50,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.94),
            borderRadius: const BorderRadius.all(
              Radius.circular(40),
            ),
            border: Border.all(
              color: Colors.black, // Couleur de la bordure
              width: 3, // Épaisseur de la bordure en pixels
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Text(
                          " Edit Profil",
                          style: TextStyle(fontSize: 28, fontFamily: "Poppins"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 105),
                      child: Text(
                        "Edit your user name :",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: editname,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 33),
                      child: Text(
                        "Choose avatar for your profil :",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 120,
                      child: ImageGridScreen(
                        onIconSelected: (path) {
                          selectedIconPath = path;
                        },
                      ),
                    ),
                    SizedBox(height: 8),
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
                          onPressed: () async {
                            if (editname.text.isNotEmpty &&
                                selectedIconPath != null) {
                              await EditUserDocument(
                                  editname.text, selectedIconPath);
                              Navigator.pop(context);
                              onClosed(null);
                            } else {
                              print('Name or icon not selected');
                            }
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

class ImageGridScreen extends StatefulWidget {
  final ValueChanged<String> onIconSelected;

  ImageGridScreen({required this.onIconSelected});

  @override
  _ImageGridScreenState createState() => _ImageGridScreenState();
}

class _ImageGridScreenState extends State<ImageGridScreen> {
  List<String> imagePaths = [
    'assets/avaters/1.png',
    'assets/avaters/2.png',
    'assets/avaters/3.png',
    'assets/avaters/4.png',
    'assets/avaters/5.png',
    'assets/avaters/6.png',
    'assets/avaters/7.png',
    'assets/avaters/8.png',
    'assets/avaters/9.png',
    'assets/avaters/10.png',
  ];

  String selectedIconPath = "";

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 3.0,
        crossAxisSpacing: 3.0,
      ),
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIconPath = imagePaths[index];
            });
            widget.onIconSelected(selectedIconPath);
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selectedIconPath == imagePaths[index]
                    ? Color(0xFF80A4FF)
                    : Colors.transparent,
                width: 3,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                imagePaths[index],
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<void> EditUserDocument(String name, String? selectedIconPath) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  if (selectedIconPath == null) {
    return;
  }

  try {
    await users.doc(userId).set({
      'name': name,
      'icon': selectedIconPath,
    }, SetOptions(merge: true));
    print('Modification added successfully for $userId');
  } catch (e) {
    print('Error updating document: $e');
  }
}
