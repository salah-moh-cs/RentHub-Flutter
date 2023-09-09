import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:praduation_project/core/utils/helpers/system_helper.dart';

class CarouselContainer extends StatefulWidget {
  final List<String> imageUrls;
  final List<String> imageLinks;

  const CarouselContainer({
    Key? key,
    required this.imageUrls,
    required this.imageLinks,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CarouselContainerState createState() => _CarouselContainerState();
}

class _CarouselContainerState extends State<CarouselContainer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          onPageChanged: (index, reason) {
            setState(() {});
          },
          viewportFraction: .9,
          enlargeCenterPage: false,
          enableInfiniteScroll: true,
        ),
        items: widget.imageUrls.asMap().entries.map((entry) {
          final imageUrl = entry.value;
          final imageLink = widget.imageLinks[entry.key];

          return Builder(
            builder: (BuildContext context) {
              return InkWell(
                onTap: () {
                  SystemHelper.makelink(imageLink);
                },
                child: Container(
                  width: Get.width,
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    errorWidget: (context, url, error) => const SizedBox(),
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
