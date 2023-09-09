// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:liquid_swipe/PageHelpers/LiquidController.dart';

import '../../../constants/image.dart';
import '../model_onboarding.dart';
import '../onboarding_page.dart';

class OnboardingController extends GetxController {
  final controller = LiquidController();

  RxInt currentPage = 0.obs;

  final pages = [
    OnBoardingPage(
      model: OnBoardingModel(
        lottieImage: kOnBoardingImage1,
        title: "${'tOnBoardingTitle1'.tr} ${'appName'.tr}",
        subTitle: 'tOnBoardingSubTitle1'.tr,
        counterText: 'tOnBoardingCounter1'.tr,
        height: Get.height,
        titleColor: Colors.black,
        subTitleColor: Colors.grey,
      ),
    ),
    OnBoardingPage(
      model: OnBoardingModel(
        lottieImage: kOnBoardingImage2,
        title: 'tOnBoardingTitle2'.tr,
        subTitle: 'tOnBoardingSubTitle2'.tr,
        counterText: 'tOnBoardingCounter2'.tr,
        height: Get.height,
        titleColor: Colors.black,
        subTitleColor: Colors.grey,
      ),
    ),
    OnBoardingPage(
      model: OnBoardingModel(
        lottieImage: kOnBoardingImage3,
        title: 'tOnBoardingTitle3'.tr,
        subTitle: 'tOnBoardingSubTitle3'.tr,
        counterText: 'tOnBoardingCounter3'.tr,
        height: Get.height,
        titleColor: Colors.black,
        subTitleColor: Colors.grey,
      ),
    )
  ];

  onPageChangeCallback(int activePageIndex) {
    currentPage.value = activePageIndex;
  }

  skip() => controller.jumpToPage(page: 2);

  animateToNextSlide() {
    int nextPage = controller.currentPage + 1;
    controller.animateToPage(page: nextPage, duration: 300);
  }
}
