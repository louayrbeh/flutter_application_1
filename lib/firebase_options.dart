// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAALshqbz45jufUWS3dSD6Ado0ewTQvIrY',
    appId: '1:60902852062:web:b38b8475f84b5cb101094f',
    messagingSenderId: '60902852062',
    projectId: 'pfe01-2d02d',
    authDomain: 'pfe01-2d02d.firebaseapp.com',
    storageBucket: 'pfe01-2d02d.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAKkgu10b-YoSlicR8PrttQJwtOe7Vdib8',
    appId: '1:60902852062:android:1a7d5991a6e6b53d01094f',
    messagingSenderId: '60902852062',
    projectId: 'pfe01-2d02d',
    storageBucket: 'pfe01-2d02d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBp3z_fY3jzbryU_2dmNnA8H9Kpe-i_N30',
    appId: '1:60902852062:ios:3f00dc2a21a0cece01094f',
    messagingSenderId: '60902852062',
    projectId: 'pfe01-2d02d',
    storageBucket: 'pfe01-2d02d.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBp3z_fY3jzbryU_2dmNnA8H9Kpe-i_N30',
    appId: '1:60902852062:ios:7d8a3c59cd4564e701094f',
    messagingSenderId: '60902852062',
    projectId: 'pfe01-2d02d',
    storageBucket: 'pfe01-2d02d.appspot.com',
    iosBundleId: 'com.example.flutterApplication1.RunnerTests',
  );
}
