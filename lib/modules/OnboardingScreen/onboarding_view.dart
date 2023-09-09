// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:praduation_project/modules/OnboardingScreen/widgets/onboarding_controller.dart';
import 'package:praduation_project/modules/auth/view/login/login_view.dart';
import 'package:praduation_project/core/theme/text_theme.dart';
import 'package:praduation_project/data/services/get_db.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  final obcontroller = OnboardingController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
            pages: obcontroller.pages,
            liquidController: obcontroller.controller,
            onPageChangeCallback: (index) {
              // printInfo(info: index.toString());
              obcontroller.onPageChangeCallback(index);
              setState(() {
                if (index == 2) {
                  isLastPage = true;
                } else {
                  isLastPage = false;
                }
              });
            },
            enableSideReveal: false,
          ),
          Positioned(
            bottom: 60.0,
            child: isLastPage
                ? ElevatedButton(
                    onPressed: () {
                      Database.isFirstTime = false;
                      Get.offAll(() => const LoginView());
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Get.theme.colorScheme.background,
                      shape: const CircleBorder(),
                      backgroundColor: Get.theme.colorScheme.primary,
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        'getStarted'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : OutlinedButton(
                    onPressed: () {
                      setState(() {
                        obcontroller.animateToNextSlide();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Get.theme.colorScheme.background,
                      side: BorderSide(color: Get.theme.colorScheme.secondary),
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward),
                    ),
                  ),
          ),
          Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: () {
                  obcontroller.currentPage.value = 2;
                  obcontroller.skip();
                },
                child: Text(
                  "skip".tr,
                  style: AppStyles.bodyText3.copyWith(
                    color: Get.theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )),
          Obx(
            () => Positioned(
                bottom: 10,
                child: AnimatedSmoothIndicator(
                  count: 3,
                  activeIndex: obcontroller.currentPage.value,
                  effect: WormEffect(
                    activeDotColor: Get.theme.colorScheme.primary,
                    dotColor: Get.theme.colorScheme.onSurfaceVariant,
                    dotHeight: 5,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
