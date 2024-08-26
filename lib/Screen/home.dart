import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnxt/Auth/loginpage.dart';
import 'package:learnxt/Screen/ai_chat_section.dart';
import 'package:learnxt/Screen/aichatadd.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = "";
  List<Map<String, dynamic>> data = [];

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    // Chat _chat = Chat();
    // final lastmesss = _chat.lastmessages;
    // String lastmess = "";

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
                            _globalKey.currentState!.openDrawer();
                          },
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.green,
                          )),
                      Center(
                        child: Text(
                          "LearnXT",
                          style: GoogleFonts.ptSerif(
                            color: Colors.green,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // adjacent "LearnXT" text to center
                      const Divider(),
                      const Divider()
                      // IconButton(
                      //     onPressed: () {},
                      //     icon: const Icon(
                      //       Icons.search,
                      //       color: Colors.white,
                      //     )),
                    ],
                  ),
                ),
                // const SizedBox(
                //   width: 35,
                // ),
                Padding(
                    padding: const EdgeInsets.only(
                      left: 42,
                      right: 42,
                    ),
                    child: Card(
                      child: TextField(
                        decoration: const InputDecoration(
                            prefixIconColor: Colors.green,
                            focusColor: Colors.green,
                            suffixIconColor: Colors.green,
                            hoverColor: Colors.green,
                            iconColor: Colors.green,
                            fillColor: Colors.green,
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Search...'),
                        cursorColor: Colors.green,
                        onChanged: (val) {
                          setState(() {
                            name = val;
                          });
                        },
                      ),
                    )),
              ],
            ),
            Positioned(
                top: 145,
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
                  child: FutureBuilder(
                    future: fetchData(), // Initial fetch with limit
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Center(child: Text('Error: ${snapshot.error}')),
                        );
                      }

                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        ); // Show loading indicator
                      }

                      final data = snapshot.data as List<Map<String, dynamic>>;
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final botData = data[index];
                            if (name.isEmpty) {
                              // if (data.isNotEmpty) {
                              //   return const Text("dadfsgsdfgsdgta");
                              // }
                              return Card(
                                color: Colors.green.withAlpha(1000),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AiChat(
                                              botname: botData["Bot Name"],
                                              docId: botData["docId"],
                                            ),
                                          ));
                                    },
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            shadowColor: Colors.green,
                                            title: Text(
                                              botData["Bot Name"],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.green),
                                            ),
                                            // content: const Text("errorMessage"),
                                            actions: [
                                              Center(
                                                //Delete the bot
                                                child: TextButton(
                                                    onPressed: () async {
                                                      final deletionSuccessful =
                                                          await deletebot(
                                                              botData["docId"]);
                                                      if (deletionSuccessful) {
                                                        // Show a success notification (e.g., Snackbar)
                                                        setState(() {
                                                          fetchData();
                                                        });
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                'Bot deleted successfully!'),
                                                            backgroundColor:
                                                                Colors.green,
                                                          ),
                                                        );

                                                        // Potentially refresh the list of bots after successful deletion
                                                      } else {
                                                        // Show an error notification (e.g., Snackbar)
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                'Error deleting bot!'),
                                                            backgroundColor:
                                                                Colors.red,
                                                          ),
                                                        );
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'Delete the bot',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    title: Text(
                                      botData['Bot Name'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ), // Access data for each bot
                                    trailing: const Text(
                                      "lastmess",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                    leading: const CircleAvatar(
                                      radius: 32,
                                      backgroundImage:
                                          AssetImage("assets/ai pro pic.jpeg"),
                                    ),
                                    horizontalTitleGap: 10,
                                    minVerticalPadding: 25,
                                    selectedTileColor: Colors.white,
                                    textColor: Colors.black,
                                  ),
                                ),
                              );
                            }
                            if (botData['Bot Name']
                                .toString()
                                .toLowerCase()
                                .startsWith(name.toLowerCase())) {
                              return Card(
                                color: Colors.green.shade300,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AiChat(
                                              botname: botData["Bot Name"],
                                              docId: botData["docId"],
                                            ),
                                          ));
                                    },
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              botData["Bot Name"],
                                              textAlign: TextAlign.center,
                                            ),
                                            // content: const Text("errorMessage"),
                                            actions: [
                                              Center(
                                                //Delete the bot
                                                child: TextButton(
                                                    onPressed: () async {
                                                      final deletionSuccessful =
                                                          await deletebot(
                                                              botData["docId"]);
                                                      if (deletionSuccessful) {
                                                        // Show a success notification (e.g., Snackbar)
                                                        setState(() {
                                                          fetchData();
                                                        });
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                'Bot deleted successfully!'),
                                                            backgroundColor:
                                                                Colors.green,
                                                          ),
                                                        );

                                                        // Potentially refresh the list of bots after successful deletion
                                                      } else {
                                                        // Show an error notification (e.g., Snackbar)
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                'Error deleting bot!'),
                                                            backgroundColor:
                                                                Colors.red,
                                                          ),
                                                        );
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'Delete the bot',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    title: Text(
                                      botData['Bot Name'],
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ), // Access data for each bot
                                    trailing: const Text("data"),
                                    leading: const CircleAvatar(
                                      radius: 32,
                                      backgroundImage:
                                          AssetImage("assets/ai pro pic.jpeg"),
                                    ),
                                    horizontalTitleGap: 10,
                                    minVerticalPadding: 25,
                                    selectedTileColor: Colors.white,
                                    textColor: Colors.black,
                                  ),
                                ),
                              );
                              // Add a "Load More" button or implement infinite scrolling if needed
                            }
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 150),
                                child: Text("No Result"),
                              ),
                            );
                          });
                    },
                  ),
                ))
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          backgroundColor: Colors.green.shade600,
          child: const Icon(
            Icons.add_box_outlined,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Chatcreate(),
                ));
          },
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

  Column buildConversationRow(
      String name, String message, String filename, int msgCount) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                UserAvatar(filename: filename),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      message,
                      style:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25, top: 5),
              child: Column(
                children: [
                  const Text(
                    '16:35',
                    style: TextStyle(fontSize: 10),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (msgCount > 0)
                    CircleAvatar(
                      radius: 7,
                      backgroundColor: const Color.fromARGB(255, 30, 177, 30),
                      child: Text(
                        msgCount.toString(),
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
        const Divider(
          indent: 70,
          height: 20,
        )
      ],
    );
  }

  Padding buildContactAvatar(String name, String filename) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Column(
        children: [
          UserAvatar(
            filename: filename,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          )
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    // ... your existing fetchData logic ...
    final user = FirebaseAuth.instance.currentUser;
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('Bot');

    final query =
        collection.where('UID', isEqualTo: user?.uid); // Example condition

    final querySnapshot = await query.get();
    final data = querySnapshot.docs.map((doc) => doc.data()).toList();
    // Access data as a list of Maps
    // print(data);
    //
    return data; // Return the retrieved data list
  }

// here two times calling docId 1. passing the doc ID 2. Finding through firebase instance
// in future try to remove Ok!
  Future<bool> deletebot(String docId) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('Bot').doc(docId);
      await docRef.delete();
      return true; // Deletion successful
    } catch (error) {
      return false; // Deletion failed
    }
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  const DrawerItem({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(
              width: 40,
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final String filename;
  const UserAvatar({
    super.key,
    required this.filename,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 32,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 29,
        backgroundImage: Image.asset('assets/images/$filename').image,
      ),
    );
  }
}
