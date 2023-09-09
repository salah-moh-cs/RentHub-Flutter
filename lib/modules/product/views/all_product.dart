import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/modules/product/widgets/all_product.dart';

class AllProductView extends StatelessWidget {
  const AllProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("all".tr),
        centerTitle: true,
      ),
      body: const AllproductBody(),
    );
  }
}
