import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/modules/home/controllers/home_controller.dart';

class HomeBody extends GetView<HomeController> {
  // ignore: use_key_in_widget_constructors
  const HomeBody({Key? key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller.pageController,
      physics:
          controller.any == true ? const NeverScrollableScrollPhysics() : null,
      onPageChanged: controller.onPageChanged,
      itemCount: controller.views.length,
      itemBuilder: (context, idx) => controller.views[idx].view,
    );
  }
}
