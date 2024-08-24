import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:learnxt/Auth/loginpage.dart';
import 'package:learnxt/Screen/home.dart';
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
        decoration: const BoxDecoration(color: Color(0xFFEFFFFC)),
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
                            color: Colors.green,
                          )),
                      const Text("Create AI bot",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 40,
                              fontWeight: FontWeight.bold)),
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
                      FadeInUp(
                        duration: const Duration(milliseconds: 1600),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 5, right: 20),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(23),
                                border: Border.all(color: Colors.green)),
                            child: TextField(
                              controller: botnamecontroller,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                hintText: "AI Bot Name",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 5, right: 20),
                            child: MaterialButton(
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
                              child: const Center(
                                child: Text(
                                  "Upload PDF",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                      FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 5, right: 20),
                            child: MaterialButton(
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
                              child: const Center(
                                child: Text(
                                  "Create Bot",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                      const Divider(),
                      // displaypdf()
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 315),
              child: displaypdf(),
            )
          ],
        ),
      ),
      drawer: Drawer(
        width: 275,
        elevation: 30,
        backgroundColor: Colors.green.shade400,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(right: Radius.circular(40))),
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.horizontal(right: Radius.circular(40)),
              boxShadow: [
                BoxShadow(
                    color: Color(0x3D000000), spreadRadius: 30, blurRadius: 20)
              ]),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  children: [
                    Row(
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
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        UserAvatar(filename: 'img3.jpeg'),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'Tom Brenan',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    DrawerItem(
                      title: 'Account',
                      icon: Icons.key,
                    ),
                    DrawerItem(title: 'Chats', icon: Icons.chat_bubble),
                    DrawerItem(
                        title: 'Notifications', icon: Icons.notifications),
                    DrawerItem(title: 'Data and Storage', icon: Icons.storage),
                    DrawerItem(title: 'Help', icon: Icons.help),
                    Divider(
                      height: 35,
                      color: Colors.green,
                    ),
                    DrawerItem(
                      title: 'Invite a friend',
                      icon: Icons.people_outline,
                    ),
                  ],
                ),
                DrawerItem(
                  title: 'Log out',
                  icon: Icons.logout,
                  onTap: logout,
                )
              ],
            ),
          ),
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
    String botName = botNameController.text.trim();

    if (botName.isEmpty) {
      return; // Handle empty bot name
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle case where user is not logged in
      return;
    }

    String uid = user.uid;

    final storageRef = FirebaseStorage.instance.ref();
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
    final docRef = await FirebaseFirestore.instance.collection('Bot').add(botData);
    final docId = docRef.id;
    // Update the document with the docId
    await docRef.update({'docId': docId});
    // Update the document with the docId
          // passing parectDocId of the Bot
      _dataEmbedded.getDocId(docId);
    try {
      // Upload each file to Firebase Storage
      for (File file in files) {
        final fileName = file.path.split('/').last; // Extract file name
        final uploadTask = storageRef.child('PDFs/$fileName').putFile(file);
        final snapshot = await uploadTask.whenComplete(() => {});
        final downloadUrl = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
        await _dataEmbedded.pdfextract(file, downloadUrl);
      }

      // Store bot pdfurl in Firestore
      final pdfurl = {
        'PDFs': downloadUrls,
      };
      await docRef.update(pdfurl);
      // Handle successful creation (e.g., show success message)
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
}
