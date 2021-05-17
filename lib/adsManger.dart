import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';

class AdsManger {
  static bool _testmode = false;

  static String get appIdEx {
    if (Platform.isAndroid) {
      return "ca-app-pub-9553580055895935~1610407402";
    } else if (Platform.isIOS) {
      return "....";
    } else {
      throw new UnsupportedError("UNSUPPORTED PLATFORM");
    }
  }

  static String get BannerAdUnitIdEX {
    if (_testmode == true) {
      return AdmobBanner.testAdUnitId;
    } else if (Platform.isAndroid) {
      return "ca-app-pub-8832245228844811/5482892164";
    } else if (Platform.isIOS) {
      return "....";
    } else {
      throw new UnsupportedError("UNSUPPORTED PLATFORM");
    }
  }

  static String get nativeAdunit {
    if (_testmode == true) {
      return "ca-app-pub-3940256099942544/2247696110";
      //NativeAdmob.testAdUnitId;
    } else if (Platform.isAndroid) {
      return "ca-app-pub-9553580055895935/2620164334";
    } else if (Platform.isIOS) {
      return "....";
    } else {
      throw new UnsupportedError("UNSUPPORTED PLATFORM");
    }
  }

  static String get interstitialAd {
    if (_testmode == true) {
      return AdmobInterstitial.testAdUnitId;
    } else if (Platform.isAndroid) {
      return "ca-app-pub-8832245228844811/4121709038";
    } else if (Platform.isIOS) {
      return "....";
    } else {
      throw new UnsupportedError("UNSUPPORTED PLATFORM");
    }
  }
}
