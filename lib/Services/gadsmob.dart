import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// ignore: camel_case_types
class admob {
  AppOpenAd? _appOpenAd;
  RewardedAd? _rewardedAd;
  late BannerAd? _bannerAd;
  bool isbanneradsload = false;
  // ignore: non_constant_identifier_names
  // Appopen ads
  AppOpenAdload() {
    AppOpenAd.load(
        adUnitId: "ca-app-pub-3940256099942544/9257395921",
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

  RewardedAdload() {
    RewardedAd.load(
        adUnitId: "ca-app-pub-3940256099942544/5224354917",
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

  BannerAdload() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-3940256099942544/9214589741",
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            isbanneradsload = true;
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: const AdRequest());
    _bannerAd?.load();
  }
}
