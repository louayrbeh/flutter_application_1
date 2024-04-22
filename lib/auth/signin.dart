// ignore_for_file: prefer_const_constructors, avoid_print, unused_local_variable, use_build_context_synchronously, use_super_parameters, avoid_single_cascade_in_expression_statements

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_application_1/comp/textformfield.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 1000,
            width: 1000,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(1000, 13, 29, 37),
                Color.fromARGB(1000, 16, 76, 100),
              ]),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                '''
                Hello
                Sign in!''',
                style: TextStyle(
                  color: Color(0xFFF6F3E7),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 250.0,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height - 250.0,
                decoration: BoxDecoration(
                  color: Color(0xFFF6F3E7),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 18, right: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextFormField(
                        label: "Email",
                        mycontroller: email,
                      ),
                      CustomTextFormField(
                        label: "Password",
                        mycontroller: password,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () async {
                            if (email.text == "") {
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
                                  .sendPasswordResetEmail(email: email.text);

                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.info,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc:
                                    'A password reset email has been sent to you!',
                              )..show();
                            } catch (e) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'Check your email then retry!',
                              )..show();
                            }
                          },
                          child: Text(
                            "Forgot Password ?",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(1000, 13, 29, 37),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: () async {
                          try {
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email.text, password: password.text);
                            if (credential.user!.emailVerified) {
                              Navigator.of(context)
                                  .pushReplacementNamed("home");
                            } else {
                              FirebaseAuth.instance.currentUser!
                                  .sendEmailVerification();
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.rightSlide,
                                title: 'Dialog Title',
                                desc: 'Please verified your email!',
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
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Color(0xFFF6F3E7),
                            ),
                            gradient: LinearGradient(colors: const [
                              Color.fromARGB(1000, 13, 29, 37),
                              Color.fromARGB(1000, 16, 76, 100),
                            ]),
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
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "Don't have an account ?",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(1000, 13, 29, 37),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed("signup");
                        },
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "Sign up ...",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color.fromARGB(1000, 13, 29, 37),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
