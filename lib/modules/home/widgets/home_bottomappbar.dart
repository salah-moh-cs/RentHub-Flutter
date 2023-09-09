import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/modules/home/controllers/home_controller.dart';

import 'custom_bottom_appbar_button.dart';

class HomeBottomAppBar extends GetView<HomeController> {
  const HomeBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int idx = 0; idx < controller.views.length; idx++)
              CustomBottomAppBarButton(
                label: controller.views[idx].label,
                icons: controller.views[idx].icons,
                isActive: idx == controller.currentPage.value,
                onPressed: () {
                  controller.goToIndex(idx);
                },
              ),
          ],
        );
      }),
    );
  }
}
