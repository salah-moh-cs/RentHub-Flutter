import 'package:flutter/material.dart';
import 'package:praduation_project/modules/product/widgets/my_product_body.dart';

class MyProductView extends StatelessWidget {
  const MyProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MyProductBody(),
    );
  }
}
