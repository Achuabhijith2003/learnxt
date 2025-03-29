import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:learnxt/Screen/Preminum/vip.dart';
import 'package:learnxt/Screen/aichatadd.dart';
import 'package:learnxt/Screen/chatai.dart';
import 'package:learnxt/Screen/user_profile.dart';
import 'package:learnxt/Services/AI/data_embedded.dart';
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
  ChatOperations chatop = ChatOperations();

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
  List<Map<String, dynamic>> data = [];
  bool hasdata = true;
  late BannerAd _bannerAd;
  bool isbanneradsload = false;
  late BannerAd _bannerAd2;
  bool isbanneradsload2 = false;
  BannerAdload() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        // adUnitId: 'ca-app-pub-3940256099942544/9214589741',
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

  BannerAdload2() {
    _bannerAd2 = BannerAd(
        size: AdSize.banner,
        // adUnitId: 'ca-app-pub-3940256099942544/9214589741',
        adUnitId: "ca-app-pub-8568607330093795/5482884902",
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
        key: _globalKey,
        body: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 15),
                    child: Text(
                      "LearnXT",
                      style: GoogleFonts.dmSerifDisplay(
                          fontSize: 40,
                          letterSpacing: 4,
                          color: Colors.grey.shade800),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Profile
                  Padding(
                    padding: const EdgeInsets.only(top: 40, right: 10),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserProfile()));
                      },
                      icon: const Icon(Icons.account_circle_rounded),
                      iconSize: 30,
                    ),
                  )
                ],
              ),

              // Searching panal
              Padding(
                padding: const EdgeInsets.only(top: 120, left: 15),
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
                    color: Colors.white,
                  ),
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 550),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.search_outlined,
                          color: Colors.grey,
                        ),
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
              ),
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 230),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        left: 20,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Chats",
                            style: GoogleFonts.dmSerifDisplay(
                                fontSize: 30, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        left: 20,
                      ),
                      child: Row(
                        children: [
                          PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                enabled: hasdata,
                                value: 1,
                                child: const ListTile(
                                  title: Text("Delete All Chat Bot"),
                                  leading: Icon(Icons.delete_forever),
                                ),
                                onTap: () async {
                                  return showDialog(
                                    context: context,
                                    barrierDismissible:
                                        false, // Prevent dismissing while loading
                                    builder: (context) => AlertDialog(
                                      title: const Text("Delete AI"),
                                      content: const Text(
                                          "Are you sure you want to delete the AI Bot? (Watch An Ads)"),
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
                                                      'All Bot deleted successfully!'),
                                                  backgroundColor: Colors.grey,
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Bot deletion failed!'),
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
                                                  child: TextButton(
                                                      onPressed: () {
                                                        addpdfs(
                                                            botData["docId"]);
                                                      },
                                                      child: const Text(
                                                        "Add PDFs",
                                                      )),
                                                ),
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
                                                            await chatop
                                                                .deletebot(
                                                                    botData[
                                                                        "docId"]);
                                                        if (deletionSuccessful) {
                                                          // Show a success notification (e.g., Snackbar)
                                                          setState(() {
                                                            fetchData();
                                                          }); // Show loading indicator
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
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        'Delete the bot',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      )),
                                                ),
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
                                      trailing: PopupMenuButton(
                                        child: const Icon(Icons.more_vert),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 1,
                                            child: const ListTile(
                                              title: Text("Add PDFs"),
                                              leading: Icon(Icons.add),
                                            ),
                                            onTap: () {
                                              addpdfs(botData["docId"]);
                                            },
                                          ),
                                          PopupMenuItem(
                                            value: 2,
                                            child: const ListTile(
                                              title: Text("Delete AI bot"),
                                              leading: Icon(Icons.delete),
                                            ),
                                            onTap: () async {
                                              return showDialog(
                                                context: context,
                                                barrierDismissible:
                                                    false, // Prevent dismissing while loading
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title:
                                                      const Text("Delete AI"),
                                                  content: const Text(
                                                      "Are you sure you want to delete the AI Bot?"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                      },
                                                      child:
                                                          const Text("Cancel"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        );
                                                        final deletesuccessfully =
                                                            await chatop
                                                                .deletebot(
                                                                    botData[
                                                                        "docId"]);
                                                        if (deletesuccessfully) {
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
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  'Bot deletion failed!'),
                                                              backgroundColor:
                                                                  Colors.grey,
                                                            ),
                                                          );
                                                        }
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                      },
                                                      child: const Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                          PopupMenuItem(
                                            value: 4,
                                            child: const ListTile(
                                              title: Text("Go Premium"),
                                              leading: Icon(Icons
                                                  .workspace_premium_outlined),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  // ignore: use_build_context_synchronously
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Vip(),
                                                  ));
                                            },
                                          ),
                                        ],
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
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Chatai(
                                                botname: botData["Bot Name"],
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
                                            child: TextButton(
                                                onPressed: () {
                                                  addpdfs(botData["docId"]);
                                                },
                                                child: const Text(
                                                  "Add PDFs",
                                                )),
                                          ),
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
                                                            color: Colors.grey,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                  final deletionSuccessful =
                                                      await chatop.deletebot(
                                                          botData["docId"]);
                                                  if (deletionSuccessful) {
                                                    // Show a success notification (e.g., Snackbar)
                                                    setState(() {
                                                      fetchData();
                                                    }); // Show loading indicator
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
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Delete the bot',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )),
                                          ),
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
                                trailing: PopupMenuButton(
                                  child: const Icon(Icons.more_vert),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 1,
                                      child: const ListTile(
                                        title: Text("Add PDFs"),
                                        leading: Icon(Icons.add),
                                      ),
                                      onTap: () {
                                        addpdfs(botData["docId"]);
                                      },
                                    ),
                                    PopupMenuItem(
                                      value: 2,
                                      child: const ListTile(
                                        title: Text("Delete AI bot"),
                                        leading: Icon(Icons.delete),
                                      ),
                                      onTap: () async {
                                        return showDialog(
                                          context: context,
                                          barrierDismissible:
                                              false, // Prevent dismissing while loading
                                          builder: (context) => AlertDialog(
                                            title: const Text("Delete AI"),
                                            content: const Text(
                                                "Are you sure you want to delete the AI Bot?"),
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
                                                      await chatop.deletebot(
                                                          botData["docId"]);
                                                  if (deletesuccessfully) {
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
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Bot deletion failed!'),
                                                        backgroundColor:
                                                            Colors.grey,
                                                      ),
                                                    );
                                                  }
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: const Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    PopupMenuItem(
                                      value: 3,
                                      child: const ListTile(
                                        title: Text("Go Premium"),
                                        leading: Icon(
                                            Icons.workspace_premium_outlined),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            // ignore: use_build_context_synchronously
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const Vip(),
                                            ));
                                      },
                                    ),
                                  ],
                                ),
                                horizontalTitleGap: 16,
                                minVerticalPadding: 5,
                                selectedTileColor: Colors.black87,
                                textColor: Colors.black,
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

// add pdfs
  addpdfs(docid) async {
    List<File> files = [];
// pick files
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();

      return showDialog(
        context: context,
        barrierDismissible: false, // Disable user interaction while uploading
        builder: (context) {
          return AlertDialog(
            title: const Text("Selected PDF Files"),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true, // Make the list view wrap its content
                itemCount: files.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(files[index].path.split('/').last),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  ads.AppOpenAdload();
                  showDialog(
                    context: context,
                    barrierDismissible:
                        false, // Disable user interaction while uploading
                    builder: (context) => const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  );
                  CollectionReference insertfilename =
                      FirebaseFirestore.instance.collection('bot');
                  DataEmbedded dataEmbedded = DataEmbedded();
                  final List<String> filenames = [];
                  dataEmbedded.getDocId(docid);
                  for (File file in files) {
                    final fileName =
                        file.path.split('/').last; // Extract file name
                    filenames.add(fileName);
                    await dataEmbedded.pdfextract(file);
                  }
                  await insertfilename.doc(docid).update({
                    'pdfs_name': FieldValue.arrayUnion(filenames),
                  });
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text("ADD"),
              ),
            ],
          );
        },
      );
    }
  }
}
