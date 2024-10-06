import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BotProfile extends StatefulWidget {
  const BotProfile({super.key});

  @override
  State<BotProfile> createState() => _BotProfileState();
}

class _BotProfileState extends State<BotProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.green.shade900,
          Colors.green.shade800,
          Colors.green.shade400
        ])),
        child: Stack(children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 36, left: 5, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 2.0,
                              color: Color.fromARGB(255, 14, 60, 13),
                            ),
                          ],
                        )),
                    Text(
                      "bot profile",
                      style: GoogleFonts.ptSerif(
                        color: Colors.white,
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                        shadows: <Shadow>[
                          const Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0,
                            color: Color.fromARGB(255, 14, 60, 13),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(),
                    const Divider()
                  ],
                ),
              ),
            ],
          ),
          Positioned(
              top: 100,
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
                child: Stack(children: [
                  FutureBuilder(
                    future: fetch_bot_profile(),
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
                      final profileData = data[0];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 35),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      backgroundColor: Colors.green,
                                      maxRadius: 35,
                                      backgroundImage:
                                          AssetImage("assets/ai pro pic.jpeg"),
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Column(
                                            children: [
                                              Text(
                                                profileData["Name"],
                                                style: GoogleFonts.ptSerif(
                                                  color: Colors.black,
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(profileData["Email"])
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const VerticalDivider(
                                  color: Colors.green,
                                  thickness: 3,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                    left: 50, right: 50, top: 15, bottom: 10),
                                child: Divider(
                                  color: Colors.green,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Card(
                                    color: Colors.green.shade400,
                                    child: const ListTile(
                                      title: Text(
                                        "Logout",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      trailing: Icon(
                                        Icons.logout_outlined,
                                        color: Colors.white,
                                      ),
                                      // onTap: logout,
                                    )),
                              )
                            ],
                          )
                        ],
                      );
                    },
                  ),
                ]),
              ))
        ]),
      ),
      
    );
  }

  // ignore: non_constant_identifier_names

   Future<List<Map<String, dynamic>>> fetch_bot_profile() async {
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
}
