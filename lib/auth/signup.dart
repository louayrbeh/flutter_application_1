// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, avoid_print, unused_local_variable, avoid_single_cascade_in_expression_statements, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/signin.dart';
import 'package:flutter_application_1/comp/textFormField.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class SignUP extends StatefulWidget {
  const SignUP({super.key});

  @override
  State<SignUP> createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  TextEditingController FullName = TextEditingController();
  TextEditingController PhoneOrEmail = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController ConfirmePassword = TextEditingController();
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
      Create Your 
      Account''',
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
              padding: const EdgeInsets.only(top: 250.0),
              child: Container(
                height: MediaQuery.of(context).size.height - 250.0,
                decoration: BoxDecoration(
                  color: Color(0xFFF6F3E7),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                width: 1000,
                child: Padding(
                  padding: EdgeInsets.only(left: 18, right: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextFormField(
                        label: "Full Name",
                        mycontroller: FullName,
                      ),
                      CustomTextFormField(
                        label: "Phone or Email",
                        mycontroller: PhoneOrEmail,
                      ),
                      CustomTextFormField(
                        label: "Password",
                        mycontroller: Password,
                      ),
                      CustomTextFormField(
                        label: "Confirme Password",
                        mycontroller: ConfirmePassword,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if ((FullName.text == '') ||
                              (PhoneOrEmail.text == '') ||
                              (Password.text == '') ||
                              (ConfirmePassword.text == '')) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'You must complete all form fields!',
                            )..show();
                          } else if (Password.text != ConfirmePassword.text) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'WRONG PASSWORD!',
                            )..show();
                          } else {
                            try {
                              final credential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: PhoneOrEmail.text,
                                password: Password.text,
                              );
                              FirebaseAuth.instance.currentUser!
                                  .sendEmailVerification();
                              Navigator.of(context)
                                  .pushReplacementNamed("signin");
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                print('The password provided is too weak.');
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error',
                                  desc: 'The password provided is too weak !',
                                )..show();
                              } else if (e.code == 'email-already-in-use') {
                                print(
                                    'The account already exists for that email.');
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error',
                                  desc:
                                      'The account already exists for that email!',
                                )..show();
                              }
                            } catch (e) {
                              print(e);
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
                            gradient: LinearGradient(colors: [
                              Color.fromARGB(1000, 13, 29, 37),
                              Color.fromARGB(1000, 16, 76, 100),
                            ]),
                          ),
                          child: Center(
                            child: Text(
                              "SIGN UP",
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
                          "Have an account ?",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(1000, 13, 29, 37),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignIn()));
                        },
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "Sign in ...",
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
