import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learnxt/Auth/loginpage.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const Learnxt());
}
class Learnxt extends StatelessWidget {
  const Learnxt({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home : Loginpage()
    );
  }
}