import 'package:flutter/material.dart';

class NameImageWidget extends StatelessWidget {
  const NameImageWidget({
    Key? key,
    required this.name,
    this.radius = 20,
  }) : super(key: key);
  final String name;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius * 2,
      width: radius * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: const Color(0xFFF05323),
      ),
      child: Center(
        child: Text(
          name.substring(0, 1),
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
