import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../login/widgets/themehelper.dart';

class OtpTextFormField extends StatelessWidget {
  final TextEditingController? otpController;
  const OtpTextFormField({Key? key, this.otpController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 4,
      controller: otpController,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
      decoration: ThemeHelper().textInputDecoration(
        lableText: "",
        hintText: "",
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'pleaseEnterAValidNumber'.tr;
        }
        return null;
      },
    );
  }
}
