import 'dart:io';

class AdSense {
  static String get bannerAdUnitID {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7315976017574578/7966778213';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7315976017574578/6747714243';
    } else {
      return '';
    }
  }

  static String get bannerAdUnitIDTop {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7315976017574578/2485035600';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7315976017574578/9784941125';
    } else {
      return '';
    }
  }

  static String get interstitialAdUnitID {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7315976017574578/8851612331';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7315976017574578/5434632579';
    } else {
      return '';
    }
  }
}
