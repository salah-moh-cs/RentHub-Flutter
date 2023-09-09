import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/modules/first/model/category_model.dart';

import '../../../core/theme/text_theme.dart';
import '../../product/views/categorie_products_view.dart';

class CustomCategorieCard extends StatelessWidget {
  final CategoryModel category;
  const CustomCategorieCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: () {
                  Get.to(() => CategorieProductsView(productuuid: category.id));
                },
                child: Image.asset(
                  category.imageAssets,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            category.label.tr,
            style: AppStyles.bodyText3,
          ),
        ],
      ),
    );
  }
}
