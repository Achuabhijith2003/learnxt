import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:learnxt/Screen/Remasted_home.dart';
import 'package:learnxt/Screen/user_profile.dart';
import 'package:learnxt/Services/Chats/Chat_Operations.dart';
import 'package:learnxt/Services/Hive/chatid.dart';
import 'package:learnxt/Services/gadsmob.dart';
import '../Services/AI/data_embedded.dart';

import 'package:learnxt/theme/theme_model.dart';
import 'package:provider/provider.dart';

class Chatcreate extends StatefulWidget {
  const Chatcreate({super.key});

  @override
  State<Chatcreate> createState() => _ChatcreateState();
}

admob ad = admob();
DataEmbedded _dataEmbedded = DataEmbedded();

class _ChatcreateState extends State<Chatcreate> {
  @override
  void initState() {
    super.initState();
    BannerAdload();
    nativeadvancedadloader();
  }

// banner_ads
  late BannerAd _bannerAd;
  bool isbanneradsload = false;
  // ignore: non_constant_identifier_names
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

  // native_ads
  late NativeAd nativeAd;
  bool isNativeAdAdLoaded = false;
  final String adUnitId = ""; //ca-app-pub-8568607330093795/3077653778

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

  ChatOperations chatop = ChatOperations();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    TextEditingController botnamecontroller = TextEditingController();
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor:
              themeNotifier.isDark ? Colors.grey.shade900 : Colors.white,
          key: _globalKey,
          // backgroundColor: const Color(0xFF171717),
          body: SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40, left: 15),
                          child: Text(
                            "Create Notebook",
                            style: GoogleFonts.dmSerifDisplay(
                                fontSize: 40,
                                letterSpacing: 2,
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
                                return const CircleAvatar(
                                  child: CircularProgressIndicator(),
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
                                      backgroundImage: imageUrl != null &&
                                              imageUrl.isNotEmpty
                                          ? NetworkImage(imageUrl)
                                          : null,
                                      //  child: imageUrl == null || imageUrl.isEmpty
                                      //     ? const Icon(Icons.person)
                                      //     : null, //Removed const
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
                    const SizedBox(
                      width: 35,
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
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          FadeIn(
                            duration: const Duration(milliseconds: 1600),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, top: 5, right: 15),
                              child: SearchBar(
                                controller: botnamecontroller,
                                hintText: 'Notebook Name',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          FadeIn(
                              duration: const Duration(milliseconds: 1600),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 5, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    MaterialButton(
                                      onPressed: () async {
                                        uploadPdf();
                                      },
                                      height: 50,
                                      // margin: EdgeInsets.symmetric(horizontal: 50),
                                      color: Colors.grey[800],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      // decoration: BoxDecoration(
                                      // ),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Upload PDFs ",
                                            style: TextStyle(
                                                color: themeNotifier.isDark
                                                    ? Colors.white
                                                    : Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Icon(
                                            Icons.upload_file,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        createBot(botnamecontroller);
                                      },
                                      height: 50,
                                      // margin: EdgeInsets.symmetric(horizontal: 50),
                                      color: Colors.grey[800],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      // decoration: BoxDecoration(
                                      // ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "Create Notebook ",
                                            style: TextStyle(
                                                color: themeNotifier.isDark
                                                    ? Colors.white
                                                    : Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Icon(
                                            Icons.menu_book_rounded,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          // const Divider(),
                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 258),
                  child: isNativeAdAdLoaded
                      ? SizedBox(
                          child: AdWidget(ad: nativeAd),
                        )
                      : const SizedBox(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 290),
                  child: displaypdf(),
                )
              ],
            ),
          ),
          bottomNavigationBar: isbanneradsload
              ? SizedBox(
                  height: _bannerAd.size.height.toDouble(),
                  width: _bannerAd.size.width.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                )
              : const SizedBox(),
        ),
      );
    });
  }

  List<File> files = [];
  String pdfName = ''; // Corrected variable name for clarity

  Future<void> uploadPdf() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        this.files = files;
      });
    }
  }

  void createBot(TextEditingController botNameController) async {
    // admob ads = admob();
    // rewardads
    // ads.RewardedAdload();
    String botName = botNameController.text.trim();

    if (botName.isEmpty) {
      errormessage("Enter a Name to the Notebook!");
      return; // Handle empty bot name
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle case where user is not logged in
      return;
    }

    String uid = user.uid;

    // final storageRef = FirebaseStorage.instance.ref();
    final List<String> filenames = [];

    showDialog(
      context: context,
      barrierDismissible: false, // Disable user interaction while uploading
      builder: (context) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.grey,
            ),
            SizedBox(height: 16), // Add spacing between indicator and text
            // Text(
            //   "Processing...",
            //   style: TextStyle(
            //       fontSize: 25,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.grey),
            // ),
          ],
        ),
      ),
    );
    // store pdf file
    final botData = {
      'UID': uid,
      'Bot Name': botName,
    };
    final docRef =
        await FirebaseFirestore.instance.collection('bot').add(botData);
    final docId = docRef.id;
    // Update the document with the docId
    await docRef.update({'docId': docId});
    // Update the document with the docId
    // passing parectDocId of the Bot
    _dataEmbedded.getDocId(docId);

    try {
      // Upload each file to Firebase Storage
      // now puesed
      for (File file in files) {
        final fileName = file.path.split('/').last; // Extract file name
        filenames.add(fileName);
        // final uploadTask = storageRef.child('PDFs/$fileName').putFile(file);
        // final snapshot = await uploadTask.whenComplete(() => {});
        // final downloadUrl = await snapshot.ref.getDownloadURL();
        // downloadUrls.add(downloadUrl);
        await _dataEmbedded.pdfextract(file);
      }

      // Store bot pdfname in Firestore
      final pdfname = {
        'pdfs_name': filenames,
      };
      await docRef.update(pdfname);
      // Handle successful creation (e.g., show success message)
      Chatidputandget chatidput = Chatidputandget();
      chatidput.putid(0, docId);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const RemastedHome()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notebook Created sucessfully'),
        ),
      );
    } catch (error) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Dismiss loading screen even on error
      print('Error creating Notebook: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating Notebook: $error'),
        ),
      );
      // Handle errors appropriately (e.g., show error message)
    }
  }

  displaypdf() {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade400)),
        padding: const EdgeInsets.only(left: 20, top: 5, right: 20),
        child: ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              return Consumer<ThemeModel>(
                  builder: (context, ThemeModel themeNotifier, child) {
                return ListTile(
                    leading: Icon(
                      Icons.picture_as_pdf_rounded,
                      color: themeNotifier.isDark
                          ? Colors.white
                          : Colors.grey.shade900,
                    ),
                    title: Text(
                      files[index].path.split('/').last,
                      style: TextStyle(
                        color: themeNotifier.isDark
                            ? Colors.white
                            : Colors.grey.shade900,
                      ),
                    ), // Extract file name
                    trailing: Row(
                      mainAxisSize:
                          MainAxisSize.min, // Ensures trailing icons fit
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete_forever_rounded,
                            color: themeNotifier.isDark
                                ? Colors.white
                                : Colors.grey.shade900,
                          ),
                          onPressed: () {
                            // Handle potential errors during deletion
                            try {
                              setState(() {
                                files.removeAt(
                                    index); // More efficient for large lists
                              });
                            } catch (error) {
                              // Show a snackbar or other error notification
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error deleting file: $error'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      // Optional: Handle tap action on the entire ListTile
                    });
              });
            }));
  }

  void errormessage(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error!'),
          content: Text(errorMessage),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Okay'))
          ],
        );
      },
    );
  }
}
