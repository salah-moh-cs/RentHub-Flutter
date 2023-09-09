import 'package:get/get.dart';

String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'pleaseEnterYourMobileNumber'.tr;
  }
  final regexp = RegExp(r'^07\d{8}$');
  if (!regexp.hasMatch(value)) {
    return '${'pleaseEnterAValidPhoneNumber'.tr}  : (ex:07xxxxxxxx)';
  }
  return null;
}

String? validateUsername(String? value) {
  if (value == null || value.isEmpty) {
    return 'pleaseEnterName'.tr;
  }
  if (value.length > 20) {
    return 'usernameShouldBe'.tr;
  }
  final regexp = RegExp(r'^[a-zA-Z ]+$');
  if (!regexp.hasMatch(value)) {
    return 'usernameShouldContainOnlyLetters'.tr;
  }
  return null;
}
