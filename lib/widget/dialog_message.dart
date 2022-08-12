import 'package:base_getx/controller/base_controller.dart';
import 'package:flutter/material.dart';

class DialogMessage extends StatelessWidget {
  const DialogMessage({Key? key, this.content, this.icon}) : super(key: key);
  final String? content;
  final String? icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
      child: Center(
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 25,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  icon ?? 'assets/png/ic_tick_alert.png',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  content ?? "",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
