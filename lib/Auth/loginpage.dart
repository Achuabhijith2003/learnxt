import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:learnxt/Auth/SignUp.dart';
import 'package:learnxt/Auth/accountRecovery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learnxt/Services/Hive/chat.dart';

import '../Screen/home.dart';

Chatputandget chatmodif = Chatputandget();

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Create an instance

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user != null) {
        // Handle successful sign-in
        print('Signed in with Google: ${user.uid}');
        createdatabase(
            user.email!, user.displayName ?? ''); // Use null-safe operators
        // init exiting hive chat
        chatmodif.initallchat();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    } catch (error) {
      print('Error signing in with Google: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-In failed: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailcontroller = TextEditingController();
    TextEditingController passwordcontroller = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.grey.shade900,
          Colors.grey.shade800,
          Colors.grey.shade400
        ])),
        child: Padding(
          padding: const EdgeInsets.all(.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1300),
                        child: const Text(
                          "Welcome Back",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 0),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        FadeInUp(
                            duration: const Duration(milliseconds: 1400),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Color.fromRGBO(225, 95, 27, .3),
                                        blurRadius: 20,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade200))),
                                    child: TextField(
                                      controller: emailcontroller,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                          hintText: "Email or Phone number",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade200))),
                                    child: TextField(
                                      controller: passwordcontroller,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                          hintText: "Password",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 0,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              FadeInUp(
                                  duration: const Duration(milliseconds: 1500),
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SignUp()));
                                      },
                                      child: const Text(
                                        "Create Account",
                                        style: TextStyle(color: Colors.grey),
                                      ))),
                              FadeInUp(
                                  duration: const Duration(milliseconds: 1500),
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Recovery()));
                                      },
                                      child: const Text(
                                        "Forgot Password?",
                                        style: TextStyle(color: Colors.grey),
                                      ))),
                            ]),
                        const SizedBox(
                          height: 10,
                        ),
                        FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: MaterialButton(
                              onPressed: () {
                                login(emailcontroller, passwordcontroller);
                              },
                              height: 50,
                              // margin: EdgeInsets.symmetric(horizontal: 50),
                              color: Colors.grey[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              // decoration: BoxDecoration(
                              // ),
                              child: const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 0,
                        ),
                        // FadeInUp(
                        //     duration: const Duration(milliseconds: 1700),
                        //     child: const Text(
                        //       "Continue with social media",
                        //       style: TextStyle(color: Colors.grey),
                        //     )),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: FadeInUp(
                                  duration: const Duration(milliseconds: 1800),
                                  child: SignInButton(
                                    Buttons.Google,
                                    text: "Sign up with Google",
                                    onPressed: () => _signInWithGoogle(),
                                  )),
                            ),
                            const SizedBox(
                              width: 0,
                            ),
                            // Expanded(
                            //   child: FadeInUp(
                            //       duration: const Duration(milliseconds: 1900),
                            //       child: MaterialButton(
                            //         onPressed: () {},
                            //         height: 50,
                            //         shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(50),
                            //         ),
                            //         color: Colors.black,
                            //         child: const Center(
                            //           child: Text(
                            //             "Github",
                            //             style: TextStyle(
                            //                 color: Colors.white,
                            //                 fontWeight: FontWeight.bold),
                            //           ),
                            //         ),
                            //       )),
                            // )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void login(TextEditingController emailcontroller,
      TextEditingController passwordcontroller) async {
    String email = emailcontroller.text.trim();
    String password = passwordcontroller.text.trim();
    if (email == "" || password == "") {
      errormessage("Both fields are required.");
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          // Access user through the instance
          // ignore: use_build_context_synchronously
          // init exiting hive chat
          chatmodif.initallchat();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ));
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        log(e.code.toString());
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'Your email address is invalid.';
            break;
          case 'wrong-password':
            errorMessage = 'Your password is wrong.';
            break;
          default:
            errorMessage = 'An undefined Error occurred. try again later';
        }
        errormessage(errorMessage);
      }
    }
  }

  void errormessage(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error!'),
          content: Text(errorMessage),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Okay'))
          ],
        );
      },
    );
  }

  void createdatabase(String email, String name) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    // ignore: non_constant_identifier_names
    final Uid = user?.uid;
    Map<String, dynamic> newuserdata = {
      "UID": Uid,
      "Name": name,
      "Email": email,
    };
    FirebaseFirestore.instance.collection("User").doc(Uid).set(newuserdata);
  }
}
