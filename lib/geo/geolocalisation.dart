// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Geolocalisation extends StatefulWidget {
  const Geolocalisation({super.key});

  @override
  State<Geolocalisation> createState() => _GeolocalisationState();
}

class _GeolocalisationState extends State<Geolocalisation> {
  StreamSubscription<Position>? positionStream;
  getCurrentLocationApp() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (serviceEnabled == false) {
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('denied');
      }
    }

    if (permission == LocationPermission.whileInUse) {
      positionStream =
          Geolocator.getPositionStream().listen((Position? position) {
        print("###################################");
        print(position!.latitude);
        print(position!.longitude);
        print("###################################");
      });
    }
  }

  @override
  void initState() {
    getCurrentLocationApp();
    super.initState();
  }

  @override
  void dispose() {
    if (positionStream != null) {
      positionStream!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geo localisation"),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
    );
  }
}
