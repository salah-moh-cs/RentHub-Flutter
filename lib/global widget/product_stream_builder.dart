import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../data/model/product_model.dart';
import '../../../../global widget/product_card.dart';

class ProductStreamBuilder extends StatelessWidget {
  final List<dynamic>? favoritesList;
  final bool showFavouritesOnly;
  final bool enableSlidable;
  final bool shrinkWrap;
  final String? customuuid;

  final bool? isaccept;
  final int? maxLenght;
  final bool? scroll;
  final String? categoryid;
  final String? city;
  final String? subCategory;

  ProductStreamBuilder({
    Key? key,
    this.favoritesList,
    this.showFavouritesOnly = false,
    this.enableSlidable = true,
    this.shrinkWrap = false,
    this.customuuid,
    this.scroll = true,
    this.categoryid,
    this.city,
    this.subCategory,
    this.isaccept = true,
    this.maxLenght,
  }) : super(key: key);

  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: customuuid == null
          ? db
              .collection('products')
              .orderBy("rating", descending: true)
              .where("isaccept", isEqualTo: true)
              .where("category", isEqualTo: categoryid)
              .where("city", isEqualTo: city == 'all' ? null : city)
              .where("subcategory",
                  isEqualTo: subCategory == 'all' ? null : subCategory)
              .snapshots()
          : db
              .collection('products')
              .where("isaccept", isEqualTo: isaccept)
              .where('userId', isEqualTo: customuuid)
              .snapshots(),
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
        final values = snapshot.data!.docs;
        List<ProductModel> products = [];
        for (final val in values) {
          ProductModel product = ProductModel.fromJson(
            val.data()! as Map<String, dynamic>,
          );

          final time = DateTime.now()
              .difference(
                product.createdAt!.toDate(),
              )
              .inDays;

          if (time > 90 && product.getRates < 2) {
            // 3 months
            product.delete();
          } else {
            products.add(product);
          }
        }

        // Sort the products based on "isRent" value
        products.sort((a, b) => a.isRent == b.isRent
            ? 0
            : a.isRent
                ? 1
                : -1);

        return products.isNotEmpty
            ? ListView.builder(
                shrinkWrap: shrinkWrap,
                physics: showFavouritesOnly == true || scroll == true
                    ? const ScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                itemCount: maxLenght != null
                    ? maxLenght!.clamp(0, products.length)
                    : products.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = products[index];
                  if (showFavouritesOnly &&
                      favoritesList!.contains(product.productUid) == false) {
                    return const SizedBox();
                  }
                  return ProductCard(
                    product: product,
                    isFavorit:
                        favoritesList?.contains(product.productUid) ?? false,
                    enableSlidable: enableSlidable,
                  );
                },
              )
            : Center(
                child: Text(
                  'noProductFound'.tr,
                ),
              );
      },
    );
  }
}
