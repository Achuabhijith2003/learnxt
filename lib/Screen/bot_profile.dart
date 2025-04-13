import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
              return const  Center(
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
                const Divider(
                  indent: 20,
                  endIndent: 20,
                  thickness: 2,
                ),
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
}
