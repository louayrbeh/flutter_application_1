// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print, prefer_const_constructors, use_super_parameters, library_private_types_in_public_api

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importer FirebaseAuth pour obtenir l'UID de l'utilisateur actuel

class AddCircles extends StatefulWidget {
  const AddCircles({Key? key}) : super(key: key);

  @override
  _AddCirclesState createState() => _AddCirclesState();
}

class _AddCirclesState extends State<AddCircles> {
  double circleRadius = 100.0;
  List<Circle> circles = [];

  double calculateDistance(LatLng point1, LatLng point2) {
    const int earthRadius = 6371000; // Average Earth radius in meters

    double lat1 = point1.latitude * pi / 180.0;
    double lon1 = point1.longitude * pi / 180.0;
    double lat2 = point2.latitude * pi / 180.0;
    double lon2 = point2.longitude * pi / 180.0;

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

  static final CameraPosition bracletCameraPosition = CameraPosition(
    target: LatLng(35.77550605971146, 10.826162172109083),
    zoom: 14.4746,
  );

  final locationController = Location();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0),
        height: MediaQuery.of(context).size.height * 0.63,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                myLocationEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                rotateGesturesEnabled: true,
                initialCameraPosition: bracletCameraPosition,
                circles: Set<Circle>.of(circles),
                onTap: (LatLng latLng) {
                  setState(() {
                    bool isCircleExists = false;
                    for (Circle circle in circles) {
                      if (calculateDistance(circle.center, latLng) <=
                          circle.radius) {
                        isCircleExists = true;
                        circles.remove(circle);
                        removeCircleFromFirestore(circle.circleId.toString());
                        break;
                      }
                    }
                    if (!isCircleExists) {
                      Circle newCircle = Circle(
                        circleId: CircleId(latLng.toString()),
                        center: latLng,
                        radius: circleRadius,
                        strokeWidth: 2,
                        strokeColor: Colors.blue,
                        fillColor: Colors.blue.withOpacity(0.2),
                      );
                      circles.add(newCircle);
                      addCircleToFirestore(newCircle);
                    }
                  });
                },
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "Click on the map to add circle(s) zone(s). You can also change the radius of circle(s)",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  height: 40,
                  child: Center(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter raduis (metre) ",
                      ),
                      onChanged: (value) {
                        setState(() {
                          circleRadius = double.tryParse(value) ?? 500.0;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.30,
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
                        setState(() {
                          circles.forEach((circle) {
                            circles[circles.indexOf(circle)] =
                                circle.copyWith(radiusParam: circleRadius);
                          });
                          updateAllCircleRadiusInFirestore(circleRadius);
                        });
                      },
                      child: Text(
                        "Apply",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour ajouter un cercle à Firestore
  Future<void> addCircleToFirestore(Circle circle) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Reference to the user's document in Firestore
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Reference to the circles subcollection within the user's document
        CollectionReference circlesRef = userDocRef.collection('circles');

        // Add the circle to the circles subcollection
        await circlesRef.add({
          'circleId': circle.circleId.toString(),
          'center': {
            'latitude': circle.center.latitude,
            'longitude': circle.center.longitude,
          },
          'radius': circle.radius,
        });

        print('Circle added to Firestore successfully');
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Error adding circle to Firestore: $e');
    }
  }

  // Fonction pour supprimer un cercle de Firestore
  Future<void> removeCircleFromFirestore(String circleId) async {
    try {
      CollectionReference circlesCollection =
          FirebaseFirestore.instance.collection('circles');

      // L'ID du cercle est stocké sous la forme d'une String au format 'circleId(foo)'.
      // Nous devons extraire seulement 'foo' pour obtenir l'ID du document Firestore.
      String documentId =
          circleId.substring(circleId.indexOf('(') + 1, circleId.indexOf(')'));

      await circlesCollection.doc(documentId).delete();

      print('Circle removed from Firestore successfully');
    } catch (e) {
      print('Error removing circle from Firestore: $e');
    }
  }

  // Fonction pour mettre à jour le rayon de tous les cercles dans Firestore
  Future<void> updateAllCircleRadiusInFirestore(double newRadius) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Reference to the user's document in Firestore
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Reference to the circles subcollection within the user's document
        CollectionReference circlesRef = userDocRef.collection('circles');

        // Update the radius of all circles in the circles subcollection
        QuerySnapshot querySnapshot = await circlesRef.get();

        querySnapshot.docs.forEach((doc) async {
          await doc.reference.update({'radius': newRadius});
        });

        print('Radius of all circles updated in Firestore successfully');
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Error updating circle radius in Firestore: $e');
    }
  }

  // Fonction pour récupérer la liste de cercles à partir de Firestore
  Future<List<Circle>> getCirclesFromFirestore() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Reference to the user's document in Firestore
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Reference to the circles subcollection within the user's document
        CollectionReference circlesRef = userDocRef.collection('circles');

        QuerySnapshot querySnapshot = await circlesRef.get();

        List<Circle> circles = [];

        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          LatLng center =
              LatLng(data['center']['latitude'], data['center']['longitude']);
          double radius = data['radius'] as double;
          Circle circle = Circle(
            circleId: CircleId(doc.id),
            center: center,
            radius: radius,
            strokeWidth: 2,
            strokeColor: Colors.blue,
            fillColor: Colors.blue.withOpacity(0.2),
          );
          circles.add(circle);
        });

        return circles;
      } else {
        print('User not logged in');
        return [];
      }
    } catch (e) {
      print('Error getting circles from Firestore: $e');
      return [];
    }
  }

  // Fonction pour charger les cercles depuis Firestore et les définir comme valeur de l'attribut 'circles' du widget GoogleMap
  Future<void> loadCirclesFromFirestore() async {
    List<Circle> circlesFromFirestore = await getCirclesFromFirestore();
    setState(() {
      circles = circlesFromFirestore;
    });
  }

  @override
  void initState() {
    super.initState();
    loadCirclesFromFirestore();
  }
}
