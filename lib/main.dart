import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:learnxt/Auth/splash.dart';
import 'package:learnxt/key.dart';
import 'package:learnxt/firebase_options.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  // gemini init
  Gemini.init(
    apiKey: GEMINI_API_KEY,
  );
  // firebase init
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // admob init
  MobileAds.instance.initialize();
  runApp(const Learnxt());
}

class Learnxt extends StatelessWidget {
  const Learnxt({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
      color: Color.fromARGB(255, 47, 255, 1),
    );
  }
}
