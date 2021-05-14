import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final String? toRoute;

  const NetworkImageWidget({Key? key, required this.imageUrl, this.toRoute})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) {
        return InkWell(
          onTap: () {
            if (toRoute != null) {
              Navigator.of(context).pushNamed(toRoute!, arguments: imageUrl);
            }
          },
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.contain,
              )),
            ),
          ),
        );
      },
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
        child: CircularProgressIndicator(value: downloadProgress.progress),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
