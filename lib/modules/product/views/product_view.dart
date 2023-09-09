import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:praduation_project/data/model/product_model.dart';
import 'package:praduation_project/data/model/user_account_model.dart';
import 'package:praduation_project/modules/product/widgets/product_body.dart';

import '../controllers/product_controller.dart';
import '../widgets/product_appbar.dart';
import 'product_deleted_view.dart';

class ProductView extends GetView<ProductController> {
  final String productuuid;
  ProductView({Key? key, required this.productuuid}) : super(key: key);
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.collection('products').doc(productuuid).snapshots(),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
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
        try {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final product = ProductModel.fromJson(data);
          if (product.productUid != null && product.isacceptadmin) {
            controller.initProduct(product);

            return Scaffold(
              appBar: const ProductAppBar(),
              body: ProductBody(),
            );
          } else {
            controller.initProduct(product);
            final isSameUser =
                UserAccount.info!.uid == controller.product.userId;

            return UserAccount.info!.isAdmin || isSameUser
                ? Scaffold(
                    appBar: const ProductAppBar(),
                    body: ProductBody(
                      adm: true,
                    ),
                  )
                : const ProductDeletedView();
          }
        } catch (e) {
          return const ProductDeletedView();
        }
      },
    );
  }
}
