// ignore_for_file: prefer_const_constructors, deprecated_member_use, use_super_parameters, prefer_final_fields, unused_local_variable, avoid_single_cascade_in_expression_statements, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';

class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  List<Map<String, dynamic>> _contacts = [];
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  late CollectionReference userCollection;

  @override
  void initState() {
    super.initState();
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    userCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('contacts');
    _fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Contact",
          style: TextStyle(fontFamily: "Poppins"),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
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
                  customAddPhoneNumber(
                    context,
                    onClosed: (_) {},
                  );
                },
                child: Text(
                  "Add Contact",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: VerticalDivider(
                              thickness: 2,
                              color: Colors.grey,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(contact['name'] ?? ''),
                              Text(contact['phone'] ?? ''),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.phone,
                              size: 25,
                            ),
                            onPressed: () =>
                                _launchUrl('tel:${contact['phone']}'),
                          ),
                          IconButton(
                              onPressed: () async {
                                List<Placemark> placemarks =
                                    await placemarkFromCoordinates(
                                        35.77550605971146, 10.826162172109083);
                                final String Message =
                                    "${placemarks[0].country} \n ${placemarks[0].administrativeArea} \n ${placemarks[0].locality} \n ${placemarks[0].street} \n ${placemarks[0].postalCode}    ";
                                _launchSms(contact['phone'], Message);
                              },
                              icon: Icon(
                                Icons.message,
                                size: 25,
                              )),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: VerticalDivider(
                              thickness: 2,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_rounded,
                              size: 30,
                            ),
                            onPressed: () {
                              _deleteContact(index);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Impossible de lancer $url';
    }
  }

  _launchSms(String phoneNumber, String message) async {
    String encodedMessage = Uri.encodeComponent(message);
    String encodedPhoneNumber = Uri.encodeComponent(phoneNumber);
    String url = 'sms:$encodedPhoneNumber?body=$encodedMessage';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Impossible d\'envoyer un message au numéro $phoneNumber';
    }
  }

  Future<Object?> customAddPhoneNumber(
    BuildContext context, {
    required ValueChanged onClosed,
  }) {
    return showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "Add Contact",
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
            height: MediaQuery.of(context).size.height * 0.40,
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
                            " AddContact",
                            style:
                                TextStyle(fontSize: 28, fontFamily: "Poppins"),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 125),
                        child: Text(
                          "Contact name :",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextField(
                        controller: _nameController,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 120),
                        child: Text(
                          "Phone number :",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.80,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF80A4FF),
                            ),
                            onPressed: () {
                              _addContact();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Add To Contacts",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
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

  void _addContact() async {
    await userCollection.add({
      'name': _nameController.text,
      'phone': _phoneNumberController.text,
    });
    _phoneNumberController.clear();
    _nameController.clear();
    _fetchContacts();
  }

  void _deleteContact(int index) async {
    String? docId = _contacts[index]['id'];
    if (docId != null) {
      await userCollection.doc(docId).delete();
      _fetchContacts();
    }
  }

  void _fetchContacts() async {
    final snapshots = await userCollection.get();
    setState(() {
      _contacts = snapshots.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }
}
