import 'package:flutter/material.dart';

class ImageGridScreen extends StatefulWidget {
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
    'assets/avaters/11.png',
    'assets/avaters/12.png',
    'assets/avaters/13.png',
    'assets/avaters/2.png',
  ];

  String selectedIconPath = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Grid'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, // 5 images par ligne
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIconPath = imagePaths[index];
              });
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape
                    .circle, // Définit la forme du conteneur comme un cercle
                border: Border.all(
                  color: selectedIconPath == imagePaths[index]
                      ? Colors.blue
                      : Colors.transparent,
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  imagePaths[index],
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
