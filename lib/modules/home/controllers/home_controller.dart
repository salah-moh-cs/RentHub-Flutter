import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/modules/first/views/first_view.dart';

import '../../../core/utils/helpers/custom_dialog.dart';
import '../../../data/model/product_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../product/views/my_products_view.dart';
import '../../user_profile/view/current_user_profile_view.dart';
import '../../userchat/user_chat.dart';
import '../model/view_moel.dart';

class HomeController extends GetxController {
  final any = AuthController.instance.isUserSignedInAnonymously();

  late final PageController pageController;
  RxInt currentPage = 0.obs;
  Timer? timer;
  List<ProductModel> products = [];

  List<ViewModel> views = [
    ViewModel(label: "home", icons: Icons.home, view: const FirstView()),
    ViewModel(label: 'chat', icons: Icons.chat, view: const ChatUser()),
    ViewModel(
      label: 'myproduct',
      icons: Icons.production_quantity_limits,
      view: const MyProductView(),
    ),
    ViewModel(
      label: 'account',
      icons: Icons.person_2,
      view: const CurrentUserProfileView(),
    ),
  ];
  void goToIndex(int index) {
    // printInfo(info: "scroll$index");
    if (any == true) {
      if (index == 1 || index == 2 || index == 3) {
        CustomDialog.buildguestdialog(Get.context!);
      }
    } else {
      pageController.jumpToPage(
        index,
        // duration: const Duration(milliseconds: 1000),
        // curve: Curves.bounceInOut,
      );
    }
    currentPage(index);
  }

  void onPageChanged(int index) {
    currentPage(index);
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    fetchProducts();
    checkProducts();
    const duration = Duration(seconds: 5);
    timer = Timer.periodic(duration, (timer) {
      printInfo(info: "check product done");
      checkProducts();
    });
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
    timer?.cancel();
  }

  void fetchProducts() {
    FirebaseFirestore.instance
        .collection('products')
        .orderBy("rating", descending: true)
        .where("isaccept", isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      products.clear();
      for (final val in snapshot.docs) {
        ProductModel product =
            // ignore: unnecessary_cast
            ProductModel.fromJson(val.data() as Map<String, dynamic>);
        products.add(product);
      }
      update(); // Use update() to notify the UI about changes in products
    });
  }

  void checkProducts() {
    for (ProductModel product in products) {
      // print("object");
      if (product.isRent && product.getTimeDifference(0) == "") {
        printInfo(info: product.getTimeDifference(0));

        product.updateRentStatus(product, !product.isRent);

        // Add this method to your ProductModel class to update the product in the database
      }
    }
  }
}
