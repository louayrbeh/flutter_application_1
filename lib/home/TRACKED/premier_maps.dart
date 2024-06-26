// ignore_for_file: avoid_function_literals_in_foreach_calls, prefer_const_constructors
import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/notification/local_notification_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:flutter_application_1/home/TRACKED/custom_cercle_add.dart';
import 'package:flutter_application_1/home/TRACKED/custon_doctor_map.dart';
import 'package:http/http.dart' as http;

class PremierMaps extends StatefulWidget {
  const PremierMaps({Key? key}) : super(key: key);

  @override
  State<PremierMaps> createState() => _PremierMapsState();
}

class _PremierMapsState extends State<PremierMaps> {
  bool isAddDoctorDialogShown = false;
  bool isAddCircleZoneDialogShown = false;
  final databaseReference = FirebaseDatabase.instance.ref();
  Map<dynamic, dynamic> gpsData = {};
  double latitude = 0.0;
  double longitude = 0.0;
  Set<Marker> bracletmarkers = {};

  double circleRadius = 100.0;
  List<Circle> circles = [];
  List<Marker> markers = [];
  GoogleMapController? _controller;

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
      _listenToCirclesChanges();
      _listenToMarkerChanges();
    });

    readData();
  }

  void readData() {
    databaseReference.child("gpsData").onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        gpsData = data;
        latitude = gpsData["Latitude"];
        longitude = gpsData["Longuitude"];
        updateBracletMarkers();
        _animateToLocation();

        LatLng braceletPosition = LatLng(latitude, longitude);
        if (isBraceletOutsideCircles(braceletPosition, circles)) {
          LocalNotificationService.showNotification(
              "Alerte", "Le bracelet est en dehors de la zone désignée !");
        }
      });
    });
  }

  bool isBraceletOutsideCircles(LatLng braceletPosition, List<Circle> circles) {
    for (Circle circle in circles) {
      final double distance = Geolocator.distanceBetween(
        braceletPosition.latitude,
        braceletPosition.longitude,
        circle.center.latitude,
        circle.center.longitude,
      );
      if (distance <= circle.radius) {
        return false;
      }
    }
    return true;
  }

  void checkBraceletLocation(
      LatLng braceletPosition, List<Circle> securityZones) {
    if (isBraceletOutsideCircles(braceletPosition, securityZones)) {
      sendNotificationToUser();
    }
  }

  void sendNotificationToUser() async {
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAADi4Xxd4:APA91bH0J_DcRHPml1s4UuUUTgJQ39DifY-dONW5IqnSfAU67fdScDDVlxI7a-djkEtV4b5aJ3R2gJAhDNGqINPdCQL8iOSM9NX4eGEYVmqPHiHzRPL5nzr2UiKC_O4nd5zG6_vkisbQ'
    };
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    var body = {
      "to":
          "dQHy8iY4SqqkC0i7MCQwam:APA91bE-B3eSGqXZn8OnFSaxYQp4dYBlzP_pnUZLqJCMF3enEfqu_9J6GFeIJSkUIa0xzyB6g9kXSy5TrPMsaI7p1gSoMWKiR-C5LTqHFhJl9XPHYOztCqyLUylK48Dlro857pZM8dGi",
      "notification": {
        "title": "Alert !!",
        "body": "The bracelet is outside the designated zone!",
      }
    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
    } else {
      print(res.reasonPhrase);
    }
  }

  void updateBracletMarkers() {
    setState(() {
      bracletmarkers = {
        Marker(
          markerId: MarkerId('location'),
          position: LatLng(latitude, longitude),
        ),
      };
      print("===============================================");
      print(latitude);
      print(longitude);
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
                    initialCameraPosition: CameraPosition(
                      target: LatLng(latitude, longitude),
                      zoom: 14,
                    ),
                    circles: Set<Circle>.of(circles),
                    markers: Set<Marker>.of([...markers, ...bracletmarkers]),
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                      _animateToLocation();
                    },
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
          _animateToLocation();
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
      // coordonne de utilisateur
      PointLatLng(currentPosition!.latitude, currentPosition!.longitude),
      // coordonne de braclet
      PointLatLng(latitude, longitude),
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

  void _animateToLocation() {
    if (_controller != null && latitude != 0.0 && longitude != 0.0) {
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 14,
          ),
        ),
      );
    }
  }
}
