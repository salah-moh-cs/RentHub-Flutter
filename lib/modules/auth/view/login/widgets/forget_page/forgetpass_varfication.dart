// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/modules/auth/view/login/login_view.dart';
import 'package:praduation_project/core/theme/text_theme.dart';
import 'package:praduation_project/global%20widget/custom_button.dart';
import '../signup_controller.dart';

class ForgotPasswordVerificationPage extends StatefulWidget {
  const ForgotPasswordVerificationPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordVerificationPageState createState() =>
      _ForgotPasswordVerificationPageState();
}

class _ForgotPasswordVerificationPageState
    extends State<ForgotPasswordVerificationPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double headerHeight = 300;

    return Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: headerHeight,
            child: HeaderWidget(headerHeight, true, Icons.privacy_tip_outlined),
          ),
          SafeArea(
              child: Container(
            margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "resetPassword".tr,
                      style: AppStyles.headLine1,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "weHaveSent".tr,
                      style: AppStyles.bodyText2,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "ifYouRest".tr,
                      style: AppStyles.subTitle3,
                    )
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: const <Widget>[
                      SizedBox(height: 30.0),
                    ],
                  ),
                ),
                const SizedBox(height: 40.0),
                CustomPrimaryButton(
                  label: "lOGIN".tr.toUpperCase(),
                  onPresssed: () {
                    Get.offAll(const LoginView());
                  },
                ),
              ],
            ),
          )),
        ]),
      ),
    );
  }
}
