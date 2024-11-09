import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:learnxt/Auth/loginpage.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    super.initState();
    BannerAdload();
    nativeadvancedadloader();
  }

  late BannerAd _bannerAd;
  bool isbanneradsload = false;
  BannerAdload() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-8568607330093795/5482884902",
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              isbanneradsload = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            print("Error in ads banner:$error");
          },
        ),
        request: const AdRequest());
    _bannerAd.load();
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.grey.shade900,
          Colors.grey.shade800,
          Colors.grey.shade400
        ])),
        child: Stack(children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 36, left: 5, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 2.0,
                              color: Color.fromARGB(255, 14, 60, 13),
                            ),
                          ],
                        )),
                    Text(
                      "Profile",
                      style: GoogleFonts.ptSerif(
                        color: Colors.white,
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                        shadows: <Shadow>[
                          const Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0,
                            color: Color.fromARGB(255, 14, 60, 13),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(),
                    const Divider()
                  ],
                ),
              ),
            ],
          ),
          Positioned(
              top: 100,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: Color(0xFFEFFFFC),
                ),
                child: Stack(children: [
                  FutureBuilder(
                    future: fetch_user_profile(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Center(child: Text('Error: ${snapshot.error}')),
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
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 35),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      maxRadius: 35,
                                      backgroundImage:
                                          AssetImage("assets/ai logo.jpeg"),
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Column(
                                            children: [
                                              Text(
                                                profileData["Name"],
                                                style: GoogleFonts.ptSerif(
                                                  color: Colors.black,
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(profileData["Email"])
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const VerticalDivider(
                                  color: Colors.grey,
                                  thickness: 3,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                    left: 50, right: 50, top: 15, bottom: 10),
                                child: Divider(
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Card(
                                    color: Colors.grey.shade400,
                                    child: ListTile(
                                      title: const Text(
                                        "Logout",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      trailing: const Icon(
                                        Icons.logout_outlined,
                                        color: Colors.white,
                                      ),
                                      onTap: logout,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 258),
                    child: isNativeAdAdLoaded
                        ? SizedBox(
                            child: AdWidget(ad: nativeAd),
                          )
                        : const SizedBox(),
                  ),
                ]),
              ))
        ]),
      ),
      bottomNavigationBar: isbanneradsload
          ? SizedBox(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            )
          : const SizedBox(),
    );
  }

  void logout() async {
    //logout method
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => const Loginpage(),
        ));
  }

  // ignore: non_constant_identifier_names
  fetch_user_profile() async {
    // ... your existing fetchData logic ...
    final user = FirebaseAuth.instance.currentUser;
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('User');

    final query =
        collection.where('UID', isEqualTo: user?.uid); // Example condition

    final querySnapshot = await query.get();
    final data = querySnapshot.docs.map((doc) => doc.data()).toList();
    // Access data as a list of Maps
    // print(data);
    //
    return data; // Return the retrieved data list
  }
}
