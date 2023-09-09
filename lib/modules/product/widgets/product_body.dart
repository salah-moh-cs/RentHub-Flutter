// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/data/model/user_account_model.dart';
import 'package:praduation_project/modules/product/widgets/product_reports.dart';

import '../../auth/controller/auth_controller.dart';
import 'product_bottombar.dart';
import 'product_comment_widget.dart';
import 'product_details_widget.dart';
import 'product_images_widget.dart';
import 'product_user_widget.dart';

// ignore: must_be_immutable
class ProductBody extends StatelessWidget {
  bool? adm;
  ProductBody({
    Key? key,
    this.adm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final any = AuthController.instance.isUserSignedInAnonymously();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: Get.height * .02),
                const ProductImagesWidget(),
                SizedBox(height: Get.height * .04),
                const ProductDetailsWidget(),
                SizedBox(height: Get.height * .04),
                any == true ? const SizedBox() : const ProductUserWidget(),
                SizedBox(height: Get.height * .04),
                const ProductCommentsWidget(),
                any == true ? const SizedBox() : CommentUserInput(),
                SizedBox(height: Get.height * .1),
                UserAccount.info!.isAdmin
                    ? const ProductReportsWidget()
                    : const SizedBox(),
              ],
            ),
          ),
          // FloatingActionButton(onPressed: () {}),

          ProductBottomBar(
            adm: adm,
          ),
        ],
      ),
    );
  }
}
