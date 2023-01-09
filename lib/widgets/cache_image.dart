import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import 'name_image.dart';

class CacheImageWidget extends StatelessWidget {
  const CacheImageWidget({
    Key? key,
    required this.image,
    this.height = 40,
    this.width = 40,
    this.radius = 0,
    this.name,
  }) : super(key: key);
  final String image;
  final double height;
  final double width;
  final double radius;
  final String? name;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
        placeholder: (ctx, _) => const CupertinoActivityIndicator(),
        errorWidget: (context, url, error) => name != null
            ? NameImageWidget(name: name!)
            : Image.asset('assets/png/no_image.png'),
        width: width,
        height: height,
      ),
    );
  }
}
