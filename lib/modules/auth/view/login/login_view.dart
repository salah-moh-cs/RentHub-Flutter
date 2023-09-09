import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:praduation_project/modules/auth/view/login/widgets/forget_page/forgetpassword.dart';
import 'package:praduation_project/modules/auth/view/login/widgets/signup_controller.dart';
import 'package:praduation_project/modules/auth/view/login/widgets/themehelper.dart';
import '../../../../core/theme/text_theme.dart';
import '../../../../core/utils/helpers/custom_dialog.dart';
import '../../../../global widget/custom_button.dart';
import '../../../../global widget/loading_widget.dart';
import '../../controller/auth_controller.dart';
import '../Register/signup_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final double _headerHeight = Get.height * .35;
  final Key _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;
  bool isLoading = false;
  int loginAttempts = 0;
  bool isBlocked = false;
  DateTime blockEndTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    // ignore: unnecessary_null_comparison
    if (blockEndTime != null && DateTime.now().isBefore(blockEndTime)) {
      isBlocked = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      Phoenix.rebirth(context);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      body: LoadingWidget(
        isLoading: isLoading,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: _headerHeight,
              child: HeaderWidget(
                _headerHeight,
                true,
                Icons.store_rounded,
              ),
            ),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    Text(
                      'welcomeToyourSooq'.tr,
                      style: AppStyles.headLine1.copyWith(
                        color: Get.theme.colorScheme.onBackground,
                      ),
                    ),
                    Text(
                      'signInIntoYourAccount'.tr,
                      style: AppStyles.bodyText2,
                    ),
                    const SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextField(
                            controller: emailController,
                            decoration: ThemeHelper().textInputDecoration(
                              lableText: 'email'.tr,
                              hintText: 'enterYourEmail'.tr,
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          TextField(
                            controller: passwordController,
                            obscureText: !showPassword,
                            decoration: ThemeHelper().textInputDecoration(
                              lableText: 'Password'.tr,
                              hintText: 'enterYourPassword'.tr,
                              isPassword: true,
                              showPassword: showPassword,
                              onPasswordChange: (val) {
                                setState(() {
                                  showPassword = val;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 25.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  CustomDialog.showYesNoDialog(
                                    barrierDismissible: false,
                                    title: 'continueAsGst'.tr,
                                    content: "continueAsGstcontent".tr,
                                    yesButtonText: "continue".tr,
                                    noButtonText: "back".tr,
                                    onYesPressed: () {
                                      AuthController.instance.guestLogin();
                                    },
                                  );
                                },
                                child: Text(
                                  'continueAsGst'.tr,
                                  style: AppStyles.smallButton.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Get.theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => const ForgotPasswordPage());
                                },
                                child: Text(
                                  "forgotYourPassword".tr,
                                  style: AppStyles.smallButton.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25.0),
                          CustomPrimaryButton(
                            label: 'signIn'.tr.toUpperCase(),
                            onPresssed: () async {
                              if (isBlocked &&
                                  DateTime.now().isBefore(blockEndTime)) {
                                final remainingTime =
                                    blockEndTime.difference(DateTime.now());
                                final seconds = remainingTime.inSeconds;

                                final errorMessage =
                                    "${"blockedErrorMessage".tr} $seconds ${"seconds".tr}";
                                final snackBar =
                                    SnackBar(content: Text(errorMessage));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                return;
                              }

                              setState(() => isLoading = true);
                              final check = await AuthController.instance.login(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );

                              if (check != true) {
                                loginAttempts++;

                                if (loginAttempts >= 3) {
                                  const blockDuration = Duration(seconds: 30);
                                  blockEndTime =
                                      DateTime.now().add(blockDuration);
                                  isBlocked = true;

                                  loginAttempts = 0;
                                }

                                setState(() => isLoading = false);
                              }
                            },
                          ),
                          Row(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "${"doNotHaveAnAccount".tr}  ",
                                      ),
                                      TextSpan(
                                        text: 'create'.tr,
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.to(() => const SignupView());
                                          },
                                        style: AppStyles.smallButton.copyWith(
                                          color: Get.theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Text(
                                "oR".tr,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 25.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: InkWell(
                                  child: SvgPicture.asset(
                                    'assets/icons/Google_Icons.svg',
                                    width: Get.width * .08,
                                  ),
                                ),
                                onTap: () {
                                  AuthController.instance.googleSignInMethod();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
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
