import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnxt/Auth/loginpage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const Text("LearnXT -HOME"),
            ElevatedButton(onPressed: () {
              logout();
            }, child: const Text("Logout"))
          ],
        ),
      ),
    );
  }

  void logout() async {
    //logout method
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Loginpage(),
        ));
  }
}