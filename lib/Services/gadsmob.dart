import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// ignore: camel_case_types
class admob {
  AppOpenAd? _appOpenAd;
  // ignore: non_constant_identifier_names
  // Appopen ads
  AppOpenAdload() {
    AppOpenAd.load(
        adUnitId: "ca-app-pub-3940256099942544/9257395921",
        request: AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _appOpenAd = ad;
            _appOpenAd!.show();
          },
          onAdFailedToLoad: (error) {
            debugPrint(error as String);
          },
        ));
  }
}
