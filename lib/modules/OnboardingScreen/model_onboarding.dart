import 'dart:ui';

class OnBoardingModel {
  final String? assetImage;
  final String? lottieImage;
  final String title;
  final String subTitle;
  final String counterText;

  final Color? titleColor;
  final Color? subTitleColor;
  final Color? backgroundColor;
  final double height;

  OnBoardingModel({
    this.assetImage,
    this.lottieImage,
    required this.title,
    required this.subTitle,
    required this.counterText,
    required this.height,
    this.titleColor,
    this.subTitleColor,
    this.backgroundColor,
  });
}
