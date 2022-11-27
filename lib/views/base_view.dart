import 'package:base_getx/controller/base_controller.dart';
import 'package:flutter/material.dart';

/// [Example]
///
/// class MemberWidget extends BaseViewModel<MemberController> {
///
///   @override
///   Widget vmBuilder() => Text("Hi, I'm a member");
///
/// }
///
/// Please extends to your [ViewModel] / [Widget] / [Child].
/// read the [Example] above.
abstract class BaseViewModel<T extends BaseController> extends StatelessWidget {
  const BaseViewModel({Key? key}) : super(key: key);

  final String tag = '';

  T get controller => GetInstance().find<T>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Obx(() => vmBuilder());
  }

  Widget vmBuilder();
}

/// [Example]
///
/// class HomeView extends BaseView<HomeController> {
///
///   @override
///   Widget vBuilder() => Scaffold(
///     appBar: AppBar(
///       title: Text("Title"),
///     ),
///     body: Container(
///       child: Center(
///         child: Text("Hello, world",
///           style: AppThemes().textTheme.bodyText1,
///         ),
///       ),
///     ),
///   );
///
/// }
///
/// RECOMENDED FOR you'r [Screen] / [View] / [Page].
/// Please extends to your [Screen] / [View] / [Page].
/// read the [Example] above.
abstract class BaseView<T extends BaseController> extends StatelessWidget {
  const BaseView({Key? key, this.enableRefresh = true}) : super(key: key);

  final String tag = '';
  final bool enableRefresh;

  T get controller => GetInstance().find<T>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      init: controller,
      builder: (controller) {
        if (enableRefresh) {
          return RefreshIndicator(
            key: controller.refreshIndicatorKey,
            onRefresh: () async {
              await controller.onRefresh();
            },
            child: vBuilder(context),
          );
        } else {
          return vBuilder(context);
        }
      },
    );
  }

  Widget vBuilder(BuildContext context);
}
