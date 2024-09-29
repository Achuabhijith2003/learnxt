import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// ignore: camel_case_types
class admob {
  AppOpenAd? _appOpenAd;
  RewardedAd? _rewardedAd;
  // Appopen ads
  // ignore: non_constant_identifier_names
  AppOpenAdload() {
    AppOpenAd.load(
        adUnitId: "ca-app-pub-8568607330093795/5253465407",
        request: const AdRequest(),
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
// RewardAd
  // ignore: non_constant_identifier_names
  RewardedAdload() {
    RewardedAd.load(
        adUnitId: "ca-app-pub-8568607330093795/5897817876",
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
            _rewardedAd!.show(
              onUserEarnedReward: (ad, reward) {},
            );
          },
          onAdFailedToLoad: (error) {
            debugPrint(error as String);
          },
        ));
  }
}
