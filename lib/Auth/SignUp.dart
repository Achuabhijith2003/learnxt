import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnxt/Auth/loginpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    TextEditingController namecontroller = TextEditingController();
    TextEditingController emailcontroller = TextEditingController();
    TextEditingController passwordcontroller = TextEditingController();
    TextEditingController rePasswordcontroller = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.green.shade900,
          Colors.green.shade800,
          Colors.green.shade400
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
                          "Create Account",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    // FadeInUp(
                    //     duration: const Duration(milliseconds: 1300),
                    //     child: const Text(
                    //       "Welcome Back",
                    //       style: TextStyle(color: Colors.white, fontSize: 18),
                    //     )),
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
                                      controller: namecontroller,
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                          hintText: "Name",
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
                                      controller: emailcontroller,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                          hintText: "Email",
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
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade200))),
                                    child: TextField(
                                      controller: rePasswordcontroller,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                          hintText: "re-enter Password",
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
                        const SizedBox(
                          height: 10,
                        ),
                        FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: MaterialButton(
                              onPressed: () {
                                accountcreate(
                                    emailcontroller,
                                    passwordcontroller,
                                    rePasswordcontroller,
                                    namecontroller);
                              },
                              height: 50,
                              // margin: EdgeInsets.symmetric(horizontal: 50),
                              color: Colors.green[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              // decoration: BoxDecoration(
                              // ),
                              child: const Center(
                                child: Text(
                                  "Signup",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 0,
                        ),
                        FadeInUp(
                            duration: const Duration(milliseconds: 1700),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Loginpage()));
                                },
                                child: const Text(
                                  "Already have an account? Login",
                                  style: TextStyle(color: Colors.grey),
                                ))),
                        const SizedBox(
                          height: 25,
                        ),
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

  void accountcreate(
      TextEditingController emailcontroller,
      TextEditingController passwordcontroller,
      TextEditingController rePasswordcontroller,
      TextEditingController namecontroller) async {
    String email = emailcontroller.text.trim();
    String password = passwordcontroller.text.trim();
    String repasword = rePasswordcontroller.text.trim();
    String name = namecontroller.text.trim();
    if (email == "" || password == "" || repasword == "") {
      errormessage("Every fields are required.");
    } else {
      if (password != repasword) {
        errormessage("Password and Re-Password are not same");
      } else {
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);
          if (userCredential.user != null) {
            createdatabase(email,name);
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Loginpage()));
          }
        } on FirebaseAuthException catch (e) {
          log(e.code.toString());
          switch (e.code) {
            case "invalid-email":
              errormessage("Invalid Email Address");
              break;
            case "weak-password":
              errormessage("Weak Password");
              break;
            case "email-already-in-use":
              errormessage(
                  "The provided email is already in use by another account.");
              break;
            default:
              errormessage("An undefined Error occured.");
          }
        }
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
      "UID":Uid,
      "Name": name,
      "Email": email,
    };
    FirebaseFirestore.instance.collection("User").doc().set(newuserdata);
  }
}
