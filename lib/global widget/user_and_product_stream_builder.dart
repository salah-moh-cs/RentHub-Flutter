import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../data/model/user_account_model.dart';
import 'product_stream_builder.dart';

class UserAndProductStreamBuilder extends StatelessWidget {
  final bool showFavouritesOnly;
  final bool enableSlidable;
  final bool shrinkWrap;
  final String? customuuid;
  final String? categoryid;
  final bool? isaccept;
  final int? maxLenght;
  final bool? scroll;
  final String? city;
  final String? subCategory;

  UserAndProductStreamBuilder({
    Key? key,
    this.showFavouritesOnly = false,
    this.enableSlidable = true,
    this.shrinkWrap = false,
    this.customuuid,
    this.categoryid,
    this.city,
    this.scroll = true,
    this.subCategory,
    this.isaccept = true,
    this.maxLenght,
  }) : super(key: key);

  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: db.collection('users').doc(UserAccount.info!.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Fluttertoast.showToast(msg: "${"error".tr} : ${snapshot.error}");
          printInfo(info: snapshot.error.toString());
          return Center(child: Text("${snapshot.error}"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        Map<String, dynamic>? data = snapshot.data!.data();
        final favoritesList = data?['favorites'] ?? [];
        if (data != null) {
          UserAccount.info = UserAccount.formJson(data);
        }

        return ProductStreamBuilder(
          maxLenght: maxLenght,
          favoritesList: favoritesList,
          showFavouritesOnly: showFavouritesOnly,
          enableSlidable: enableSlidable,
          shrinkWrap: shrinkWrap,
          customuuid: customuuid,
          categoryid: categoryid,
          isaccept: isaccept,
          city: city,
          subCategory: subCategory,
        );
      },
    );
  }
}
