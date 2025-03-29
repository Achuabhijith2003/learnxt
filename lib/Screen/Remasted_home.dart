import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:learnxt/Screen/Settings.dart';
import 'package:learnxt/Screen/aichatadd.dart';
import 'package:learnxt/Screen/home.dart';
import 'package:learnxt/theme/theme_model.dart';
import 'package:provider/provider.dart';

class RemastedHome extends StatefulWidget {
  const RemastedHome({super.key});

  @override
  State<RemastedHome> createState() => _RemastedHomeState();
}

class _RemastedHomeState extends State<RemastedHome> {
  @override
  void initState() {
    super.initState();
    BannerAdload();
  }

  late BannerAd _bannerAd;
  bool isbanneradsload = false;
  BannerAdload() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-8568607330093795/5482884902",
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              isbanneradsload = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            print("Error in ads banner:$error");
          },
        ),
        request: const AdRequest());
    _bannerAd.load();
  }

  int _cureentindex = 0;

  List<Widget> body = const [Home(), Chatcreate(), UiSettings()];
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        body: Center(child: body[_cureentindex]),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomNavigationBar(
              selectedFontSize: 20,
              selectedItemColor: Colors.black,
              enableFeedback: true,
              backgroundColor: Color(
                  int.parse("#f5f3ef".substring(1, 7), radix: 16) + 0xFF000000),
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.chat,
                      // color: Color(
                      //     int.parse("#f5f3ef".substring(1, 7), radix: 16) +
                      //         0xFF000000),
                    ),
                    label: "Chats"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add_circle_outline,
                      // color: Color(
                      //     int.parse("#f5f3ef".substring(1, 7), radix: 16) +
                      //         0xFF000000),
                    ),
                    label: "Create Chats"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.settings,
                      // color: Color(
                      //     int.parse("#f5f3ef".substring(1, 7), radix: 16) +
                      //         0xFF000000),
                    ),
                    label: "Settings"),
              ],
              currentIndex: _cureentindex,
              onTap: (value) {
                setState(() {
                  _cureentindex = value;
                });
              },
            ),
            // Display banner ad if loaded
            if (isbanneradsload)
              SizedBox(
                height: _bannerAd.size.height.toDouble(),
                width: _bannerAd.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd),
              )
          ],
        ),
      );
    });
  }
}
