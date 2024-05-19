import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final databaseReference = FirebaseDatabase.instance.ref();
  Map<dynamic, dynamic> gpsData = {};

  @override
  void initState() {
    super.initState();
    readData();
  }

  void readData() {
    databaseReference.child("gpsData").onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        gpsData = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Realtime Database'),
      ),
      body: gpsData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Altitude Feet: ${gpsData["Altitude Feet"]}'),
                  Text('Date: ${gpsData["Date"]}'),
                  Text('Latitude: ${gpsData["Latitude"]}'),
                  Text('Longitude: ${gpsData["Longuitude"]}'),
                  Text('Time: ${gpsData["Time"]}'),
                ],
              ),
            ),
    );
  }
}
