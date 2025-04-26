import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnxt/Screen/Preminum/vip.dart';
import 'package:learnxt/Services/AI/data_embedded.dart';
import 'package:learnxt/Services/Chats/Chat_Operations.dart';
import 'package:learnxt/Services/Hive/chat.dart';
import 'package:learnxt/Services/Hive/chatid.dart';
import 'package:learnxt/Services/gadsmob.dart';

import 'package:learnxt/theme/theme_model.dart';
import 'package:provider/provider.dart';

class BotProfile extends StatefulWidget {
  final String docId;
  const BotProfile({super.key, required this.docId});

  @override
  State<BotProfile> createState() => _BotProfileState();
}

class _BotProfileState extends State<BotProfile> {
  TextEditingController nameController = TextEditingController();

  admob ads = admob();

  Chatputandget chatstore = Chatputandget();
  Chatidputandget chatid = Chatidputandget();
  ChatOperations chatop = ChatOperations();

  bool istextfieldenabled = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        backgroundColor:
            themeNotifier.isDark ? Colors.grey.shade900 : Colors.white,
        body: FutureBuilder(
          future: fetch_bot_profile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No data found"),
              );
            } else {
              final data = snapshot.data!;
              nameController.text = data[0]['Bot Name'] ?? "No name found";
              // Process and display the data as needed
              return Column(children: [
                Text("Notebook info",
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: themeNotifier.isDark
                            ? Colors.white
                            : Colors.black)),
                const Divider(
                  indent: 20,
                  endIndent: 20,
                  thickness: 2,
                ),
                // Text("data"),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(color: Colors.grey.shade200),
                            top: BorderSide(color: Colors.grey.shade200),
                            left: BorderSide(color: Colors.grey.shade200),
                            bottom: BorderSide(color: Colors.grey.shade200))),
                    child: TextField(
                      controller: nameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: "Notebook name",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none),
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color:
                            themeNotifier.isDark ? Colors.white : Colors.black,
                      ),
                      enabled: istextfieldenabled,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        istextfieldenabled = !istextfieldenabled;
                      });
                      if (!istextfieldenabled) {
                        edit_bot_profile();
                      }
                    },
                    height: 50,
                    // margin: EdgeInsets.symmetric(horizontal: 50),
                    color: themeNotifier.isDark
                        ? Colors.white54
                        : Colors.grey.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    // decoration: BoxDecoration(
                    // ),
                    child: Center(
                      child: istextfieldenabled
                          ? Text(
                              "Save",
                              style: TextStyle(
                                  color: themeNotifier.isDark
                                      ? Colors.grey.shade900
                                      : Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              "Edit",
                              style: TextStyle(
                                  color: themeNotifier.isDark
                                      ? Colors.grey.shade900
                                      : Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sources",
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: themeNotifier.isDark
                                ? Colors.white
                                : Colors.black)),
                    ...(data[0]['pdfs_name'] as List<dynamic>?)
                            ?.map((pdfName) => Text(
                                  "📁 $pdfName",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: themeNotifier.isDark
                                          ? Colors.white70
                                          : Colors.black87),
                                ))
                            .toList() ??
                        [const Text("No sources found")],
                  ],
                ),
                const Divider(
                  indent: 20,
                  endIndent: 20,
                  thickness: 2,
                ),
                Text("Options",
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: themeNotifier.isDark
                            ? Colors.white
                            : Colors.black)),
                const Divider(
                  indent: 20,
                  endIndent: 20,
                  thickness: 2,
                ),
                ListTile(
                  leading: Icon(
                    Icons.upload_file,
                    color: themeNotifier.isDark ? Colors.white : Colors.black,
                  ),
                  title: Text("Add PDFs",
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: themeNotifier.isDark
                              ? Colors.white
                              : Colors.black)),
                  onTap: () {
                    addpdfs(widget.docId);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.clear_all_sharp,
                    color: themeNotifier.isDark ? Colors.white : Colors.black,
                  ),
                  title: Text("Clear Chats",
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: themeNotifier.isDark
                              ? Colors.white
                              : Colors.black)),
                  onTap: () async {
                    return showDialog(
                      context: context,
                      barrierDismissible:
                          false, // Prevent dismissing while loading
                      builder: (context) => AlertDialog(
                        title: const Text("Clear chats"),
                        content:
                            const Text("Are you sure you want to Clear Chats?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) => const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.grey,
                                  ),
                                ),
                              );

                              final clearsucessfully =
                                  chatstore.clearchat(widget.docId);

                              if (clearsucessfully) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Chats cleared successfully!'),
                                    backgroundColor: Colors.grey,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Chats cleared failed!'),
                                    backgroundColor: Colors.grey,
                                  ),
                                );
                              }
                              Navigator.of(context).pop(); // Close the dialog
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text(
                              "clear",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: themeNotifier.isDark ? Colors.white : Colors.black,
                  ),
                  title: Text("Delete Notebook",
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: themeNotifier.isDark
                              ? Colors.white
                              : Colors.black)),
                  onTap: () async {
                    return showDialog(
                      context: context,
                      barrierDismissible:
                          true, // Prevent dismissing while loading
                      builder: (context) => AlertDialog(
                        title: const Text("Delete Notebook"),
                        content: const Text(
                            "Are you sure you want to delete the Notebook?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) => const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                              // ads.AppOpenAdload();
                              final deletesuccessfully =
                                  await chatop.deletebot(widget.docId);

                              if (deletesuccessfully) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Notebook deleted successfully!'),
                                    backgroundColor: Colors.grey,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Notebook deletion failed!'),
                                    backgroundColor: Colors.grey,
                                  ),
                                );
                              }
                              Navigator.of(context).pop(); // Close the dialog
                              Navigator.of(context).pop(); // Close the dialog
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.workspace_premium_outlined,
                    color: themeNotifier.isDark ? Colors.white : Colors.black,
                  ),
                  title: Text("Go Premium",
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: themeNotifier.isDark
                              ? Colors.white
                              : Colors.black)),
                  onTap: () {
                    Navigator.push(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Vip(),
                        ));
                  },
                )
              ]);
            }
          },
        ),
      );
    });
  }

  // ignore: non_constant_identifier_names
  Future<List<Map<String, dynamic>>> fetch_bot_profile() async {
    // ... your existing fetchData logic ...
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('bot');

    final query =
        collection.where('docId', isEqualTo: widget.docId); // Example condition

    final querySnapshot = await query.get();
    final data = querySnapshot.docs.map((doc) => doc.data()).toList();
    // Access data as a list of Maps
    // print(data);
    //
    return data; // Return the retrieved data list
  }

  edit_bot_profile() {
    // Save the updated name to Firestore
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('bot');
    collection.doc(widget.docId).update({
      'Bot Name': nameController.text,
    }).then((_) {
      print("Name updated successfully!");
    }).catchError((error) {
      print("Failed to update name: $error");
    });
  }

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
                  // ads.AppOpenAdload();
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
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(); // Close the dialog
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  // ignore: use_build_context_synchronously
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
