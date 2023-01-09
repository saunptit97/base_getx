import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    required this.controller,
    this.title,
    this.hintText = '',
    this.hintStyle,
    this.isPassword = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.isErrorField = false,
    this.onTap,
    this.onChanged,
    this.keyboardType,
    this.paddingTop,
    this.paddingBottom,
    this.paddingLeft,
    this.paddingRight,
    this.isRequired = false,
    this.enable = true,
    this.maxLines = 1,
    this.inputBorder,
    this.contentPaddingHor,
    this.contentPaddingVer,
    this.fillColor,
  }) : super(key: key);

  final TextEditingController controller;
  final String? title;
  final String hintText;
  final TextStyle? hintStyle;
  final bool isPassword;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final bool isErrorField;
  final Function? onTap;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final double? paddingLeft;
  final double? paddingRight;
  final double? paddingTop;
  final double? paddingBottom;
  final bool? isRequired;
  final bool? enable;
  final int maxLines;
  final InputBorder? inputBorder;
  final double? contentPaddingHor;
  final double? contentPaddingVer;
  final Color? fillColor;
  @override
  Widget build(BuildContext context) {
    double left = paddingLeft == null ? 24 : paddingLeft!;
    double right = paddingRight == null ? 24 : paddingRight!;
    double top = paddingTop == null ? 8 : paddingTop!;
    double bottom = paddingBottom == null ? 8 : paddingBottom!;

    return Padding(
      padding: EdgeInsets.only(
        left: left,
        right: right,
        bottom: bottom,
        top: top,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            !isRequired!
                ? Text(
                    title!,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  )
                : RichText(
                    text: TextSpan(children: [
                    TextSpan(
                      text: title,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    TextSpan(
                      text: " *",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ])),
            const SizedBox(
              height: 4,
            ),
          ],
          TextFormField(
            onChanged: (value) {
              if (onChanged != null) {
                onChanged!(value);
              }
            },
            readOnly: enable == false,
            controller: controller,
            keyboardType: keyboardType,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: hintStyle,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              errorMaxLines: 2,
              fillColor: fillColor ?? Colors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: contentPaddingHor ?? 13.5,
                vertical: contentPaddingVer ?? 0,
              ),
              enabledBorder: isErrorField
                  ? const OutlineInputBorder(
                      borderSide: BorderSide(
                        // color: ColorUtils.primaryColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(60)))
                  : inputBorder,
              focusedBorder: isErrorField
                  ? const OutlineInputBorder(
                      borderSide: BorderSide(
                        // color: ColorUtils.primaryColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(60),
                      ),
                    )
                  : inputBorder,
            ),
            validator: validator,
            maxLines: maxLines,
            // style: isErrorField
            //   ? TextStyle(color: ColorUtils.primaryColor)
            //   : TextStyle(),
            onTap: () => onTap,
          ),
        ],
      ),
    );
  }
}
