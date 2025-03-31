import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// ignore: camel_case_types
class admob {
  AppOpenAd? _appOpenAd;
  RewardedAd? _rewardedAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;

  // Appopen ads
  // ignore: non_constant_identifier_names
  AppOpenAdload() {
    AppOpenAd.load(
        adUnitId: "", //ca-app-pub-8568607330093795/5253465407
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
        adUnitId: "", //ca-app-pub-8568607330093795/5897817876
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

  // RewardedInterstitialAd load
  // ignore: non_constant_identifier_names
  // RewardedInterstitialAdload() {
  //   RewardedAd.load(
  //       adUnitId: "ca-app-pub-8568607330093795/7490088802",
  //       request: const AdRequest(),
  //       rewardedAdLoadCallback: RewardedAdLoadCallback(
  //         onAdLoaded: (ad) {
  //           _rewardedInterstitialAd = ad as RewardedInterstitialAd? ;
  //           _rewardedInterstitialAd!.show(
  //             onUserEarnedReward: (ad, reward) {},
  //           );
  //         },
  //         onAdFailedToLoad: (error) {
  //           debugPrint(error as String);
  //         },
  //       ));
  // }

  void RewardedInterstitialAdload() {
    RewardedInterstitialAd.load(
      adUnitId: "", //ca-app-pub-8568607330093795/7490088802
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (RewardedInterstitialAd ad) {
          print('Rewarded Interstitial Ad loaded');
          _rewardedInterstitialAd = ad;

          // Show the ad immediately after loading it (optional)
          _rewardedInterstitialAd?.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
              print('User earned reward: ${reward.amount} ${reward.type}');
              // Handle the reward the user earned here
            },
          );

          // Listen for ad dismissal to reload a new ad if needed
          _rewardedInterstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              print('Rewarded Interstitial Ad dismissed');
              ad.dispose(); // Dispose of the ad after dismissal
              RewardedInterstitialAdload(); // Optionally load a new ad after the current one is dismissed
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('Failed to show Rewarded Interstitial Ad: $error');
              ad.dispose();
              RewardedInterstitialAdload(); // Reload after failure
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Failed to load Rewarded Interstitial Ad: $error');
        },
      ),
    );
  }
}
