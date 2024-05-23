// ignore_for_file: use_super_parameters, library_private_types_in_public_api, prefer_const_constructors, no_leading_underscores_for_local_identifiers

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/comp/animated_menu/components/side_menu.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    Key? key,
    required Future Function() signInWithGoogle,
    required Future Function() signInWithFacebook,
  }) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Email",
            style: TextStyle(color: Colors.black54),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SvgPicture.asset("assets/icons/email.svg"),
                ),
              ),
            ),
          ),
          const Text(
            "Password",
            style: TextStyle(color: Colors.black54),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SvgPicture.asset("assets/icons/password.svg"),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            child: ElevatedButton.icon(
              onPressed: () async {
                Future<void> _saveUserEmail(String email) async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('userEmail', email);
                }

                try {
                  final credential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text);
                  if (credential.user!.emailVerified) {
                    _saveUserEmail(
                        _emailController.text); // Sauvegarde de l'e-mail
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => SideMenu(
                          email: _emailController.text,
                          password: _passwordController.text,
                        ),
                      ),
                    );
                  } else {
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: 'Dialog Title',
                      desc: 'Please verify your email!',
                    ).show();
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Dialog Title',
                      desc: 'No user found for that email !',
                    ).show();
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided for that user.');
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Dialog Title',
                      desc: 'Wrong password provided for that user !',
                    ).show();
                  }
                  if ((_emailController.text == '') ||
                      (_passwordController.text == '')) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Dialog Title',
                      desc: 'Please fill in all form fields!',
                    ).show();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF77D8E),
                minimumSize: const Size(double.infinity, 56),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                ),
              ),
              icon: const Icon(
                Icons.arrow_right,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              label: const Text(
                "Sign In",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Poppins",
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              if (_emailController.text == "") {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  title: 'Error',
                  desc: 'You must enter your email !',
                )..show();
                return;
              }
              try {
                await FirebaseAuth.instance
                    .sendPasswordResetEmail(email: _emailController.text);

                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.info,
                  animType: AnimType.rightSlide,
                  title: 'Error',
                  desc: 'A password reset email has been sent to you!',
                )..show();
              } catch (e) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  title: 'error',
                  desc: 'Check your email then retry!',
                )..show();
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text("Forgot Password ?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  )),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
