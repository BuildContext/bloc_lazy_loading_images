import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import 'widgets/network_image_widget.dart';

class ImagePage extends StatelessWidget {
  static const String routeName = '/image_page';
  final String imageUrl;

  const ImagePage({Key? key, required this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
            Share.share(imageUrl);
          },
        ),
      ),
      body: NetworkImageWidget(imageUrl: imageUrl),
    );
  }
}
