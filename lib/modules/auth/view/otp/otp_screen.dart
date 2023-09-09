import 'dart:async';

import 'package:email_otp/email_otp.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/global%20widget/custom_button.dart';
import 'package:praduation_project/global%20widget/loading_widget.dart';
import 'package:praduation_project/modules/home/views/home_view.dart';
import '../../../../core/theme/text_theme.dart';
import '../../../../data/model/user_account_model.dart';
import '../../../home/bindings/home_binding.dart';
import '../login/widgets/signup_controller.dart';
import 'widgets/otp_text_form_field.dart';

class OtpView extends StatefulWidget {
  const OtpView({Key? key, required this.emailOTP, this.email})
      : super(key: key);
  final EmailOTP emailOTP;
  final String? email;
  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  TextEditingController otpController = TextEditingController();

  Timer? _timer;
  int _start = 120; // start time in seconds

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() => timer.cancel());
        } else {
          setState(() => _start--);
        }
      },
    );
  }

  bool isLoading = false;

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
              child:
                  HeaderWidget(headerHeight, true, Icons.privacy_tip_outlined),
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
                          'verification'.tr,
                          style: AppStyles.headLine1.copyWith(
                            color: Get.theme.colorScheme.onBackground,
                          ),
                          // textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'enterTheVerification'.tr,
                          style: AppStyles.bodyText1.copyWith(
                            color: Get.theme.colorScheme.onBackground,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (widget.email != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.email ?? '',
                                style: AppStyles.subTitle3,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(width: 5),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: OtpTextFormField(
                            otpController: otpController,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: "notrecotp".tr),
                              TextSpan(
                                text: _start > 0
                                    ? _start > 59
                                        ? "${"resendafter".tr} ${(_start / 60).toStringAsFixed(2)} ${"min".tr}"
                                        : "${"resendafter".tr} $_start ${"sec".tr}"
                                    : 'resendotp'.tr,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    if (_start < 0) return;
                                    // resend OTP
                                    _start = 120; // reset the timer
                                    startTimer(); // start the timer again
                                    widget.emailOTP
                                        .sendOTP(); // send the OTP again
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
                    const SizedBox(height: 30.0),
                    CustomPrimaryButton(
                      label: "confirm".tr,
                      onPresssed: () async {
                        if (await widget.emailOTP
                                .verifyOTP(otp: otpController.text) ==
                            true) {
                          setState(() {
                            isLoading = true;
                          });
                          UserAccount.info!.updateIsVerify(true);
                          setState(() {
                            isLoading = false;
                          });
                          Get.off(() => HomeView(), binding: HomeBinding());
                        } else {
                          Get.snackbar(
                            "Info",
                            "${"invalid".tr} OTP",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                    ),
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
