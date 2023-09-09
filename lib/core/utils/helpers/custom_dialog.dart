import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:praduation_project/data/model/user_account_model.dart';

import '../../../data/model/product_model.dart';
import '../../../global widget/custom_button.dart';
import '../../../modules/auth/view/login/login_view.dart';
import '../../theme/text_theme.dart';

class CustomDialog {
  static Future<bool?> showYesNoDialog({
    required String title,
    required String content,
    IconData? icons,
    Color? iconsColor,
    String? yesButtonText,
    String? noButtonText,
    VoidCallback? onYesPressed,
    VoidCallback? onNoPressed,
    Color? yesButtonColor,
    bool barrierDismissible = true,
    Widget? body,
  }) async {
    return await Get.dialog<bool>(
      AlertDialog(
        titlePadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        backgroundColor: Get.theme.colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: Column(
          children: [
            Text(
              title,
              style: AppStyles.headLine2,
            ),
            const SizedBox(height: 35.0),
            body ??
                Text(
                  content,
                  style: AppStyles.headLine4,
                  textAlign: TextAlign.center,
                ),
            const SizedBox(height: 35.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  CustomButton(
                    label: Text(
                      yesButtonText ?? 'Yes',
                      style: AppStyles.button.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    color: Get.theme.colorScheme.primary,
                    onPressed: () {
                      Get.back(result: true);
                      onYesPressed?.call();
                    },
                  ),
                  CustomButton(
                    label: Text(
                      noButtonText ?? 'No',
                      style: AppStyles.button.copyWith(
                        color: Get.theme.colorScheme.onBackground,
                      ),
                    ),
                    onPressed: () {
                      Get.back(result: false);
                      onNoPressed?.call();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<bool?> showDoneDialog({
    required String title,
    String? content,
    final Widget? body,
    final String? doneButtonText,
    final VoidCallback? onDonePressed,
    bool barrierDismissible = true,
  }) async {
    return await Get.dialog<bool>(
      AlertDialog(
        titlePadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          children: [
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppStyles.headLine2,
                  ),
                  const SizedBox(height: 35.0),
                  body ??
                      Text(
                        content ?? "content",
                        style: AppStyles.headLine4,
                        textAlign: TextAlign.center,
                      ),
                  const SizedBox(height: 35.0),
                ],
              ),
            ),
            const SizedBox(height: 4.0),
            MaterialButton(
              minWidth: double.infinity,
              padding: const EdgeInsets.all(12.0),
              color: Get.theme.colorScheme.primary,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(12.0),
              )),
              onPressed: () {
                Get.back(result: true);
                onDonePressed?.call();
              },
              child: Text(
                doneButtonText ?? 'Done',
                style: AppStyles.button.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<bool?> showRatingDialog({
    required ProductModel product,
    bool barrierDismissible = true,
  }) async {
    double ratingValue = product.getRates;
    return await Get.dialog<bool>(
      AlertDialog(
        titlePadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        backgroundColor: Get.theme.colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: Column(
          children: [
            Text(
              'ratethisproduct'.tr,
              style: AppStyles.headLine2,
            ),
            const SizedBox(height: 35.0),
            StatefulBuilder(builder: (context, setState) {
              return RatingBar.builder(
                initialRating: ratingValue,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  setState(() => ratingValue = value);
                },
              );
            }),
            const SizedBox(height: 35.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  CustomButton(
                    label: Text(
                      'done'.tr,
                      style: AppStyles.button.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    color: Get.theme.colorScheme.primary,
                    onPressed: () {
                      Get.back(result: true);
                      product.updateRate(ratingValue, UserAccount.info!.uid);
                    },
                  ),
                  CustomButton(
                    label: Text(
                      'cancel'.tr,
                      style: AppStyles.button.copyWith(
                        color: Get.theme.colorScheme.onBackground,
                      ),
                    ),
                    onPressed: () {
                      Get.back(result: false);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<dynamic> buildguestdialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('غير مسجل'),
          content: const Text('الرجاء التسجيل بحساب'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Get.offAll(() => const LoginView());
              },
              child: const Text('تسجيل'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }
}
