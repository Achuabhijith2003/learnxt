import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:learnxt/Screen/home.dart';

class Chatcreate extends StatefulWidget {
  const Chatcreate({super.key});

  @override
  State<Chatcreate> createState() => _ChatcreateState();
}

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
                  padding: const EdgeInsets.only(top: 70, left: 5, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            _globalKey.currentState!.openDrawer();
                          },
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                          )),
                      const Text("Create AI bot",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 35,
                )
              ],
            ),
            Positioned(
                top: 185,
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
                          child: TextField(
                            controller: botnamecontroller,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                                hintText: "AI Bot Name",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
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
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  allowMultiple: true,
                                  type: FileType.custom,
                                  allowedExtensions: [ 'pdf'],
                                );

                                if (result != null) {
                                  List<File> files = result.paths
                                      .map((path) => File(path!))
                                      .toList();
                                } else {
                                  // User canceled the picker
                                }
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
                                createbot(botnamecontroller);
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
                      // ListView(children: const [
                      //   SizedBox(
                      //     height: 10,
                      //   ),
                      // ],)
                    ],
                  ),
                ))
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
          child: const Padding(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                        title: 'Invite a friend', icon: Icons.people_outline),
                  ],
                ),
                DrawerItem(
                  title: 'Log out',
                  icon: Icons.logout,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  createbot(TextEditingController botnamecontroller) {}
}
