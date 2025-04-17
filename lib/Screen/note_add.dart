import 'package:flutter/material.dart';
import 'package:learnxt/theme/theme_model.dart';
import 'package:provider/provider.dart';

class NoteAdd extends StatefulWidget {
  const NoteAdd({super.key});

  @override
  State<NoteAdd> createState() => _NoteAddState();
}

class _NoteAddState extends State<NoteAdd> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: 'Content',
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
