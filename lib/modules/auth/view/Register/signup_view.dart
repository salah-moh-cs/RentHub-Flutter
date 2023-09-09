import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:permission_handler/permission_handler.dart';
import 'package:praduation_project/modules/auth/controller/auth_controller.dart';
import 'package:praduation_project/global%20widget/custom_button.dart';
import '../../../../core/theme/text_theme.dart';
import '../../../../global widget/custom_card.dart';
import '../../../../global widget/loading_widget.dart';
import '../login/widgets/signup_controller.dart';
import '../login/widgets/themehelper.dart';
import 'package:praduation_project/core/utils/validators.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignupViewState();
  }
}

class _SignupViewState extends State<SignupView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;

  DatabaseReference ref = FirebaseDatabase.instance.ref().child('User');

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final usernameController = TextEditingController();
  bool isloading = false;
  late File pickedFile;
  final ImagePicker imagePicker = ImagePicker();
  XFile? image;

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      body: LoadingWidget(
        isLoading: isloading,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(
                height: Get.height * .35,
                child: HeaderWidget(Get.height * .35, false, Icons.person),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(height: Get.height * .065),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            child: Stack(
                              children: [
                                Container(
                                  height: 125,
                                  width: 125,
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      width: 5,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    // color: Colors.black,
                                    boxShadow: [
                                      BoxShadow(
                                        // color: Colors.black45,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        blurRadius: 20,
                                        offset: const Offset(5, 5),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    borderRadius: BorderRadius.circular(150),
                                    child: image?.path != null
                                        ? Image.file(
                                            File(image!.path),
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/images/person.png',
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  bottom: 10,
                                  child: Container(
                                    height: 40,
                                    width: 29,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) => bottomSheet(),
                                          backgroundColor:
                                              Get.theme.colorScheme.background,
                                        );
                                      },
                                      child: const Icon(
                                        Icons.add_circle,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Get.height * .1,
                          ),
                          TextFormField(
                            controller: usernameController,
                            validator: validateUsername,
                            decoration: ThemeHelper().textInputDecoration(
                              lableText: "fullName".tr,
                              hintText: "enterYourFullName".tr,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: emailController,
                            decoration: ThemeHelper().textInputDecoration(
                                lableText: 'e_mailAddress'.tr,
                                hintText: "enterYourEmail".tr),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'pleaseEnterYourEmailAddress'.tr;
                              }
                              if (!RegExp(
                                      "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                  .hasMatch(val)) {
                                return 'pleaseEnterCorrectEmailAddress'.tr;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                              controller: phoneController,
                              decoration: ThemeHelper().textInputDecoration(
                                  lableText: "mobileNumber".tr,
                                  hintText: "enterYourMobileNumber".tr),
                              keyboardType: TextInputType.phone,
                              validator: validatePhoneNumber),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: passwordController,
                            obscureText: !showPassword,
                            decoration: ThemeHelper().textInputDecoration(
                                lableText: "Password".tr,
                                hintText: "enterYourPassword".tr,
                                isPassword: true,
                                showPassword: showPassword,
                                onPasswordChange: (val) {
                                  setState(() => showPassword = val);
                                }),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'pleaseEnterYourPassword'.tr;
                              }
                              if (val.length < 8) {
                                return 'passwordTooShort'.tr;
                              }
                              if (!RegExp(r'^(?=.*[0-9])').hasMatch(val)) {
                                return 'passwordMustContainNumber'.tr;
                              }
                              if (!RegExp(r'^(?=.*[!@#\$%\^&\*])')
                                  .hasMatch(val)) {
                                return 'passwordMustContainSpecialCharacter'.tr;
                              }
                              if (!RegExp(r'^(?=.*[a-z])').hasMatch(val)) {
                                return 'passwordMustContainLowercaseLetter'.tr;
                              }
                              if (!RegExp(r'^(?=.*[A-Z])').hasMatch(val)) {
                                return 'passwordMustContainUppercaseLetter'.tr;
                              }
                              // if (!RegExp(r'.{8,}$').hasMatch(val)) {
                              //   return 'passwordLengthMustBeAtLeast8Characters'.tr
                              //       .tr;
                              // }
                              // if (!RegExp(
                              //         r'^(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.*[a-z])(?=.*[A-Z]).{8,}$')
                              //     .hasMatch(val)) {
                              //   return 'passwordMustContainNumberAndSpecialCharacter'
                              //       .tr;
                              // }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: confirmPasswordController,
                            obscureText: !showPassword,
                            decoration: ThemeHelper().textInputDecoration(
                                lableText: "confirmPassword".tr,
                                hintText: "enterYourConfirmPassword".tr,
                                isPassword: true,
                                showPassword: showPassword,
                                onPasswordChange: (val) {
                                  setState(() => showPassword = val);
                                }),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'pleaseEnterRe_password'.tr;
                              }
                              if (passwordController.text !=
                                  confirmPasswordController.text) {
                                return 'passwordDoesNotMatch'.tr;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15.0),
                          FormField<bool>(
                            builder: (state) {
                              return Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Checkbox(
                                          value: checkboxValue,
                                          onChanged: (value) {
                                            setState(() {
                                              checkboxValue = value!;
                                              state.didChange(value);
                                            });
                                          }),
                                      Text(
                                        "iAcceptAllTermsAndConditions".tr,
                                        style: AppStyles.smallButton,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      state.errorText ?? '',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                            validator: (value) {
                              if (!checkboxValue) {
                                return 'youNeedToAcceptTermsAndConditions'.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 20.0),
                          CustomPrimaryButton(
                            label: "register".tr.toUpperCase(),
                            onPresssed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (image?.path != null) {
                                  setState(() {
                                    isloading = true;
                                  });
                                  await uploadPfp().then((value) async {});
                                  String value = await getDownload();
                                  return AuthController()
                                      .createUserWithEmailAndPassword(
                                    emailController.text.trim(),
                                    passwordController.text,
                                    value,
                                    usernameController.text,
                                    phoneController.text,
                                    false,
                                  )
                                      .then((value) {
                                    setState(() {
                                      isloading = false;
                                    });
                                  });
                                }
                                Get.showSnackbar(GetSnackBar(
                                  title: "error".tr,
                                  message: "pleaseEnterYourImage".tr,
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                ));
                              } else {
                                if (kDebugMode) {
                                  print("unSuccessFull".tr);
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: Get.height * .35,
      width: Get.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Center(
            child: Text(
              "chosesProfilePhoto".tr,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: CustomCard(
                  title: "camera".tr,
                  icons: Icons.camera,
                  onTap: () {
                    takePhoto(ImageSource.camera);
                  },
                ),
              ),
              Expanded(
                child: CustomCard(
                  title: "gallery".tr,
                  icons: Icons.image,
                  onTap: () {
                    takePhoto(ImageSource.gallery);
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final permissionStatus = await Permission.camera.request();

    if (permissionStatus.isGranted) {
      image = await imagePicker.pickImage(source: source);
      if (image != null) {
        Get.back();
        setState(() {});
      }
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Camera Permission Required'.tr),
            content: Text('Please grant camera permission to take photos.'.tr),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
                child: Text('Go to Settings'.tr),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> uploadPfp() async {
    File uploadFile = File(image!.path);
    await firebase_storage.FirebaseStorage.instance
        .ref('uploads/${uploadFile.path}')
        .putFile(uploadFile);
  }

  Future<String> getDownload() async {
    File uploadFile = File(image!.path);
    return firebase_storage.FirebaseStorage.instance
        .ref('uploads/${uploadFile.path}')
        .getDownloadURL();
  }
}
