import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  const LoadingWidget({super.key, this.isLoading = false, required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !isLoading;
      },
      child: Stack(
        children: [
          child,
          if (isLoading)
            Container(
              height: Get.height,
              width: Get.width,
              color: Colors.black.withOpacity(.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/lottie/loading.json",
                    width: Get.width * .35,
                    height: Get.height * .2,
                  ),
                  Text(
                    "loading".tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
