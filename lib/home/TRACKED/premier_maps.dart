// ignore_for_file: avoid_function_literals_in_foreach_calls, prefer_const_constructors

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:flutter_application_1/home/TRACKED/custom_cercle_add.dart';
import 'package:flutter_application_1/home/TRACKED/custon_doctor_map.dart';

class PremierMaps extends StatefulWidget {
  const PremierMaps({Key? key}) : super(key: key);

  @override
  State<PremierMaps> createState() => _PremierMapsState();
}

class _PremierMapsState extends State<PremierMaps> {
  bool isAddDoctorDialogShown = false;
  bool isAddCircleZoneDialogShown = false;

  double circleRadius = 100.0;
  List<Circle> circles = [];
  List<Marker> markers = [];

  static final CameraPosition bracletCameraPosition = CameraPosition(
    target: LatLng(35.77550605971146, 10.826162172109083),
    zoom: 14.4746,
  );

  final locationController = Location();
  LatLng? currentPosition;
  StreamSubscription<Position>? positionStream;

  CameraPosition? userCmeraPosition;
  Map<PolylineId, Polyline> polylines = {};
  MapType _currentMapType = MapType.normal;

  FirebaseFirestore firestoreCircles = FirebaseFirestore.instance;
  FirebaseFirestore firestoreMarkers = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await fetchLocationUpdates();
      initializeMap();
      _listenToCirclesChanges(); // Écouter les changements dans la collection circles Firestore
      _listenToMarkerChanges(); // Écouter les changements dans la collection doctormarker Firestore
    });
  }

  Future<void> initializeMap() async {
    final coordinates = await fetchPolylinePoints();
    generatePolyLineFromPoints(coordinates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: GoogleMap(
                    mapType: _currentMapType,
                    myLocationEnabled: true,
                    scrollGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                    rotateGesturesEnabled: true,
                    initialCameraPosition: bracletCameraPosition,
                    circles: Set<Circle>.of(circles),
                    markers: Set<Marker>.of(markers),
                  ),
                ),
                Positioned(
                  top: 50.0,
                  right: 0,
                  child: IconButton(
                    onPressed: () async {
                      final coordinates = await fetchPolylinePoints();
                      if (coordinates.isNotEmpty) {
                        generatePolyLineFromPoints(coordinates);
                      }
                    },
                    icon: Icon(
                      Icons.assistant_direction_outlined,
                      size: 45,
                    ), // Icône que vous souhaitez afficher
                  ),
                ),
                Positioned(
                  top: 95,
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _currentMapType = _currentMapType == MapType.normal
                            ? MapType.satellite
                            : MapType.normal;
                      });
                    },
                    icon: Icon(
                      _currentMapType == MapType.normal
                          ? Icons.map_outlined
                          : Icons.satellite_outlined,
                      size: 45,
                    ), // Icône pour changer le type de carte
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "You can add a circle(s) zone(s) in the map and we will send a notification when the braclet's user got away from the zone(s)",
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.black),
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
                    customAddCircle(
                      context,
                      onCLosed: (_) {
                        setState(() {
                          isAddCircleZoneDialogShown = false;
                        });
                      },
                    );
                  },
                  child: Text(
                    "Add Circle(s) Zone(s)",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "You can add a marker(s) for doctor(s) location(s)",
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(
            height: 8,
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
                    customAddDoctor(
                      context,
                      onCLosed: (_) {
                        setState(() {
                          isAddDoctorDialogShown = false;
                        });
                      },
                    );
                  },
                  child: Text(
                    "Add Doctor(s)",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  )),
            ),
          ),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  Future<void> fetchLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.longitude != null &&
          currentLocation.latitude != null) {
        setState(() {
          currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          // Initialise la position de la caméra du docteur après avoir reçu la première mise à jour de la position
          userCmeraPosition = CameraPosition(
            target: currentPosition!,
            zoom: 14.0, // Zoom par défaut
          );
        });
        print("Position actuelle : $currentPosition");
      }
    });
  }

  Future<List<LatLng>> fetchPolylinePoints() async {
    if (currentPosition == null) {
      return [];
    }

    final polylinePoints = PolylinePoints();

    final result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAOVYRIgupAurZup5y1PRh8Ismb1A3lLao",
      PointLatLng(currentPosition!.latitude, currentPosition!.longitude),
      //coordonne de braclet
      PointLatLng(35.77550605971146, 10.826162172109083),
    );

    if (result.points.isNotEmpty) {
      return result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    } else {
      debugPrint(result.errorMessage);
      return [];
    }
  }

  Future<void> generatePolyLineFromPoints(
      List<LatLng> polylineCoordinates) async {
    const id = PolylineId("polyline");
    final polyline = Polyline(
      polylineId: id,
      color: Colors.blueAccent,
      points: polylineCoordinates,
      width: 5,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  Future<void> _listenToCirclesChanges() async {
    firestoreCircles
        .collection('users')
        .doc(user!.uid)
        .collection('circles')
        .snapshots()
        .listen((snapshot) {
      List<Circle> updatedCircles = [];
      snapshot.docs.forEach((doc) {
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          LatLng center = LatLng(
            data['center']['latitude'] as double,
            data['center']['longitude'] as double,
          );
          double radius = data['radius'] as double;
          Circle circle = Circle(
            circleId: CircleId(doc.id),
            center: center,
            radius: radius,
            strokeWidth: 2,
            strokeColor: Colors.blue,
            fillColor: Colors.blue.withOpacity(0.2),
          );
          updatedCircles.add(circle);
        }
      });

      setState(() {
        circles = updatedCircles;
      });
    });
  }

  Future<void> _listenToMarkerChanges() async {
    firestoreMarkers
        .collection('users')
        .doc(user!.uid)
        .collection('DoctorMarkers')
        .snapshots()
        .listen((snapshot) {
      List<Marker> updatedMarkers = [];
      snapshot.docs.forEach((doc) {
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          LatLng position = LatLng(
            data['latitude'] as double,
            data['longitude'] as double,
          );
          Marker marker = Marker(
            markerId: MarkerId(doc.id),
            position: position,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
          );
          updatedMarkers.add(marker);
        }
      });

      setState(() {
        markers = updatedMarkers;
      });
    });
  }
}
