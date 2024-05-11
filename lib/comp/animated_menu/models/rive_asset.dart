import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rive/rive.dart';

class RiveAsset {
  final String artboard, stateMachineName, title, src, navigateTo;
  late SMIBool? input;
  final Function(BuildContext)? onPressedFunction;

  RiveAsset(this.src,
      {required this.artboard,
      required this.stateMachineName,
      required this.title,
      this.input,
      required this.navigateTo,
      this.onPressedFunction});

  set setInput(SMIBool status) {
    input = status;
  }
}

List<RiveAsset> sideMenus = [
  RiveAsset(
    "assets/RiveAssets/icons.riv",
    artboard: "HOME",
    stateMachineName: "HOME_interactivity",
    title: "Home",
    navigateTo: 'entry_point',
  ),
  RiveAsset(
    "assets/RiveAssets/icons.riv",
    artboard: "SEARCH",
    stateMachineName: "SEARCH_Interactivity",
    title: "Tracked",
    navigateTo: 'tracked',
  ),
  RiveAsset(
    "assets/RiveAssets/icons.riv",
    artboard: "TIMER",
    stateMachineName: "TIMER_Interactivity",
    title: "TO DO",
    navigateTo: 'todo',
  ),
  RiveAsset(
    "assets/RiveAssets/icons.riv",
    artboard: "USER",
    stateMachineName: "USER_Interactivity",
    title: "Emergency Contact",
    navigateTo: 'contact',
  ),
  RiveAsset(
    "assets/RiveAssets/icons.riv",
    artboard: "CHAT",
    stateMachineName: "CHAT_Interactivity",
    title: "Community",
    navigateTo: 'community',
  ),
];

List<RiveAsset> sideMenu2 = [
  RiveAsset(
    "assets/RiveAssets/icons.riv",
    artboard: "SETTINGS",
    stateMachineName: "SETTINGS_Interactivity",
    title: "Help",
    navigateTo: 'help',
  ),
  RiveAsset(
    "assets/RiveAssets/icons.riv",
    artboard: "SETTINGS",
    stateMachineName: "SETTINGS_Interactivity",
    title: "LogOut",
    navigateTo: 'onboding_screen',
    onPressedFunction: (BuildContext context) async {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (googleSignIn.currentUser != null) {
        await googleSignIn.disconnect();
      }

      await FirebaseAuth.instance.signOut();

      Navigator.of(context)
          .pushNamedAndRemoveUntil("onboding_screen", (route) => false);
    },
  ),
];
