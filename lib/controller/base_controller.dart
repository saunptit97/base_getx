import 'package:base_getx/repository/repositories.dart';
import 'package:base_getx/utils/logger.dart';
import 'package:base_getx/utils/utils.dart';
import 'package:base_getx/widget/base_common_widget.dart';
import 'package:base_getx/widget/widget_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
export 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

///
/// --------------------------------------------
/// [Example]
///
/// class HomeController extends BaseController {
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

  String interstitialAdId = 'ca-app-pub-3940256099942544/1033173712';
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  final AdRequest request = const AdRequest(
    keywords: <String>[],
    nonPersonalizedAds: true,
  );

  @override
  void onInit() {
    super.onInit();
    if (withScrollController) {
      Logger.showLog(
        "SCROLL CONTROLLER ENABLE on ${Get.currentRoute}",
        withScrollController.toString(),
      );
      scrollController = ScrollController();
      scrollController?.addListener(_scrollListener);
    }
    createInterstitialAd();
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
    InterstitialAd.load(
        adUnitId: interstitialAdId,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ));
  }

  void showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
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
}
