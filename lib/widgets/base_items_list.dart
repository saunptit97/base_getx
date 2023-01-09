import 'package:flutter/material.dart';

import 'default_separator.dart';
import 'fixed_text.dart';

typedef ListItemBuilder<T> = Widget Function(
  BuildContext context,
  List<T> items,
  int index,
  Map<String, dynamic>? itemParams,
  dynamic otherData,
);
typedef ListUpdateCallback = Future<void> Function(bool isReload);

class BaseItemsList<T> extends StatefulWidget {
  const BaseItemsList({
    Key? key,
    required this.data,
    required this.itemBuilder,
    this.itemParams,
    this.onRequestData,
    this.handleLoadMore,
    this.noDataPlaceHolder,
    this.otherData,
  }) : super(key: key);
  final List<T> data;
  final ListItemBuilder<T> itemBuilder;
  final Map<String, dynamic>? itemParams;
  final ListUpdateCallback? onRequestData;
  final ListUpdateCallback? handleLoadMore;
  final Widget? noDataPlaceHolder;
  final dynamic otherData;

  @override
  State<BaseItemsList<T>> createState() => _BaseItemsListState<T>();
}

class _BaseItemsListState<T> extends State<BaseItemsList<T>>
    with SingleTickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late ScrollController _listController;

  @override
  void initState() {
    _listController = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() async {
    // print(_listController.position.extentAfter);
    if (_listController.position.extentAfter < 1.0 &&
        widget.handleLoadMore != null) {
      await widget.handleLoadMore!(true);
    }
  }

  Future<void> _refresh() async {
    return widget.onRequestData!(true);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: widget.data.isEmpty
          ? widget.noDataPlaceHolder ??
              const FixedText('Không tìm thấy dữ liệu!')
          : ListView.separated(
              controller: _listController,
              itemBuilder: (BuildContext context, int index) {
                return widget.itemBuilder(context, widget.data, index,
                    widget.itemParams, widget.otherData);
              },
              padding: const EdgeInsets.all(0),
              separatorBuilder: (_, int index) =>
                  const DefaultSeparatorWidget(),
              itemCount: widget.data.length,
              primary: false,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
            ),
    );
  }
}
