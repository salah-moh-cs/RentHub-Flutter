import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/edit_product_body.dart';

class EditProductView extends StatelessWidget {
  const EditProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("editproduct".tr),
      ),
      body: const EditProductBody(),
    );
  }
}
