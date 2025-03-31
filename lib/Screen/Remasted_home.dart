import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
        adUnitId: "", //ca-app-pub-8568607330093795/5482884902
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
        backgroundColor:
            themeNotifier.isDark ? Colors.grey.shade900 : Colors.white,
        body: Center(child: body[_cureentindex]),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              color: themeNotifier.isDark ? Colors.grey.shade900 : Colors.white,
            ),
            CurvedNavigationBar(
              index: 0,
              items: <Widget>[
                Icon(
                  Icons.chat,
                  size: 30,
                  color: themeNotifier.isDark
                      ? Colors.grey.shade900
                      : Colors.white,
                ),
                Icon(
                  Icons.add_circle_outline,
                  size: 30,
                  color: themeNotifier.isDark
                      ? Colors.grey.shade900
                      : Colors.white,
                ),
                Icon(
                  Icons.settings,
                  size: 30,
                  color: themeNotifier.isDark
                      ? Colors.grey.shade900
                      : Colors.white,
                ),
              ],
              color: themeNotifier.isDark ? Colors.grey : Colors.grey.shade700,
              buttonBackgroundColor:
                  themeNotifier.isDark ? Colors.white : Colors.grey,
              backgroundColor:
                  themeNotifier.isDark ? Colors.grey.shade900 : Colors.white,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 600),
              onTap: (index) {
                setState(() {
                  _cureentindex = index;
                });
              },
              letIndexChange: (index) => true,
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
