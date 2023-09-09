import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/modules/first/controllers/first_controller.dart';

import '../../../core/theme/text_theme.dart';
import 'custom_categorie_card.dart';

class CustomCategoryListview extends GetView<FirstController> {
  const CustomCategoryListview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'category'.tr,
                style: AppStyles.headLine2,
              ),
              // TextButton(
              //   onPressed: () {},
              //   child: Text(
              //     'seeAll'.tr,
              //     style: AppStyles.headLine3,
              //   ),
              // ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            itemBuilder: (context, index) => CustomCategorieCard(
              category: controller.categories[index],
            ),
          ),
        ),
      ],
    );
  }
}
