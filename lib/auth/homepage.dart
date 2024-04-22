// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/auth/signin.dart';
import 'package:flutter_application_1/auth/signup.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
  }

  Future signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();
    if (loginResult.accessToken == null) {
      return;
    }
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(1000, 13, 29, 37),
            Color.fromARGB(1000, 16, 76, 100),
          ]),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 150),
              child: Column(
                children: [
                  Image.asset(
                    "assets/icon/icons8-logo-100.png",
                    height: 90,
                    width: 90,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Fucking Alzheimer",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF6F3E7),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Color(0xFFF6F3E7),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              },
              child: Container(
                height: 50,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Color(0xFFF6F3E7)),
                ),
                child: Center(
                  child: Text(
                    "SIGN IN",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF6F3E7),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignUP()));
              },
              child: Container(
                height: 50,
                width: 350,
                decoration: BoxDecoration(
                  color: Color(0xFFF6F3E7),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Color(0xFFF5F5DC)),
                ),
                child: Center(
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Text(
              "Login with Social Media",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF6F3E7),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    signInWithGoogle();
                  },
                  child: Image.asset(
                    "assets/icon/icons8-google-plus-circled-50.png",
                    width: 70,
                    height: 70,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    signInWithFacebook();
                  },
                  child: Image.asset(
                    "assets/icon/icons8-facebook-50.png",
                    width: 70,
                    height: 70,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    "assets/icon/icons8-twitter-circled-50.png",
                    width: 70,
                    height: 70,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
