import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:learnxt/Auth/Authservices.dart';
import 'package:learnxt/Auth/loginpage.dart';
import 'package:learnxt/Screen/home.dart';
import 'package:learnxt/Screen/user_profile.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
    nativeadvancedadloader();
  }

  // native_ads
  late NativeAd nativeAd;
  bool isNativeAdAdLoaded = false;
  final String adUnitId = "ca-app-pub-8568607330093795/3077653778";

  // Native advanced
  nativeadvancedadloader() {
    nativeAd = NativeAd(
        adUnitId: adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            setState(() {
              isNativeAdAdLoaded = true;
            });

            print("native advanced adloader: Ad Loaded");
          },
          onAdFailedToLoad: (ad, error) {
            setState(() {
              isNativeAdAdLoaded = false;
              ad.dispose();
            });
            print("native advanced adloader: Ad Loaded is failed");
          },
        ),
        request: const AdManagerAdRequest(),
        nativeTemplateStyle:
            NativeTemplateStyle(templateType: TemplateType.small));
    nativeAd.load();
  }

  @override
  Widget build(BuildContext context) {
    Authservices authservices = Authservices();
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 15),
            child: Text(
              "Settings",
              style: GoogleFonts.dmSerifDisplay(fontSize: 40, letterSpacing: 4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 45),
            child: FutureBuilder(
              future: fetch_user_profile(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('Error: ${snapshot.error}')),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                    ),
                  ); // Show loading indicator
                }
                final data = snapshot.data as List<Map<String, dynamic>>;
                final profileData = data[0];
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('Error: ${snapshot.error}')),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                    ),
                  ); // Show loading indicator
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 65),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserProfile()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage(
                                "assets/ai logo.jpeg",
                              ),
                              maxRadius: 35,
                            ),
                            Text(
                              profileData["Name"],
                              style: GoogleFonts.dmSerifDisplay(
                                  fontSize: 35, color: Colors.black),
                            ),
                            const Icon(Icons.arrow_circle_right)
                          ],
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text("Help"),
                        leading: const Icon(Icons.help),
                        onTap: () async {
                          final uri = Uri.parse(
                              'https://www.developwithjr.info/blog/v0.0.3/');
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          } else {
                            throw 'Could not launch $uri';
                          }
                        },
                      ),
                      ListTile(
                        title: const Text('Invite friends'),
                        leading: const Icon(Icons.share),
                        onTap: () async {
                          await Share.share(
                              "Check out this link: https://play.google.com/store/apps/details?id=com.gurudha.learnxt");
                        },
                      ),
                      ListTile(
                        title: const Text('Privacy Policy'),
                        leading: const Icon(Icons.privacy_tip_outlined),
                        onTap: () async {
                          final uri = Uri.parse(
                              'https://www.developwithjr.info/privacy_policy/');
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          } else {
                            throw 'Could not launch $uri';
                          }
                        },
                      ),
                      ListTile(
                        title: const Text('Logout'),
                        leading: const Icon(Icons.logout_outlined),
                        onTap: () async {
                          if (await authservices.logout()) {
                            Navigator.pushReplacement(
                                // ignore: use_build_context_synchronously
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Loginpage(),
                                ));
                          }
                        },
                      ),
                      const ListTile(
                        title: Text('V0.5.0'),
                        leading: Icon(Icons.app_shortcut_sharp),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 488),
            child: isNativeAdAdLoaded
                ? SizedBox(
                    child: AdWidget(ad: nativeAd),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
