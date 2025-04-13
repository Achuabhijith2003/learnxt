// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnxt/Screen/Settings.dart';
import 'package:learnxt/Screen/bot_profile.dart';
import 'package:learnxt/Screen/chatai.dart';
import 'package:learnxt/theme/theme_model.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class Taskbar_chat extends StatefulWidget {
  final String botname;
  final String docId;
  const Taskbar_chat({super.key, required this.botname, required this.docId});

  @override
  State<Taskbar_chat> createState() => Taskbar_chatState();
}

// ignore: camel_case_types
class Taskbar_chatState extends State<Taskbar_chat> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: themeNotifier.isDark ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                widget.botname,
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 30,
                  letterSpacing: 4,
                  color: themeNotifier.isDark
                      ? Colors.white
                      : Colors.grey.shade900,
                ),
              ),
              backgroundColor:
                  themeNotifier.isDark ? Colors.grey.shade900 : Colors.white,
              bottom: TabBar(tabs: [
                Tab(
                  icon: Icon(
                    Icons.person,
                    color: themeNotifier.isDark ? Colors.white : Colors.black,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.chat,
                    color: themeNotifier.isDark ? Colors.white : Colors.black,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.menu_book_rounded,
                    color: themeNotifier.isDark ? Colors.white : Colors.black,
                  ),
                ),
              ]),
            ),
            body: TabBarView(children: [
              const BotProfile(),
              Chatai(botname: widget.botname, docId: widget.docId),
              const UiSettings(),
            ])),
      );
    });
  }
}
