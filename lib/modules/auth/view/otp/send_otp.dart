// ignore_for_file: library_private_types_in_public_api

import 'package:email_otp/email_otp.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/core/theme/text_theme.dart';
import 'package:praduation_project/global%20widget/custom_button.dart';
import 'package:praduation_project/global%20widget/loading_widget.dart';
import 'package:praduation_project/modules/auth/controller/auth_controller.dart';
import 'package:praduation_project/data/model/user_account_model.dart';
import '../login/login_view.dart';
import '../login/widgets/signup_controller.dart';
import '../login/widgets/themehelper.dart';
import 'otp_screen.dart';

class SendOTPView extends StatefulWidget {
  const SendOTPView({Key? key}) : super(key: key);

  @override
  _SendOTPViewState createState() => _SendOTPViewState();
}

class _SendOTPViewState extends State<SendOTPView> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController email =
      TextEditingController(text: UserAccount.info!.email);
  EmailOTP myauth = EmailOTP();
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
                child: HeaderWidget(headerHeight, true, Icons.password_rounded),
              ),
              SafeArea(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'pleaseVerifyYourEmail'.tr,
                            style: AppStyles.headLine1.copyWith(
                              color: Get.theme.colorScheme.onBackground,
                            ),
                            // textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'enterYourEmail'.tr,
                            style: AppStyles.bodyText1.copyWith(
                              color: Get.theme.colorScheme.onBackground,
                            ),
                            // textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'weSendOTPToYourEmail'.tr,
                            style: AppStyles.smallButton.copyWith(
                              color: Get.theme.colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: email,
                              readOnly: true,
                              decoration: ThemeHelper().textInputDecoration(
                                  lableText: "email".tr,
                                  hintText: "enterYourEmail".tr),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "emailCan'tBeEmpty".tr;
                                } else if (!RegExp(
                                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                    .hasMatch(val)) {
                                  return "enterValidEmailAddress".tr;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 40.0),
                            CustomPrimaryButton(
                              label: "send".tr.toUpperCase(),
                              onPresssed: () async {
                                if (_formKey.currentState!.validate()) {
                                  myauth.setConfig(
                                      appEmail: "contact@hdevcoder.com",
                                      appName: "RentHub",
                                      userEmail: email.text,
                                      otpLength: 4,
                                      otpType: OTPType.digitsOnly);
                                  setState(() {
                                    isLoading =
                                        true; // Add this line to enable the loading state
                                  });
                                  if (await myauth.sendOTP() == true) {
                                    // Get.showSnackbar(const GetSnackBar(
                                    //   title: "OTP has been sent",
                                    // ));

                                    printInfo(info: email.text);

                                    Get.to(
                                      () => OtpView(
                                        email: email.text,
                                        emailOTP: myauth,
                                      ),
                                    );
                                  } else {
                                    Get.showSnackbar(GetSnackBar(
                                      title: "oopsOTPSendFailed".tr,
                                    ));
                                  }
                                  setState(() {
                                    isLoading =
                                        false; // Add this line to disable the loading state
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 30.0),
                            Row(
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: "backToLogin".tr),
                                      TextSpan(
                                        text: 'lOGIN'.tr,
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            AuthController.instance.logOut();
                                            Get.to(() => const LoginView());
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
              )
            ],
          ),
        ));
  }
}
