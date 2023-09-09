import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/core/theme/text_theme.dart';

class RentDialog extends StatelessWidget {
  const RentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      backgroundColor: context.theme.colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "selectPeriod".tr,
              style: AppStyles.headLine2,
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: ListTile(
                title: Text("daily".tr),
                onTap: () => Get.back(result: "daily".tr),
              ),
            ),
            Center(
              child: ListTile(
                title: Text("Monthly".tr),
                onTap: () => Get.back(result: "Monthly".tr),
              ),
            ),
            Center(
              child: ListTile(
                title: Text("Yearly".tr),
                onTap: () => Get.back(result: "Yearly".tr),
              ),
            )
          ],
        ),
      ),
    );
  }
}
