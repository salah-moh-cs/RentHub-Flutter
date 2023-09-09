import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/core/utils/helpers/system_helper.dart';
import 'package:praduation_project/data/model/product_model.dart';

import '../../../core/utils/helpers/custom_dialog.dart';
import '../../../data/model/user_account_model.dart';

class ProductController extends GetxController {
  late PageController pageController;
  late TextEditingController commentController;
  late ProductModel product;
  List<Map<String, dynamic>> comments = [];
  List<Map<String, dynamic>> reports = [];
  final FirebaseFirestore db = FirebaseFirestore.instance;

  late bool isRented;

  RxInt currentIndex = 0.obs;
  RxBool isCommentEmpty = true.obs;
  RxBool updateUI = false.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentIndex.value);
    commentController = TextEditingController();

    commentController.addListener(() {
      isCommentEmpty(commentController.text.isEmpty);
    });
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
  }

  void initProduct(ProductModel product) {
    try {
      this.product = product;
      comments = product.comments ?? [];
      isRented = product.isRent;
      update();
    } catch (e) {
      e.printError();
    }
  }

  void onPageChanged(int index) {
    currentIndex(index);
  }

  void onDotClicked(int index) {
    currentIndex(index);
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
    );
  }

  Future<void> sendComment() async {
    try {
      final comment = commentController.text;

      product.addComment(comment: comment);
      commentController.clear();
      comments = product.comments ?? [];

      SystemHelper.closeKeyboard();

      update();
    } catch (e) {
      e.printError();
    }
  }

  Future<void> deleteComment({required int index}) async {
    try {
      await product.deleteComment(index);
      comments = product.comments ?? [];
      update();
    } catch (e) {
      e.printError();
    }
  }

  Future<void> changeRented() async {
    try {
      isRented = product.isRent;
      product.changeRented();
      update();
    } catch (e) {
      e.toString();
    }
  }

  Future<void> addfavorites() async {
    try {
      final productuuid = product.productUid!;
      UserAccount.info!.addToFavorites(productuuid);
      update();
    } catch (e) {
      e.toString();
    }
  }

  Future<void> removefavorites() async {
    try {
      final productuuid = product.productUid!;
      UserAccount.info!.removeFromFavorites(productuuid);
      update();
    } catch (e) {
      e.toString();
    }
  }

  Future<void> rate() async {
    try {
      CustomDialog.showRatingDialog(product: product);

      update();
    } catch (e) {
      e.toString();
    }
  }
}
