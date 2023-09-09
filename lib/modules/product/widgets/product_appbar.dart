// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:praduation_project/data/model/user_account_model.dart';
import 'package:praduation_project/global%20widget/custom_button.dart';
import 'package:praduation_project/modules/product/controllers/product_controller.dart';

import '../../../core/utils/helpers/system_helper.dart';
import '../../auth/controller/auth_controller.dart';
import '../views/edit_product.dart';
import 'add_product_widget.dart';

class ProductAppBar extends GetView<ProductController>
    implements PreferredSizeWidget {
  const ProductAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final any = AuthController.instance.isUserSignedInAnonymously();

    return AppBar(
      title: Text("detail".tr),
      centerTitle: true,
      actions: [
        any == true
            ? const SizedBox()
            : CustomButton(
                width: Get.width * .1,
                onPressed: () => controller.rate(),
                label: const Icon(
                  Icons.star_border,
                  color: Colors.amber,
                ),
              ),
        UserAccount.info!.uid == controller.product.userId ||
                UserAccount.info!.isAdmin
            ? CustomButton(
                width: Get.width * .1,
                onPressed: () {
                  Get.to(const EditProductView());
                },
                label: const Icon(
                  Icons.edit,
                  // color: Colors.amber,
                ),
              )
            : const SizedBox()
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomTextFormField extends StatelessWidget {
  final String label;
  final int? maxLength;
  final int? maxLines;

  final TextInputType? type;
  final String value;
  final Function(String)? onChanged;
  final String? Function(String?)? validator; // Add validator parameter
  final TextEditingController controller;

  CustomTextFormField({
    Key? key,
    required this.label,
    this.type,
    required this.value,
    this.onChanged,
    this.validator,
    this.maxLength,
    this.maxLines,
  })  : controller = TextEditingController(text: value),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: type,
      controller: controller,
      onChanged: onChanged,
      validator: validator, // Assign the validator function
      onFieldSubmitted: (value) => SystemHelper.closeKeyboard(),
      decoration: CustomInputDecoration.getDecoration(
        hintText: label,
        labelText: label,
      ),
    );
  }
}
