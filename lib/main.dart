import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Splash(),
      theme: ThemeData(
        useMaterial3: true,

        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green.shade400,
          // ···
          brightness: Brightness.light,
        ),
        // textTheme: TextTheme(
        //   displayLarge: const TextStyle(
        //     fontSize: 72,
        //     fontWeight: FontWeight.bold,
        //   ),
        //   // ···
        //   titleLarge: GoogleFonts.dmSerifDisplay(
        //       fontSize: 40,
        //       fontStyle: FontStyle.normal,
        //       color: Colors.green.shade400),
        //   bodyMedium: GoogleFonts.merriweather(),
        //   displaySmall: GoogleFonts.pacifico(),
        // ),
      ),
    );
  }
}
