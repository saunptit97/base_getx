import 'package:flutter/material.dart';

import 'fixed_text.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
    this.btnColor,
    this.title = '',
    this.width = double.infinity,
    this.height = 50,
    this.titleStyle,
    this.titleWidget,
    this.onTap,
    this.borderRadius,
    this.padding = 8,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  final String title;

  final Color? btnColor;

  final double width;

  final double height;

  final TextStyle? titleStyle;

  final Widget? titleWidget;

  final VoidCallback? onTap;

  final BorderRadius? borderRadius;

  final double padding;

  final Widget? suffixIcon;

  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: btnColor,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
        border: Border.all(
          width: 1,
          color: btnColor ?? Colors.transparent,
        ),
      ),
      height: height,
      width: width,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              prefixIcon ?? const SizedBox(),
              Center(
                child: titleWidget ??
                    FixedText(
                      title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: titleStyle ??
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
              ),
              suffixIcon ?? const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
