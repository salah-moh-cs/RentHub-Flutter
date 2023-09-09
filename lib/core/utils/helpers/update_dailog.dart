import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/core/utils/validators.dart';

import '../../../data/model/user_account_model.dart';
import '../../../global widget/custom_button.dart';
import '../../theme/text_theme.dart';
import 'system_helper.dart';

class EditCurrentUserDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  EditCurrentUserDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserAccount user = UserAccount.info!;
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Edit",
                  style: AppStyles.headLine2,
                ),
                const SizedBox(height: 30.0),
                CustomTextFormField(
                  label: "User name",
                  validator: validateUsername,
                  value: user.username,
                  onChanged: (val) {
                    user = user.copyWith(username: val);
                  },
                ),
                CustomTextFormField(
                  type: TextInputType.phone,
                  label: "Phone number",
                  value: user.phoneNumber,
                  onChanged: (val) {
                    user = user.copyWith(phoneNumber: val);
                  },
                  validator: validatePhoneNumber,
                ),
                const SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      CustomButtonWithLoading(
                        label: Text(
                          'update'.tr,
                          style: AppStyles.button.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.green,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            await user.update();
                            Get.back(result: true);
                          }
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
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final String label;
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
  })  : controller = TextEditingController(text: value),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: type,
      controller: controller,
      onChanged: onChanged,
      validator: validator, // Assign the validator function
      onFieldSubmitted: (value) => SystemHelper.closeKeyboard(),
      decoration: InputDecoration(
        errorMaxLines: 2,
        labelText:
            label, // Use labelText instead of label for better visibility
      ),
    );
  }
}
