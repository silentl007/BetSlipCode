import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdSense {
  Future<InitializationStatus> initialization;
  AdSense(this.initialization);

  String bannerAdUnitID = 'ca-app-pub-7315976017574578/3924336288';
  // String bannerAdUnitID = 'ca-app-pub-3940256099942544/6300978111'; // test
  String interstitialAdUnitID = 'ca-app-pub-7315976017574578/2029181551';

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
