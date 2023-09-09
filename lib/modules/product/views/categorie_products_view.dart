import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/categorie_products_body.dart';

class CategorieProductsView extends StatelessWidget {
  final String productuuid;
  const CategorieProductsView({super.key, required this.productuuid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productuuid.tr),
        centerTitle: true,
      ),
      body: CategorieProductsBody(categoryId: productuuid),
    );
  }
}
