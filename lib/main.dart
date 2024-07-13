import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learnxt/Auth/splash.dart';
import 'package:learnxt/firebase_options.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Learnxt());
}
class Learnxt extends StatelessWidget {
  const Learnxt({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home : Splash()
    );
  }
}