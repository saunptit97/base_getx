import 'package:flutter/material.dart';

class ListVerticalWidget extends StatelessWidget {
  const ListVerticalWidget({
    Key? key,
    required this.item,
    required this.data,
  }) : super(key: key);
  final Widget item;
  final List<dynamic> data;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, index) {
        return item;
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 10,
        );
      },
      itemCount: data.length,
    );
  }
}
