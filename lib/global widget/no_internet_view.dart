import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../core/theme/text_theme.dart';
import 'custom_button.dart';

class NoInternetView extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const NoInternetView({Key? key});

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
              'assets/lottie/112949-no-internet-connection.json',
              height: Get.height * .35,
              width: Get.width,
            ),
            SizedBox(height: Get.height * .05),
            Text(
              "internetDisconnected".tr,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.headLine1.copyWith(
                color: Get.theme.colorScheme.onBackground,
              ),
            ),
            SizedBox(height: Get.height * .03),
            Text(
              "noInternetAvailable".tr,
              textAlign: TextAlign.center,
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
                SystemNavigator.pop();
              },
              label: Text(
                "exitfromapp".tr,
                style: AppStyles.button,
              ),
            )
          ],
        ),
      ),
    );
  }
}
