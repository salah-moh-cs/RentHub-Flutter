// ignore_for_file: unused_element

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/data/model/product_model.dart';
import 'package:praduation_project/modules/product/controllers/product_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../global widget/image_viewer_list.dart';

class ProductImagesWidget extends GetView<ProductController> {
  const ProductImagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image ..........
        SizedBox(
          height: Get.height * .3,
          width: Get.width,
          child: GetBuilder<ProductController>(builder: (_) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: controller.product.isRent == true
                  ? Banner(
                      message: "rented".tr,
                      location: BannerLocation.topStart,
                      child: _ImageBody(product: controller.product),
                    )
                  : _ImageBody(product: controller.product),
            );
          }),
        ),

        Positioned(
          top: 15,
          right: 15,
          child: Container(
            height: Get.height * .035,
            width: Get.width * .18,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                GetBuilder<ProductController>(builder: (_) {
                  return Text(
                    controller.product.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                })
              ],
            ),
          ),
        ),

        // Dots ..........
        Positioned(
          bottom: 5,
          right: 0,
          left: 0,
          child: Center(
            child: Obx(() {
              return AnimatedSmoothIndicator(
                activeIndex: controller.currentIndex.value,
                count: controller.product.imagesUrl.length,
                effect: ExpandingDotsEffect(
                  spacing: 12,
                  activeDotColor: Get.theme.colorScheme.primary,
                  dotColor: Get.theme.colorScheme.secondary,
                  dotHeight: 12,
                  dotWidth: 12,
                ),
                onDotClicked: controller.onDotClicked,
              );
            }),
          ),
        )
      ],
    );
  }
}

class _ImageBody extends GetView<ProductController> {
  final ProductModel product;
  const _ImageBody({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller.pageController,
      scrollDirection: Axis.horizontal,
      onPageChanged: controller.onPageChanged,
      itemCount: product.imagesUrl.length,
      itemBuilder: (context, index) {
        String imageUrl = product.imagesUrl[index];
        return GestureDetector(
          onTap: () {
            ImageViewerList.show(
              imageUrls: product.imagesUrl,
              initialImage: index,
            );
          },
          child: Hero(
            tag: imageUrl,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              width: Get.width,
              progressIndicatorBuilder: (_, url, download) {
                if (download.progress != null) {
                  final percent = download.progress! * 100;
                  return Center(
                    child: FittedBox(
                      child: Text('${percent.toStringAsFixed(1)}%'),
                    ),
                  );
                }
                return Center(
                  child: FittedBox(
                    child: Text('loading'.tr),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
