import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/theme/text_theme.dart';

class ImageViewerList extends StatelessWidget {
  final List<String> imageUrls;
  final int initialImage;
  const ImageViewerList(
      {super.key, required this.imageUrls, this.initialImage = 0});

  static show({required List<String> imageUrls, int initialImage = 0}) {
    Get.to(
      () => ImageViewerList(
        imageUrls: imageUrls,
        initialImage: initialImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: initialImage);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: InteractiveViewer(
          child: PageView.builder(
            controller: controller,
            scrollDirection: Axis.horizontal,
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              String imageUrl = imageUrls[index];
              return Hero(
                tag: imageUrl,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  progressIndicatorBuilder: (_, url, download) {
                    if (download.progress != null) {
                      final percent = download.progress! * 100;
                      return Center(
                        child: FittedBox(
                          child: Text(
                            '${percent.toStringAsFixed(1)}%',
                            style: AppStyles.headLine1,
                          ),
                        ),
                      );
                    }
                    return Center(
                      child: FittedBox(
                        child: Text(
                          'Loading...',
                          style: AppStyles.headLine1,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
