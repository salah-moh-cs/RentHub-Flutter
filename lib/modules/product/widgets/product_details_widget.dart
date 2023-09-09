import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/modules/product/controllers/product_controller.dart';

import '../../../core/theme/text_theme.dart';
import '../../../global widget/custom_icon_label.dart';

class ProductDetailsWidget extends GetView<ProductController> {
  const ProductDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final product = controller.product;
    String remainingString = '';

    RegExp regex = RegExp(r'(\d+)');
    Iterable<Match> matches = regex.allMatches(product.maxRentalPeriod);
    remainingString = product.maxRentalPeriod.replaceAll(RegExp(r'[0-9 ]'), '');

    String numbers = '';
    for (Match match in matches) {
      numbers += match.group(0).toString();
    }

    ////////////////////////////////////////////////////////
    String remainingStringmin = '';

    RegExp regexmin = RegExp(r'(\d+)');
    Iterable<Match> matchesmin = regexmin.allMatches(product.minRentalPeriod);
    remainingStringmin =
        product.minRentalPeriod.replaceAll(RegExp(r'[0-9 ]'), '');

    String numbersmin = '';
    for (Match matchesmin in matchesmin) {
      numbersmin += matchesmin.group(0).toString();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        GetBuilder<ProductController>(builder: (_) {
          return Text(
            controller.product.isRent
                ? '${'stateOfTheProductAvailableIn'.tr} ${controller.product.getTimeDifference(0)}'
                : 'stateOfTheProductAvailableIn'.tr,
            style: TextStyle(
              color: controller.product.isRent
                  ? Colors.red
                  : Get.theme.colorScheme.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          );
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SelectableText(
              product.productName,
              style: AppStyles.headLine2.copyWith(
                color: Get.theme.colorScheme.onBackground,
              ),
            ),
            Text(
              "${product.price}${"jd".tr}/${product.period.tr}",
              style: AppStyles.headLine3.copyWith(
                color: Get.theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomIconLabel(
              icons: Icons.location_on,
              label: product.city.tr,
            ),
            const SizedBox(width: 8.0),
            GetBuilder<ProductController>(builder: (_) {
              return CustomIconLabel(
                icons: Icons.star,
                iconColor: Colors.amber,
                label: controller.product.rating.toStringAsFixed(1),
              );
            }),
          ],
        ),
        const SizedBox(height: 20.0),
        SizedBox(
          height: Get.height * .05,
          child: ListView(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            children: [
              CustomIconLabel(
                icons: Icons.category,
                label: product.category.tr,
              ),
              const SizedBox(width: 8.0),
              CustomIconLabel(
                icons: Icons.apartment,
                label: product.brandName,
              ),
              const SizedBox(width: 8.0),
              CustomIconLabel(
                  icons: Icons.call_made,
                  label: "$numbers ${remainingString.tr}"

                  // product.maxRentalPeriod.substring(0, 2) +
                  //     product.maxRentalPeriod.substring(2).tr,
                  ),
              const SizedBox(width: 8.0),
              CustomIconLabel(
                  icons: Icons.call_received,
                  label: "$numbersmin ${remainingStringmin.tr}"),
            ],
          ),
        ),
        const SizedBox(height: 20.0),
        Text(
          "descriptions".tr,
          style: AppStyles.headLine2,
        ),
        const SizedBox(height: 10.0),
        SelectableText(
          product.detail,
          style: AppStyles.subTitle3,
        ),
      ],
    );
  }
}
