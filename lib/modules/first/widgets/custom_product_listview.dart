import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/modules/product/views/all_product.dart';

import '../../../core/theme/text_theme.dart';
import '../../../global widget/user_and_product_stream_builder.dart';

class CustomProductListView extends StatelessWidget {
  final int? maxLenght;
  const CustomProductListView({super.key, this.maxLenght});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "topproduct".tr,
                style: AppStyles.headLine2,
              ),
              TextButton(
                child: Text(
                  "seeAll".tr,
                  style: AppStyles.headLine3,
                ),
                onPressed: () => Get.to(const AllProductView()),
              ),
            ],
          ),
          UserAndProductStreamBuilder(
            shrinkWrap: true,
            maxLenght: maxLenght,
          ),
          SizedBox(height: Get.height * .1),
        ],
      ),
    );
  }
}
