import 'package:flutter/material.dart';

colorFromHex(String hexColor) {
  final color = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$color', radix: 16));
}

const Color tOnboardingPage1Color = Color.fromARGB(255, 255, 255, 255);
const Color tOnboardingPage2Color = Color.fromARGB(255, 255, 255, 255);
const Color tOnboardingPage3Color = Color.fromARGB(255, 255, 255, 255);

Color tAppColor = colorFromHex('##00A170');
const kPrimaryColors = Color(0XFF23716C);

final Color kPrimaryColor = colorFromHex('#53B175');
final Color kShadowColor = colorFromHex('#A8A8A8');
final Color kBlackColor = colorFromHex('#181725');
final Color kSubtitleColor = colorFromHex('#7C7C7C');
final Color kSecondaryColor = colorFromHex('#F2F3F2');
final Color kBorderColor = colorFromHex('#E2E2E2');

final TextStyle kTitleStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.bold,
  color: kBlackColor,
);

final TextStyle kDescriptionStyle = TextStyle(
  color: kSubtitleColor,
  fontSize: 13,
);

const kTextColor = Color(0xFF535353);
// const kPrimaryColor = Color(0xFF0C9869);
const kTextLightColor = Color(0xFFACACAC);
const kBackgroundColor = Color(0xFFF9F8FD);
const kSecondaryColors = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);
// const kChatPrimaryColor = Color(0xFF00BF6D);
const kChatPrimaryColor = Color.fromARGB(255, 30, 88, 60);
const kDotPrimaryColor = Color.fromARGB(255, 188, 206, 198);

const kDefaultPaddin = 20.0;
