import 'package:flutter/material.dart';
import 'package:learnxt/Screen/compoments/note_view.dart';
import 'package:learnxt/theme/theme_model.dart';
import 'package:provider/provider.dart';

class NoteAdd extends StatefulWidget {
  final String? parentdocid;
  const NoteAdd({super.key, required this.parentdocid});

  @override
  State<NoteAdd> createState() => _NoteAddState();
}

class _NoteAddState extends State<NoteAdd> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        backgroundColor:
            themeNotifier.isDark ? Colors.grey.shade900 : Colors.white,
        body: Column(
          children: [
            Center(
              child: Text(
                'Notes',
                style: TextStyle(
                  fontSize: 24,
                  color: themeNotifier.isDark
                      ? Colors.white
                      : Colors.grey.shade900,
                ),
              ),
            ),
            NoteView(parentdocid: widget.parentdocid,)
          ],
        ),
      );
    });
  }
}
