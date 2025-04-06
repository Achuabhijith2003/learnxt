# learnxt

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.













Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40, left: 15),
                          child: Text(
                            "Create Notebook",
                            style: GoogleFonts.dmSerifDisplay(
                                fontSize: 40,
                                letterSpacing: 2,
                                color: themeNotifier.isDark
                                    ? Colors.white
                                    : Colors.grey.shade900),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Profile
                        Padding(
                          padding: const EdgeInsets.only(top: 40, right: 10),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const UserProfile()));
                            },
                            icon: Icon(
                              Icons.account_circle_rounded,
                              color: themeNotifier.isDark
                                  ? Colors.white
                                  : Colors.grey.shade900,
                            ),
                            iconSize: 30,
                          ),
                        )
                      ],
                    ),
