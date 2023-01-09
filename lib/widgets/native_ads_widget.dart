import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:native_ads_flutter/native_ads.dart';

class NativeAdsWidget extends StatefulWidget {
  const NativeAdsWidget({
    Key? key,
    required this.height,
    required this.nativeId,
  }) : super(key: key);
  final double height;
  final String nativeId;

  @override
  State<NativeAdsWidget> createState() => _StateNativeAdsWidget();
}

class _StateNativeAdsWidget extends State<NativeAdsWidget> {
  NativeAd? _nativeAd;

  @override
  void initState() {
    super.initState();
    // loadAd(widget.nativeId);
  }

  bool _nativeAdIsLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("11111111111111111111");
    _nativeAd = NativeAd(
      adUnitId: widget.nativeId,
      request: AdRequest(),
      factoryId: 'adFactoryExample',
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          print('$NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
      ),
    )..load();
    print("11111111111111111112");
  }

  @override
  Widget build(BuildContext context) {
    return _nativeAd != null && _nativeAdIsLoaded
        ? Container(
            height: widget.height,
            child: AdWidget(ad: _nativeAd!),
          )
        : SizedBox();
  }

  // void loadAd(String nativeId) {
  //   final NativeAdListener listener = NativeAdListener(
  //     // Called when an ad is successfully received.
  //     onAdLoaded: (Ad ad) => print('Ad loaded.'),
  //     // Called when an ad request failed.
  //     onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //       // Dispose the ad here to free resources.
  //       ad.dispose();
  //       print('Ad failed to load: $error');
  //     },
  //     // Called when an ad opens an overlay that covers the screen.
  //     onAdOpened: (Ad ad) => print('Ad opened.'),
  //     // Called when an ad removes an overlay that covers the screen.
  //     onAdClosed: (Ad ad) => print('Ad closed.'),
  //     // Called when an impression occurs on the ad.
  //     onAdImpression: (Ad ad) => print('Ad impression.'),
  //     // Called when a click is recorded for a NativeAd.
  //     // onNativeAdClicked: (NativeAd ad) => print('Ad clicked.'),
  //   );
  //   myNative = NativeAd(
  //     adUnitId: widget.nativeId,
  //     factoryId: 'adFactoryExample',
  //     request: AdRequest(),
  //     listener: listener,
  //   );
  //   setState(() {});
  //   myNative!.load();
  // }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }
}
