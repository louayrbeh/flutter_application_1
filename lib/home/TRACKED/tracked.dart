import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/TRACKED/premier_maps.dart';

class Tracked extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tracked",
          style: TextStyle(fontFamily: "Poppins"),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: PremierMaps(),
    );
  }
}
