import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:learnxt/Auth/loginpage.dart';
import 'package:learnxt/Screen/aichatadd.dart';
import 'package:learnxt/Screen/chatai.dart';
import 'package:learnxt/Screen/user_profile.dart';
import 'package:learnxt/Services/Hive/chatid.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Services/Hive/chat.dart';

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
    fetch_user_profile();
  }

  String name = "";
  List<Map<String, dynamic>> data = [];
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

  Chatputandget chatstore = Chatputandget();
  Chatidputandget chatid = Chatidputandget();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.grey.shade900,
          Colors.grey.shade800,
          Colors.grey.shade400
        ])),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 36, left: 5, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            _globalKey.currentState!.openDrawer();
                          },
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 34,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 2.0,
                                color: Color.fromARGB(255, 14, 60, 13),
                              ),
                            ],
                          )),
                      Center(
                        child: Text(
                          "LearnXT",
                          style: GoogleFonts.ptSerif(
                            color: Colors.white,
                            fontSize: 40,
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
                      ),
                      // adjacent "LearnXT" text to center
                      const Divider(),
                      const Divider()
                    ],
                  ),
                ),
                // const SizedBox(
                //   width: 35,
                // ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 42,
                    right: 42,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0,
                            color: Color.fromARGB(255, 14, 60, 13),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(25),
                        color: Color(
                            int.parse("#f5f3ef".substring(1, 7), radix: 16) +
                                0xFF000000)),
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1500),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.search_outlined,
                            color: Colors.grey,
                          ),
                          // suffixIcon: IconButton(
                          //     onPressed: () {
                          //     },
                          //     icon: Icon(
                          //       Icons.arrow_right_alt_rounded,
                          //       color: Colors.grey,
                          //     )),
                          hintText: "Search...",
                          hintStyle: GoogleFonts.barlowSemiCondensed(
                              fontSize: 16, color: Colors.grey),
                          enabled: true,
                        ),
                        onChanged: (val) {
                          setState(() {
                            name = val;
                          });
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
            Positioned(
                top: 155,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                    color: Color(0xFFEFFFFC),
                  ),
                  child: FutureBuilder(
                    future: fetchData(), // Initial fetch with limit
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
                                      ListTile(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Chatai(
                                                        botname:
                                                            botData["Bot Name"],
                                                        docId: botData["docId"],
                                                      )));
                                        },
                                        onLongPress: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                shadowColor: Colors.grey,
                                                title: Text(
                                                  botData["Bot Name"],
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                // content: const Text("errorMessage"),
                                                actions: [
                                                  Center(
                                                    //Delete the bot
                                                    child: TextButton(
                                                        onPressed: () async {
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false, // Disable user interaction while uploading
                                                            builder: (context) =>
                                                                const Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  CircularProgressIndicator(
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                          final deletionSuccessful =
                                                              await deletebot(
                                                                  botData[
                                                                      "docId"]);
                                                          if (deletionSuccessful) {
                                                            // Show a success notification (e.g., Snackbar)
                                                            setState(() {
                                                              fetchData();
                                                            }); // Show loading indicator
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                    'Bot deleted successfully!'),
                                                                backgroundColor:
                                                                    Colors.grey,
                                                              ),
                                                            );

                                                            // Potentially refresh the list of bots after successful deletion
                                                          } else {
                                                            // Show an error notification (e.g., Snackbar)
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                    'Error deleting bot!'),
                                                                backgroundColor:
                                                                    Colors.red,
                                                              ),
                                                            );
                                                          }
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          'Delete the bot',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        )),
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        title: Text(
                                          botData['Bot Name'],
                                          style: GoogleFonts.publicSans(
                                              fontSize: 20,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w700),
                                        ), // Access data for each bot
                                        // trailing: const Text(
                                        //   "lastmess",
                                        //   style: TextStyle(
                                        //       color: Colors.white, fontSize: 14),
                                        // ),
                                        leading: const CircleAvatar(
                                          maxRadius: 30,
                                          backgroundImage:
                                              AssetImage("assets/ai logo.jpeg"),
                                        ),
                                        horizontalTitleGap: 16,
                                        minVerticalPadding: 5,
                                        selectedTileColor: Colors.black87,
                                        textColor: Colors.black,
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
                              return Card(
                                color: Colors.grey.shade800,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Chatai(
                                                    botname:
                                                        botData["Bot Name"],
                                                    docId: botData["docId"],
                                                  )));
                                    },
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              botData["Bot Name"],
                                              textAlign: TextAlign.center,
                                            ),
                                            // content: const Text("errorMessage"),
                                            actions: [
                                              Center(
                                                //Delete the bot
                                                child: TextButton(
                                                    onPressed: () async {
                                                      final deletionSuccessful =
                                                          await deletebot(
                                                              botData["docId"]);
                                                      if (deletionSuccessful) {
                                                        // Show a success notification (e.g., Snackbar)
                                                        setState(() {
                                                          fetchData();
                                                        });
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                'Bot deleted successfully!'),
                                                            backgroundColor:
                                                                Colors.grey,
                                                          ),
                                                        );

                                                        // Potentially refresh the list of bots after successful deletion
                                                      } else {
                                                        // Show an error notification (e.g., Snackbar)
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                'Error deleting bot!'),
                                                            backgroundColor:
                                                                Colors.red,
                                                          ),
                                                        );
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'Delete the bot',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    title: Text(
                                      botData['Bot Name'],
                                      style: GoogleFonts.publicSans(
                                        fontSize: 20,
                                        color: Colors.white,
                                        shadows: <Shadow>[
                                          const Shadow(
                                            offset: Offset(1.0, 1.0),
                                            blurRadius: 1.0,
                                            color:
                                                Color.fromARGB(255, 14, 60, 13),
                                          ),
                                        ],
                                      ),
                                    ), // Access data for each bot
                                    leading: const CircleAvatar(
                                      maxRadius: 30,
                                      backgroundImage:
                                          AssetImage("assets/ai pro pic.jpeg"),
                                    ),
                                    horizontalTitleGap: 10,
                                    minVerticalPadding: 25,
                                    selectedTileColor: Colors.white,
                                    textColor: Colors.black,
                                  ),
                                ),
                              );
                              // Add a "Load More" button or implement infinite scrolling if needed
                            }
                            return null;
                          });
                    },
                  ),
                ))
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          backgroundColor: Colors.grey.shade800,
          child: const Icon(
            Icons.add_box_outlined,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Chatcreate(),
                ));
          },
        ),
      ),
      drawer: FutureBuilder(
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
          return Drawer(
            width: 275,
            elevation: 30,
            backgroundColor: Colors.grey.shade800,
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(40))),
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.horizontal(right: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x3D000000),
                        spreadRadius: 30,
                        blurRadius: 20)
                  ]),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(
                              width: 56,
                            ),
                            Text(
                              'Settings',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const UserProfile()));
                          },
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundImage: AssetImage(
                                  "assets/ai logo.jpeg",
                                ),
                                maxRadius: 30,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                profileData["Name"],
                                style: const TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        DrawerItem(
                          title: 'Help',
                          icon: Icons.help,
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
                        const Divider(
                          height: 35,
                          color: Colors.grey,
                        ),
                        DrawerItem(
                          title: 'Invite a friend',
                          icon: Icons.people_outline,
                          onTap: () async {
                            await Share.share(
                                "Check out this link: https://github.com/Achuabhijith2003/learnxt/releases,");
                          },
                        ),
                        DrawerItem(
                          title: 'Privacy Policy',
                          icon: Icons.privacy_tip_outlined,
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
                      ],
                    ),
                    const SizedBox(
                      height: 370,
                    ),
                    DrawerItem(
                      title: 'Log out',
                      icon: Icons.logout,
                      onTap: logout,
                    ),
                    Text(
                      "Version : 0.0.5",
                      style: TextStyle(color: Colors.grey.shade300),
                    )
                  ],
                ),
              ),
            ),
          );
        },
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

  Column buildConversationRow(
      String name, String message, String filename, int msgCount) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                UserAvatar(filename: filename),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      message,
                      style:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25, top: 5),
              child: Column(
                children: [
                  const Text(
                    '16:35',
                    style: TextStyle(fontSize: 10),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (msgCount > 0)
                    CircleAvatar(
                      radius: 7,
                      backgroundColor: const Color.fromARGB(255, 30, 177, 30),
                      child: Text(
                        msgCount.toString(),
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
        const Divider(
          indent: 70,
          height: 20,
        )
      ],
    );
  }

  Padding buildContactAvatar(String name, String filename) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Column(
        children: [
          UserAvatar(
            filename: filename,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          )
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    // ... your existing fetchData logic ...
    final user = FirebaseAuth.instance.currentUser;
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('Bot');

    final query =
        collection.where('UID', isEqualTo: user?.uid); // Example condition

    final querySnapshot = await query.get();
    final data = querySnapshot.docs.map((doc) => doc.data()).toList();
    // Access data as a list of Maps
    // print(data);
    //
    return data; // Return the retrieved data list
  }

// here two times calling docId 1. passing the doc ID 2. Finding through firebase instance
// in future try to remove Ok!
  Future<bool> deletebot(String docId) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('Bot').doc(docId);
      final subcollection = docRef.collection("dataEmbedded");
      try {
        await subcollection.get().then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            doc.reference.delete();
          }
        });
        await docRef.delete();
        setState(() {
          fetchData();
        });

        print('Subcollection deleted successfully');
        return true; // Deletion successful
      } catch (e) {
        print('Error deleting subcollection: $e');
      }

      return true; // Deletion successful
    } catch (error) {
      return false; // Deletion failed
    }
  }
}

// ignore: non_constant_identifier_names
fetch_user_profile() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('User');

    final query =
        collection.where('UID', isEqualTo: user?.uid); // Example condition

    final querySnapshot = await query.get();
    final data = querySnapshot.docs.map((doc) => doc.data()).toList();
    return data;
  } catch (e) {
    print("Fetch prrofile error : $e");
  }
  // ... your existing fetchData logic ...

  // Access data as a list of Maps
  // print(data);
  //
  // Return the retrieved data list
  return [];
}

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  const DrawerItem({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(
              width: 40,
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final String filename;
  const UserAvatar({
    super.key,
    required this.filename,
  });

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 32,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 29,
        // backgroundImage: Image.asset('assets/images/$filename').image,
      ),
    );
  }
}
