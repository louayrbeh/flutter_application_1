// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorMap extends StatefulWidget {
  const DoctorMap({
    Key? key,
  }) : super(key: key);

  @override
  State<DoctorMap> createState() => _DoctorMapState();
}

class _DoctorMapState extends State<DoctorMap> with WidgetsBindingObserver {
  List<Marker> markers = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _userUid;

  @override
  void initState() {
    super.initState();
    _userUid = FirebaseAuth.instance.currentUser!.uid;

    getMarkersFromFirestore();
    // Observer pour détecter les changements d'état de l'application
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    // Supprimer l'observateur lorsque le widget est supprimé
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      getMarkersFromFirestore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0),
        height: MediaQuery.of(context).size.height * 0.60,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(35.77550605971146, 10.826162172109083),
            zoom: 14.0,
          ),
          markers: markers.toSet(),
          onTap: (LatLng latLng) async {
            // Ajouter un nouveau marqueur lorsque vous cliquez sur la carte
            await addMarkerToFirestore(latLng);
            markers.add(Marker(
              markerId: MarkerId("${latLng.latitude}"),
              position: LatLng(latLng.latitude, latLng.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure),
              onTap: () {
                // Supprimer le marqueur lorsqu'il est cliqué
                removeMarker(latLng);
              },
            ));
            setState(() {});
          },
        ),
      ),
    );
  }

  // Fonction pour récupérer les marqueurs depuis Firestore
  void getMarkersFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(_userUid)
          .collection('DoctorMarkers')
          .get();
      List<Marker> newMarkers = [];
      querySnapshot.docs.forEach((doc) {
        double latitude = doc['latitude'];
        double longitude = doc['longitude'];
        newMarkers.add(Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(latitude, longitude),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          onTap: () {
            removeMarker(LatLng(latitude, longitude));
          },
        ));
      });
      setState(() {
        markers = newMarkers;
      });
    } catch (e) {
      print('Error getting markers from Firestore: $e');
    }
  }

  // Fonction pour supprimer le marqueur de la carte et de Firestore
  void removeMarker(LatLng position) async {
    markers.removeWhere((marker) =>
        marker.position.latitude == position.latitude &&
        marker.position.longitude == position.longitude);
    setState(() {});

    // Supprimer le document correspondant dans Firestore
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(_userUid)
          .collection('DoctorMarkers')
          .where('latitude', isEqualTo: position.latitude)
          .where('longitude', isEqualTo: position.longitude)
          .get();
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    } catch (e) {
      print('Error removing marker from Firestore: $e');
    }
  }

  // Fonction pour ajouter un marqueur à Firestore
  Future<void> addMarkerToFirestore(LatLng position) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userUid)
          .collection('DoctorMarkers')
          .add({
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
    } catch (e) {
      print('Error adding marker to Firestore: $e');
    }
  }
}
