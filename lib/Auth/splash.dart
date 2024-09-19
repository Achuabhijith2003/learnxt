import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:learnxt/Auth/loginpage.dart';
import 'package:learnxt/Screen/home.dart';
// import 'package:learnxt/Services/Gadsmob.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    // admob ads = admob();
    // Appopenadd
    // ads.AppOpenAdload();
    return Scaffold(
      body: Center(
        child: FlutterSplashScreen.gif(
          backgroundColor: Colors.white,
          gifPath: 'assets/splash .gif',
          gifWidth: 269,
          gifHeight: 474,
          nextScreen: (FirebaseAuth.instance.currentUser != null)
              ? const Home()
              : const Loginpage(),
          duration: const Duration(milliseconds: 3515),
          onInit: () async {
            debugPrint("onInit");
          },
          onEnd: () async {
            debugPrint("onEnd 1");
          },
        ),
      ),
    );
  }
}
