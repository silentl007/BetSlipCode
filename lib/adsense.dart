import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdSense {
  static String get bannerAdUnitID {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7315976017574578/4091946530';
    } else if (Platform.isIOS) {
      return '';
    } else {
      return '';
    }
  }

  static String get interstitialAdUnitID {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7315976017574578/1262603214';
    } else if (Platform.isIOS) {
      return '';
    } else {
      return '';
    }
  }

  AdListener get adListener => _adListener;
  AdListener _adListener = AdListener(
    onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId}'),
    onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId}'),
    onAdFailedToLoad: (ad, error) =>
        print('Add error: ${ad.adUnitId}, the error: $error'),
    onAdOpened: (ad) => print('Ad opened: ${ad.adUnitId}'),
    onAppEvent: (ad, name, data) =>
        print('Ad event: ${ad.adUnitId}, $name, $data'),
    onApplicationExit: (ad) => print('App exit: ${ad.adUnitId}'),
    onNativeAdClicked: (ad) => print('Ad native clicked: ${ad.adUnitId}'),
    onNativeAdImpression: (ad) => print('Ad native impression: ${ad.adUnitId}'),
    onRewardedAdUserEarnedReward: (ad, reward) => print(
        'Ad reward ad user: ${ad.adUnitId}, ${reward.amount}, ${reward.type}'),
  );
}
