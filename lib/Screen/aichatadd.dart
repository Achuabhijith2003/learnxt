import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:learnxt/Screen/home.dart';
import 'package:learnxt/Services/Hive/chatid.dart';
import 'package:learnxt/Services/gadsmob.dart';
import '../Services/data_embedded.dart';

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
  final String adUnitId = "ca-app-pub-3940256099942544/2247696110";

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

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    TextEditingController botnamecontroller = TextEditingController();
    return SafeArea(
      child: Scaffold(
        key: _globalKey,
        // backgroundColor: const Color(0xFF171717),
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
                          "Create AI Bot",
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
                        const Divider(),
                        const Divider()
                      ],
                    ),
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
                      color: Color(0xFFEFFFFC),
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
                                left: 20, top: 5, right: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(23),
                                  border: Border.all(color: Colors.white)),
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
                                    color: Colors.white),
                                child: FadeInUp(
                                  duration: const Duration(milliseconds: 1500),
                                  child: TextField(
                                    controller: botnamecontroller,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(
                                        Icons.group_add_outlined,
                                        color: Colors.grey,
                                      ),
                                      hintText: "Name of the bot",
                                      // hintStyle: GoogleFonts.barlowSemiCondensed(
                                      //   fontSize: 16,
                                      // ),
                                      enabled: true,
                                    ),
                                  ),
                                ),
                              ),
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
                                    color: Colors.grey[900],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    // decoration: BoxDecoration(
                                    // ),
                                    child: const Row(
                                      children: [
                                        Text(
                                          "Upload PDFs",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Icon(
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
                                    color: Colors.grey[900],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    // decoration: BoxDecoration(
                                    // ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "Create Bot",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Icon(
                                          Icons.add_chart_outlined,
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
                padding: const EdgeInsets.only(top: 368),
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
    admob ads = admob();
    // rewardads
    ads.RewardedAdload();
    String botName = botNameController.text.trim();

    if (botName.isEmpty) {
      errormessage("Enter a Name to the Bot");
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
        await FirebaseFirestore.instance.collection('Bot').add(botData);
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
          MaterialPageRoute(builder: (context) => const Home()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bot Created sucessfully'),
        ),
      );
    } catch (error) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Dismiss loading screen even on error
      print('Error creating bot: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating bot: $error'),
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
              return ListTile(
                  leading: const Icon(Icons.picture_as_pdf_rounded),
                  title: Text(
                      files[index].path.split('/').last), // Extract file name
                  trailing: Row(
                    mainAxisSize:
                        MainAxisSize.min, // Ensures trailing icons fit
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete_forever_rounded),
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
