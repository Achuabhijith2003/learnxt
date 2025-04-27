import 'package:flutter/material.dart';
import 'package:learnxt/Services/Chats/notes.dart';
import 'package:learnxt/theme/theme_model.dart';
import 'package:provider/provider.dart';

class NoteView extends StatefulWidget {
  final String? parentdocid;
  const NoteView({super.key, required this.parentdocid});

  @override
  State<NoteView> createState() => _NoteViewState();
}

Notes noteobj = Notes();

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    noteobj.parentdocid = widget.parentdocid;
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return FutureBuilder(
        future: noteobj.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              'Error loading notes',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color:
                    themeNotifier.isDark ? Colors.white : Colors.grey.shade900,
              ),
            ));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Column(
              children: [
                Text(
                  'No notes available',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: themeNotifier.isDark
                        ? Colors.white
                        : Colors.grey.shade900,
                  ),
                ),
              ],
            );
          } else {
            final notes = snapshot.data!.docs;
            return Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        // Handle note tap if needed
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => AlertDialog(
                            title: const Center(child: Text("Options")),
                            actions: [
                              Column(
                                children: [
                                  Center(
                                    child: TextButton(
                                      onPressed: () async {
                                        bool isdeletednote = await noteobj
                                            .deleteNotes(note['notedocid']);
                                        if (isdeletednote) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text("Note Deleted"),
                                            ),
                                          );
                                          setState(() {});
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text("Note Not Deleted"),
                                            ),
                                          );
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Delete Notes ❌",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: themeNotifier.isDark
                                ? [Colors.black, Colors.grey[850]!]
                                : [Colors.white, Colors.grey[200]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            width: 2,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Question: ${note['Question']}",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: themeNotifier.isDark
                                      ? Colors.white
                                      : Colors.grey.shade900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Answer: ${note['Answer']}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: themeNotifier.isDark
                                      ? Colors.white
                                      : Colors.grey.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      );
    });
  }
}
