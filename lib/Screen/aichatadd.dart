import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnxt/Auth/loginpage.dart';
import 'package:learnxt/Screen/home.dart';
import 'package:learnxt/Services/Hive/chatid.dart';
import 'package:learnxt/Services/gadsmob.dart';
import '../Services/data_embedded.dart';

class Chatcreate extends StatefulWidget {
  const Chatcreate({super.key});

  @override
  State<Chatcreate> createState() => _ChatcreateState();
}

DataEmbedded _dataEmbedded = DataEmbedded();

class _ChatcreateState extends State<Chatcreate> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    TextEditingController botnamecontroller = TextEditingController();
    return Scaffold(
      key: _globalKey,
      // backgroundColor: const Color(0xFF171717),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.green.shade900,
          Colors.green.shade800,
          Colors.green.shade400
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
                                      color: Colors.green,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                MaterialButton(
                                  onPressed: () async {
                                    uploadPdf();
                                  },
                                  height: 50,
                                  // margin: EdgeInsets.symmetric(horizontal: 50),
                                  color: Colors.green[900],
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
                                  color: Colors.green[900],
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
              child: displaypdf(),
            )
          ],
        ),
      ),
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
    // Appopenadd
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
    final List<String> downloadUrls = [];

    showDialog(
      context: context,
      barrierDismissible: false, // Disable user interaction while uploading
      builder: (context) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.greenAccent,
            ),
            SizedBox(height: 16), // Add spacing between indicator and text
            Text(
              "Processing...",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
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
        // final fileName = file.path.split('/').last; // Extract file name
        // final uploadTask = storageRef.child('PDFs/$fileName').putFile(file);
        // final snapshot = await uploadTask.whenComplete(() => {});
        // final downloadUrl = await snapshot.ref.getDownloadURL();
        // downloadUrls.add(downloadUrl);
        await _dataEmbedded.pdfextract(file);
      }

      // Store bot pdfurl in Firestore
      final pdfurl = {
        'PDFs': downloadUrls,
      };
      await docRef.update(pdfurl);
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
            border: Border.all(color: Colors.green.shade400)),
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
