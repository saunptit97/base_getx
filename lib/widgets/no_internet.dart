import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.grey,
      ),
      height: 40,
      child: const Center(
        child: Text(
          'Không có kết nối mạng',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
