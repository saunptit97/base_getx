import 'package:base_getx/repository/repositories.dart';
import 'package:base_getx/utils/ad_helper.dart';
import 'package:base_getx/utils/logger.dart';
import 'package:base_getx/utils/utils.dart';
import 'package:base_getx/widgets/banner_ads_widget.dart';
import 'package:base_getx/widgets/base_common_widget.dart';
import 'package:base_getx/widgets/native_ads_widget.dart';
import 'package:base_getx/widgets/widget_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
export 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

///
/// --------------------------------------------
/// [Example]
///
/// class HomeController extends MyBaseController {
///
///   var count = 0.obs;
///
///   @override
///   void onInit() {
///     super.onInit();
///   }
///
///   void increment() => count ++;
///
/// }
///
/// RECOMENDED FOR your [Controller].
/// Please extends to your [Controller].
/// read the [Example] above.
class BaseController extends GetxController
    with BaseCommonWidgets, Utilities, Repositories, WidgetState, ScreenState {
  final box = GetStorage();
  bool isLoadMore = false;
  bool withScrollController = false;
  ScrollController? scrollController;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  set setEnableScrollController(bool value) => withScrollController = value;
  InterstitialAd? interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  final AdRequest request = const AdRequest(
    keywords: <String>[],
    nonPersonalizedAds: true,
  );
  bool initBanner = false;
  bool initInteral = false;

  /// Inline ads
  BannerAd? _anchoredAdaptiveAd;
  Orientation? _currentOrientation;

  AdSize adSize = AdSize.fullBanner;

  String BANNER_CONTROLLER_ID = "BANNER";

  @override
  void onInit() {
    super.onInit();
    if (withScrollController) {
      LoggerUtils.log(
        LogLevel.debug,
        "SCROLL CONTROLLER ENABLE on ${Get.currentRoute}",
      );

      scrollController = ScrollController();
      scrollController?.addListener(_scrollListener);
    }
    createInterstitialAd();
  }

  @override
  void onReady() {
    super.onReady();
    loadAd();
  }

  void loadAd() async {
    if (initBanner) {
      print("Load Banner");
      await _anchoredAdaptiveAd?.dispose();
      _anchoredAdaptiveAd = null;
      update([BANNER_CONTROLLER_ID]);

      _anchoredAdaptiveAd = BannerAd(
        adUnitId: AdHelper().bannerAdUnitId,
        size: adSize,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _anchoredAdaptiveAd = ad as BannerAd;
            print("Load Banner success");

            update([BANNER_CONTROLLER_ID]);
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
          },
        ),
      );
      return _anchoredAdaptiveAd!.load();
    }
  }

  Widget getNativeAds() {
    return NativeAdsWidget(height: 330, nativeId: AdHelper().nativeAdUnitId);
  }

  Widget getAdWidget({
    AdSize adSize = AdSize.banner,
    dynamic onPaidEvent,
  }) {
    return BannerAdsWidget(
      bannerId: AdHelper().bannerAdUnitId,
      adSize: adSize,
      key: UniqueKey(),
      onPaidEvent: onPaidEvent,
    );
    // return OrientationBuilder(
    //   builder: (context, orientation) {
    //     if (_currentOrientation != null &&
    //         _currentOrientation == orientation &&
    //         _anchoredAdaptiveAd != null) {
    //       return Container(
    //         margin: const EdgeInsets.symmetric(vertical: 10),
    //         child: SizedBox(
    //           width: _anchoredAdaptiveAd!.size.width.toDouble(),
    //           height: _anchoredAdaptiveAd!.size.height.toDouble(),
    //           child: AdWidget(ad: _anchoredAdaptiveAd!),
    //         ),
    //       );
    //     }
    //     // Reload the ad if the orientation changes.
    //     if (_currentOrientation != orientation) {
    //       _currentOrientation = orientation;
    //       loadAd();
    //     }
    //     return Container();
    //   },
    // );
  }

  Widget showBannerAds() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_anchoredAdaptiveAd != null) {
          return Container(
            width: adSize.width.toDouble(),
            height: adSize.height.toDouble(),
            color: Colors.white,
            child: Center(
              child: AdWidget(ad: _anchoredAdaptiveAd!),
            ),
          );
        }
        // // Reload the ad if the orientation changes.
        // if (_currentOrientation != orientation) {
        //   print("Reload Banner");
        //   _currentOrientation = orientation;
        //   loadAd();
        // }
        return Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.yellow,
              width: 1,
            ),
          ),
          width: adSize.width.toDouble() + 10,
          height: adSize.height.toDouble() + 10,
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
        );
      },
    );
  }

  Future<void> onRefresh() async {}

  Future<void> onLoadMore() async {}

  void _scrollListener() async {
    if (scrollController != null &&
        scrollController!.offset >=
            scrollController!.position.maxScrollExtent &&
        !scrollController!.position.outOfRange) {
      if (!isLoadMore) {
        isLoadMore = true;
        update();
        await onLoadMore();
      }
      _innerBoxScrolled();
    }
  }

  void createInterstitialAd() {
    if (initInteral) {
      print("create inters");
      InterstitialAd.load(
        adUnitId: AdHelper().interAdUnitId,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ),
      );
    }
  }

  Future<void> showInterstitialAd({FullScreenContentCallback? callBack}) async {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        print('ad onAdShowedFullScreenContent.');
        if (callBack?.onAdShowedFullScreenContent != null) {
          callBack!.onAdShowedFullScreenContent!(ad);
        }
      },
      onAdImpression: (InterstitialAd? ad) {
        print('ad onAdImpression.');
        if (callBack?.onAdImpression != null) {
          callBack!.onAdImpression!(ad);
        }
      },
      onAdClicked: (InterstitialAd? ad) {
        print('ad onAdClicked.');
        if (callBack?.onAdClicked != null) {
          callBack!.onAdClicked!(ad);
        }
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        if (callBack?.onAdDismissedFullScreenContent != null) {
          callBack!.onAdDismissedFullScreenContent!(ad);
        }
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        if (callBack?.onAdFailedToShowFullScreenContent != null) {
          callBack!.onAdFailedToShowFullScreenContent!(ad, error);
        }
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    await interstitialAd!.show();
    interstitialAd = null;
    createInterstitialAd();
  }

  void _innerBoxScrolled() {
    if (scrollController!.offset <= 60 && scrollController!.offset > 40) {
      // if(!innerBoxIsScrolled) {
      //   innerBoxIsScrolled = true;
      //   update();
      // }
    }
    if (scrollController!.offset >= 0 && scrollController!.offset <= 40) {
      // if(innerBoxIsScrolled) {
      //   innerBoxIsScrolled = false;
      //   update();
      // }
    }
  }

  @override
  void onClose() {
    interstitialAd?.dispose();
    super.onClose();
  }
}
