// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/modules/auth/view/Register/signup_view.dart';
import 'package:praduation_project/core/theme/text_theme.dart';
import 'package:praduation_project/core/utils/helpers/custom_dialog.dart';
import 'package:praduation_project/global%20widget/loading_widget.dart';
import '../../../../../../global widget/custom_button.dart';
import '../signup_controller.dart';
import '../themehelper.dart';
import 'forgetpass_varfication.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController forgetPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<bool> checkEmailExists(String email) async {
    try {
      var signInMethods = await _auth.fetchSignInMethodsForEmail(email);
      return signInMethods.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking email existence: $e');
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double headerHeight = 300;
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      body: LoadingWidget(
        isLoading: isLoading,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: headerHeight,
              child: HeaderWidget(
                headerHeight,
                true,
                Icons.password_rounded,
              ),
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
                          'forgotYourPassword'.tr,
                          style: AppStyles.headLine1.copyWith(
                            color: Get.theme.colorScheme.onBackground,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'enterTheEmailAddress'.tr,
                          style: AppStyles.bodyText2,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'weWillEmailYou'.tr,
                          style: AppStyles.subTitle3,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: forgetPasswordController,
                            decoration: ThemeHelper().textInputDecoration(
                              lableText: "email".tr,
                              hintText: "enterYourEmail".tr,
                            ),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "emailCan'tBeEmpty".tr;
                              } else if (!RegExp(
                                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
                              ).hasMatch(val)) {
                                return "enterValidEmailAddress".tr;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40.0),
                          CustomPrimaryButton(
                            label: "send".tr.toUpperCase(),
                            onPresssed: () async {
                              setState(() => isLoading = true);
                              if (_formKey.currentState!.validate()) {
                                var forgetEmail =
                                    forgetPasswordController.text.trim();
                                try {
                                  bool emailExists =
                                      await checkEmailExists(forgetEmail);
                                  if (emailExists) {
                                    FirebaseAuth.instance
                                        .sendPasswordResetEmail(
                                            email: forgetEmail)
                                        .then((value) => {
                                              printInfo(info: "Email sent!"),
                                              Get.off(
                                                () =>
                                                    const ForgotPasswordVerificationPage(),
                                              ),
                                            });
                                  } else {
                                    CustomDialog.showYesNoDialog(
                                      title: "emailnotfound".tr,
                                      content: "emailnotfoundcontent".tr,
                                      yesButtonText: "register".tr,
                                      noButtonText: "cancel".tr,
                                      onYesPressed: () {
                                        Get.to(() => const SignupView());
                                      },
                                    );
                                    printError(info: 'Email does not exist');
                                  }
                                } catch (e) {
                                  printError(info: "Error $e");
                                }
                              }

                              setState(() => isLoading = false);
                            },
                          ),
                          const SizedBox(height: 30.0),
                          Row(
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "${"rememberYourPassword".tr}  "),
                                    TextSpan(
                                      text: 'lOGIN'.tr,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.back();
                                        },
                                      style: AppStyles.smallButton.copyWith(
                                        color: Get.theme.colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
