import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:praduation_project/core/theme/text_theme.dart';
import 'package:praduation_project/global%20widget/custom_button.dart';
import 'package:praduation_project/modules/home/bindings/home_binding.dart';
import 'package:praduation_project/modules/home/views/home_view.dart';

class ProductDeletedView extends StatelessWidget {
  const ProductDeletedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Get.height * .15),
            LottieBuilder.asset(
              'assets/lottie/product_not_found.json',
              height: Get.height * .35,
              width: Get.width,
            ),
            SizedBox(height: Get.height * .05),
            Text(
              "productUnavailable".tr,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.headLine1.copyWith(
                color: Get.theme.colorScheme.onBackground,
              ),
            ),
            SizedBox(height: Get.height * .03),
            Text(
              "noLongerAvailable".tr,
              textAlign: TextAlign.start,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.subTitle2.copyWith(
                color: Get.theme.colorScheme.onBackground,
              ),
            ),
            SizedBox(height: Get.height * .06),
            CustomButton(
              color: Colors.red,
              onPressed: () {
                Get.offAll(() => HomeView(), binding: HomeBinding());
              },
              label: Text(
                "goToHome".tr,
                style: AppStyles.button,
              ),
            )
          ],
        ),
      ),
    );
  }
}
