import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnxt/Screen/Preminum/vip.dart';
import 'package:learnxt/Screen/chatai.dart';
import 'package:learnxt/Services/Chats/Chat_Operations.dart';
import 'package:learnxt/Services/gadsmob.dart';
import 'package:learnxt/theme/theme_model.dart';
import 'package:provider/provider.dart';

import '../../Services/AI/data_embedded.dart';

admob ads = admob();
ChatOperations chatop = ChatOperations();

class Materialcoures extends StatefulWidget {
  final Map<String, dynamic> botData;
  const Materialcoures({super.key, required this.botData});

  @override
  State<Materialcoures> createState() => _MaterialcouresState();
}

class _MaterialcouresState extends State<Materialcoures> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return GestureDetector(
        onTap: () => Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => Chatai(
                  botname: widget.botData["Bot Name"],
                  docId: widget.botData["docId"]),
            )),
        child: Container(
          color: themeNotifier.isDark ? Colors.grey : Colors.grey.shade500,
          height: 145,
          width: 500,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 310, top: 15),
                child: PopupMenuButton(
                  iconColor: themeNotifier.isDark
                      ? Colors.white
                      : Colors.grey.shade900,
                  color: themeNotifier.isDark
                      ? Colors.grey.shade900
                      : Colors.white,
                  child: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: ListTile(
                        title: Text(
                          "Add PDFs",
                          style: TextStyle(
                              color: themeNotifier.isDark
                                  ? Colors.white
                                  : Colors.grey.shade900),
                        ),
                        leading: Icon(
                          Icons.add,
                          color: themeNotifier.isDark
                              ? Colors.white
                              : Colors.grey.shade900,
                        ),
                      ),
                      onTap: () {
                        addpdfs(widget.botData["docId"]);
                      },
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: ListTile(
                        title: Text(
                          "Delete Notebook",
                          style: TextStyle(
                              color: themeNotifier.isDark
                                  ? Colors.white
                                  : Colors.grey.shade900),
                        ),
                        leading: Icon(
                          Icons.delete,
                          color: themeNotifier.isDark
                              ? Colors.white
                              : Colors.grey.shade900,
                        ),
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
                              "Delete Notebook",
                              style: TextStyle(
                                  color: themeNotifier.isDark
                                      ? Colors.white
                                      : Colors.grey.shade900),
                            ),
                            content: Text(
                              "Are you sure you want to delete the Notebook?",
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
                                    builder: (context) => const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                  final deletesuccessfully = await chatop
                                      .deletebot(widget.botData["docId"]);
                                  if (deletesuccessfully) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Notebook deleted successfully!'),
                                        backgroundColor: Colors.grey,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Notebook deletion failed!'),
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
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: ListTile(
                        title: Text(
                          "Go Premium",
                          style: TextStyle(
                              color: themeNotifier.isDark
                                  ? Colors.white
                                  : Colors.grey.shade900),
                        ),
                        leading: Icon(
                          Icons.workspace_premium_outlined,
                          color: themeNotifier.isDark
                              ? Colors.white
                              : Colors.grey.shade900,
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
                    )
                  ],
                ),
              ),
              Text(
                widget.botData["Bot Name"],
                style: GoogleFonts.dmSerifDisplay(
                    fontSize: 30,
                    color: themeNotifier.isDark ? Colors.white : Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                _getPdfsNameCount(
                    widget.botData["pdfs_name"]), // Call a helper function
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 15,
                  color: themeNotifier.isDark ? Colors.white : Colors.white,
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  String _getPdfsNameCount(dynamic pdfsNameData) {
    if (pdfsNameData is List) {
      return "${pdfsNameData.length} Sources"; // Display the count
    } else {
      return "0 Sources"; // Or handle the case where it's not a list
    }
  }

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
                  // Navigator.of(context).pop();
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
