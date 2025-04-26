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

Notes notes = Notes();

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    notes.parentdocid = widget.parentdocid;
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return FutureBuilder(
        future: notes.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading notes'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notes available'));
          } else {
            final notes = snapshot.data!.docs;
            return Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
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
