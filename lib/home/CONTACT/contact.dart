// ignore_for_file: prefer_const_constructors, deprecated_member_use, use_super_parameters, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  List<Map<String, dynamic>> _contacts = [];
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  late CollectionReference contactCollection;

  @override
  void initState() {
    super.initState();
    contactCollection = FirebaseFirestore.instance.collection('contacts');
    _fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "contact",
          style: TextStyle(fontFamily: "Poppins"),
        ),
        centerTitle: true,
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
                  "Add Phone Number",
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
                          Icon(Icons.person_2_rounded),
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
                            icon: Icon(Icons.phone),
                            onPressed: () =>
                                _launchUrl('tel:${contact['phone']}'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1),
                            child: VerticalDivider(
                              thickness: 2,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
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

  Future<Object?> customAddPhoneNumber(
    BuildContext context, {
    required ValueChanged onClosed,
  }) {
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
            height: MediaQuery.of(context).size.height * 0.50,
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
                        " Add Phone Number",
                        style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                      ),
                      TextField(
                        controller: _phoneNumberController,
                        decoration: InputDecoration(
                          labelText: 'Phone number',
                        ),
                        keyboardType: TextInputType.phone,
                      ),
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
                              _addContact();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Add Phone Number",
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
    await contactCollection.add({
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
      await contactCollection.doc(docId).delete();
      _fetchContacts();
    }
  }

  void _fetchContacts() async {
    final snapshots = await contactCollection.get();
    setState(() {
      _contacts = snapshots.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }
}
