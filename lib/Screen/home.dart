import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:learnxt/Screen/aichatadd.dart';
import 'package:learnxt/Screen/compoments/material.dart';
import 'package:learnxt/Screen/user_profile.dart';
import 'package:learnxt/Services/Chats/Chat_Operations.dart';
import 'package:learnxt/Services/Hive/chat.dart';
import 'package:learnxt/Services/Hive/chatid.dart';
import 'package:learnxt/Services/gadsmob.dart';

import 'package:learnxt/theme/theme_model.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    BannerAdload();
    BannerAdload2();
  }

  admob ads = admob();
  String name = "";
  Chatputandget chatstore = Chatputandget();
  Chatidputandget chatid = Chatidputandget();
  ChatOperations chatop = ChatOperations();
  List<Map<String, dynamic>> data = [];
  bool hasdata = true;
  late BannerAd _bannerAd;
  bool isbanneradsload = false;
  late BannerAd _bannerAd2;
  bool isbanneradsload2 = false;
  BannerAdload() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "", //ca-app-pub-8568607330093795/5482884902
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

  BannerAdload2() {
    _bannerAd2 = BannerAd(
        size: AdSize.banner,
        // adUnitId: 'ca-app-pub-3940256099942544/9214589741',
        adUnitId: "", //ca-app-pub-8568607330093795/5482884902
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              isbanneradsload2 = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            print("Error in ads banner:$error");
          },
        ),
        request: const AdRequest());
    _bannerAd2.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _bannerAd2.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        backgroundColor:
            themeNotifier.isDark ? Colors.grey.shade900 : Colors.white,
        key: _globalKey,
        body: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40, left: 15),
                        child: Text(
                          "LearnXT",
                          style: GoogleFonts.dmSerifDisplay(
                              fontSize: 27,
                              letterSpacing: 4,
                              color: themeNotifier.isDark
                                  ? Colors.white
                                  : Colors.grey.shade900),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Profile
                      Padding(
                        padding: const EdgeInsets.only(top: 40, right: 10),
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: chatop.fetch_user_profile(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircleAvatar(
                                child: CircularProgressIndicator(
                                  backgroundColor: themeNotifier.isDark
                                      ? Colors.grey
                                      : Colors.grey.shade900,
                                  color: themeNotifier.isDark
                                      ? Colors.white
                                      : Colors.grey.shade900,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return const CircleAvatar(
                                child: Text('Error'),
                              );
                            } else if (snapshot.hasData) {
                              final userdataList = snapshot.data!;
                              if (userdataList.isNotEmpty) {
                                final userData = userdataList[0];
                                final imageUrl = userData["Image_url"];
                                return IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const UserProfile(),
                                      ),
                                    );
                                  },
                                  icon: CircleAvatar(
                                    backgroundColor: themeNotifier.isDark
                                        ? Colors.grey
                                        : Colors.white,
                                    backgroundImage:
                                        imageUrl != null && imageUrl.isNotEmpty
                                            ? NetworkImage(imageUrl)
                                            : null,
                                    child: Icon(
                                      Icons.account_circle_rounded,
                                      color: themeNotifier.isDark
                                          ? Colors.grey.shade900
                                          : Colors.grey.shade900,
                                    ),
                                  ),
                                  iconSize: 30,
                                );
                              } else {
                                return IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const UserProfile(),
                                      ),
                                    );
                                  },
                                  icon: const CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                  iconSize: 30,
                                );
                              }
                            } else {
                              return IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const UserProfile(),
                                      ));
                                },
                                icon: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                iconSize: 30,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Welcome",
                      style: GoogleFonts.dmSerifDisplay(
                          fontSize: 40,
                          letterSpacing: 4,
                          color: themeNotifier.isDark
                              ? Colors.white
                              : Colors.grey.shade900),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              // Searching panal
              Padding(
                  padding: const EdgeInsets.only(top: 150, left: 15, right: 15),
                  child: SearchBar(
                      hintText: "Search....",
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      })),
              Column(
                children: [
                  // Display banner ad if loaded
                  if (isbanneradsload2)
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 180, left: Checkbox.width),
                      child: SizedBox(
                        height: _bannerAd.size.height.toDouble(),
                        width: _bannerAd.size.width.toDouble(),
                        child: AdWidget(ad: _bannerAd2),
                      ),
                    )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 230),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                        left: 20,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "My notebooks",
                            style: GoogleFonts.dmSerifDisplay(
                                fontSize: 30,
                                color: themeNotifier.isDark
                                    ? Colors.white
                                    : Colors.grey.shade900),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 4,
                        left: 20,
                      ),
                      child: Row(
                        children: [
                          PopupMenuButton(
                            iconColor: themeNotifier.isDark
                                ? Colors.white
                                : Colors.grey.shade900,
                            color: themeNotifier.isDark
                                ? Colors.grey.shade900
                                : Colors.white,
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                enabled: hasdata,
                                value: 1,
                                child: ListTile(
                                  title: Text(
                                    "Delete All Notebooks",
                                    style: TextStyle(
                                        color: themeNotifier.isDark
                                            ? Colors.white
                                            : Colors.grey.shade900),
                                  ),
                                  leading: const Icon(Icons.delete_forever),
                                ),
                                onTap: () async {
                                  return showDialog(
                                    context: context,
                                    barrierDismissible:
                                        false, // Prevent dismissing while loading
                                    builder: (context) => AlertDialog(
                                      backgroundColor: themeNotifier.isDark
                                          ? Colors.grey.shade900
                                          : Colors.white,
                                      title: Text(
                                        "Delete Notebooks",
                                        style: TextStyle(
                                            color: themeNotifier.isDark
                                                ? Colors.white
                                                : Colors.grey.shade900),
                                      ),
                                      content: Text(
                                        "Are you sure you want to delete the Notebooks? (Watch An Ads)",
                                        style: TextStyle(
                                            color: themeNotifier.isDark
                                                ? Colors.white
                                                : Colors.grey.shade900),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            );
                                            final deletesuccessfully =
                                                await chatop.deleteAllBot();
                                            if (deletesuccessfully) {
                                              fetchData();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'All Notebooks deleted successfully!'),
                                                  backgroundColor: Colors.grey,
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Notebooks deletion failed!'),
                                                  backgroundColor: Colors.grey,
                                                ),
                                              );
                                            }
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text(
                                            "Delete, Watch an ads",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              Positioned(
                top: 275,
                left: 0,
                right: 0,
                bottom: 0,
                child: FutureBuilder(
                  future: fetchData(), // Initial fetch with limit
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
                    if (data.isEmpty) {
                      hasdata = false;
                      return TextButton.icon(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Chatcreate())),
                        label: const Text("Create Chat"),
                        icon: const Icon(Icons.add_box_rounded),
                      );
                    }
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final botData = data[index];
                          if (name.isEmpty) {
                            return FadeIn(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                child: Column(
                                  children: [
                                    Materialcoures(
                                      botData: botData,
                                    ),
                                    const Divider()
                                  ],
                                ),
                              ),
                            );
                          }
                          if (botData['Bot Name']
                              .toString()
                              .toLowerCase()
                              .startsWith(name.toLowerCase())) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: Column(
                                children: [
                                  Materialcoures(
                                    botData: botData,
                                  ),
                                  const Divider()
                                ],
                              ),
                            );
                            // Add a "Load More" button or implement infinite scrolling if needed
                          }
                          return Container();
                        });
                  },
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    // ... your existing fetchData logic ...
    final user = FirebaseAuth.instance.currentUser;
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('bot');

    final query =
        collection.where('UID', isEqualTo: user?.uid); // Example condition

    final querySnapshot = await query.get();
    final data = querySnapshot.docs.map((doc) => doc.data()).toList();
    // Access data as a list of Maps
    print("total bot $data");
    if (data.isEmpty) {
      hasdata = false;
    }
    //
    return data; // Return the retrieved data list
  }

// here two times calling docId 1. passing the doc ID 2. Finding through firebase instance
// in future try to remove Ok!

  processUserData() async {
    try {
      Future<List<Map<String, dynamic>>> userdataFuture =
          chatop.fetch_user_profile();
      List<Map<String, dynamic>> userdata = await userdataFuture;

      print("Retrieved user data: $userdata");

      if (userdata.isNotEmpty) {
        return userdata;
      } else {
        print("No user data found for this user.");
        return []; // Or handle the empty case as needed
      }
    } catch (error) {
      print("Error fetching user profile in processUserData: $error");
      // Handle the error appropriately, e.g., show an error message to the user
      return []; // Or return a specific error state
    }
  }
}
