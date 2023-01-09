import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../controller/base_controller.dart';

class BannerAdsWidget extends StatefulWidget {
  const BannerAdsWidget({
    Key? key,
    required this.bannerId,
    required this.adSize,
    this.onPaidEvent,
  }) : super(key: key);
  final String bannerId;
  final AdSize adSize;
  final void Function(Ad, double, PrecisionType, String)? onPaidEvent;
  @override
  State<BannerAdsWidget> createState() => _BannerAdsWidgetState();
}

class _BannerAdsWidgetState extends State<BannerAdsWidget> {
  bool isLoadingAds = true;
  double adWidth = 0;
  double adHeight = 0;

  /// Inline ads
  BannerAd? _anchoredAdaptiveAd;
  Orientation? _currentOrientation;

  @override
  void initState() {
    super.initState();
    adWidth = widget.adSize.width.toDouble();
    adHeight = widget.adSize.height.toDouble();
    loadAd(widget.adSize, widget.bannerId);
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingAds == true
        ? Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.yellow,
                width: 1,
              ),
            ),
            width: adWidth + 10,
            height: adHeight + 10,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    color: Colors.orange,
                    child: const Text(
                      "Ad",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                  ),
                )
              ],
            ),
          )
        : OrientationBuilder(
            builder: (context, orientation) {
              if (_currentOrientation != null &&
                  _currentOrientation == orientation &&
                  _anchoredAdaptiveAd != null) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: adWidth,
                    height: adHeight,
                    child: AdWidget(ad: _anchoredAdaptiveAd!),
                  ),
                );
              }
              // Reload the ad if the orientation changes.
              if (_currentOrientation != orientation) {
                _currentOrientation = orientation;
                loadAd(widget.adSize, widget.bannerId);
              }
              return Container();
            },
          );
  }

  void loadAd(AdSize adSize, String bannerId) async {
    await _anchoredAdaptiveAd?.dispose();
    _anchoredAdaptiveAd = null;
    setState(() {});
    _currentOrientation = MediaQuery.of(Get.context!).orientation;
    _anchoredAdaptiveAd = BannerAd(
      adUnitId: bannerId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          // When the ad is loaded, get the ad size and use it to set
          // the height of the ad container.
          // _anchoredAdaptiveAd = ad. as BannerAd;
          isLoadingAds = false;
          setState(() {});
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          isLoadingAds = false;
          adHeight = 0;
          adWidth = 0;
          setState(() {});
          ad.dispose();
        },
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {
          if (widget.onPaidEvent != null) {
            widget.onPaidEvent!(ad, valueMicros, precision, currencyCode);
          }
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }

  @override
  void dispose() {
    _anchoredAdaptiveAd?.dispose();
    super.dispose();
  }
}
