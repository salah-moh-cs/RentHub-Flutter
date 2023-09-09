// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AdvertisementModel {
  final String uuid;
  final String title;
  final String? subTitle;
  final String? imageUrl;
  final String? imageAsset;
  final Color? backgroundColor;
  final Color? textColor;

  AdvertisementModel({
    required this.uuid,
    required this.title,
    this.subTitle,
    this.imageUrl,
    this.imageAsset,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  });
}
