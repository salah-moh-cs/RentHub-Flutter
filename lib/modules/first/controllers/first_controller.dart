import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/modules/first/model/category_model.dart';

import '../../../constants/image.dart';
import '../model/advertisements_model.dart';

class FirstController extends GetxController {
  List<CategoryModel> categories = [
    const CategoryModel(
      imageAssets: "assets/images/immovables.png",
      label: 'immovables',
      id: 'immovables',
    ),
    const CategoryModel(
      imageAssets: "assets/images/vehciles.png",
      label: 'vehciles',
      id: 'vehciles',
    ),
    const CategoryModel(
      imageAssets: "assets/images/electronics.png",
      label: 'electronic',
      id: 'electronic',
    ),
    const CategoryModel(
      imageAssets: "assets/images/clothes.png",
      label: 'clothes',
      id: "clothes",
    ),
    const CategoryModel(
      imageAssets: "assets/images/animal.png",
      label: 'animals',
      id: "animals",
    ),
    const CategoryModel(
      imageAssets: "assets/images/equipment.png",
      label: 'industrialEquipment',
      id: "industrial equipment",
    ),
    const CategoryModel(
      imageAssets: "assets/images/other.png",
      label: 'others',
      id: "others",
    )
  ];

  List<AdvertisementModel> advertisements = [
    AdvertisementModel(
      uuid: "1",
      title: "Title 1",
      subTitle: "subTitle 1",
      imageAsset: kAppLogoLight,
    ),
    AdvertisementModel(
      uuid: "2",
      title: "Title 2",
      subTitle: "subTitle 2",
      imageAsset: kAppLogoDark,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    ),
  ];
}
