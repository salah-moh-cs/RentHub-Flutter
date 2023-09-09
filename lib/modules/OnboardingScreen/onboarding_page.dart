import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:praduation_project/core/theme/text_theme.dart';

import 'model_onboarding.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    Key? key,
    required this.model,
  }) : super(key: key);

  final OnBoardingModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: model.backgroundColor ?? Get.theme.colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (model.lottieImage != null)
            Lottie.asset(
              model.lottieImage!,
              height: model.height * .4,
            ),
          if (model.assetImage != null)
            Image(
              image: AssetImage(model.assetImage!),
              height: model.height * .4,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Text(
                  model.title,
                  style: AppStyles.headLine1.copyWith(
                    color: Get.theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Padding(padding: EdgeInsets.all(7)),
                Text(
                  model.subTitle,
                  textAlign: TextAlign.center,
                  style: AppStyles.headLine2.copyWith(
                    color: Get.theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            model.counterText,
            style: AppStyles.subTitle2.copyWith(
              fontWeight: FontWeight.bold,
              color: Get.theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 150,
          )
        ],
      ),
    );
  }
}
