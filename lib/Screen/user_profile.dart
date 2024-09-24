import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

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
                      "Profile",
                      style: GoogleFonts.ptSerif(
                        color: Colors.white,
                        fontSize: 40,
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
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.green,
                                    maxRadius: 55,
                                    backgroundImage:
                                        AssetImage("assets/ai pro pic.jpeg"),
                                  ),
                                  Text(
                                    "Abhijith JR",
                                    style: GoogleFonts.ptSerif(
                                      color: Colors.black,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      shadows: <Shadow>[
                                        const Shadow(
                                          offset: Offset(1.0, 1.0),
                                          blurRadius: 2.0,
                                          color:
                                              Color.fromARGB(255, 14, 60, 13),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const VerticalDivider(
                            color: Colors.green,
                            thickness: 3,
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Email: jrabhijithktd@gmail.com",
                                    style: GoogleFonts.ptSerif(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      shadows: <Shadow>[
                                        const Shadow(
                                          offset: Offset(1.0, 1.0),
                                          blurRadius: 2.0,
                                          color:
                                              Color.fromARGB(255, 14, 60, 13),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Email: jrabhijithktd@gmail.com",
                                    style: GoogleFonts.ptSerif(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      shadows: <Shadow>[
                                        const Shadow(
                                          offset: Offset(1.0, 1.0),
                                          blurRadius: 2.0,
                                          color:
                                              Color.fromARGB(255, 14, 60, 13),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Email: jrabhijithktd@gmail.com",
                                    style: GoogleFonts.ptSerif(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      shadows: <Shadow>[
                                        const Shadow(
                                          offset: Offset(1.0, 1.0),
                                          blurRadius: 2.0,
                                          color:
                                              Color.fromARGB(255, 14, 60, 13),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Email: jrabhijithktd@gmail.com",
                                    style: GoogleFonts.ptSerif(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      shadows: <Shadow>[
                                        const Shadow(
                                          offset: Offset(1.0, 1.0),
                                          blurRadius: 2.0,
                                          color:
                                              Color.fromARGB(255, 14, 60, 13),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Email: jrabhijithktd@gmail.com",
                                    style: GoogleFonts.ptSerif(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      shadows: <Shadow>[
                                        const Shadow(
                                          offset: Offset(1.0, 1.0),
                                          blurRadius: 2.0,
                                          color:
                                              Color.fromARGB(255, 14, 60, 13),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 50, right: 50, top: 15, bottom: 10),
                            child: Divider(
                              color: Colors.green,
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.green,
                          )
                        ],
                      )
                    ],
                  ),
                ]),
              ))
        ]),
      ),
    );
  }
}
