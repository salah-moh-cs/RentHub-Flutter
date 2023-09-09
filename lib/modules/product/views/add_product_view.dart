import 'package:flutter/material.dart';
import 'package:praduation_project/modules/product/widgets/add_product_appbar.dart';

import '../widgets/add_product_body.dart';

class AddProductView extends StatelessWidget {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AddProductAppBar(),
      body: AddProductBody(),
    );
  }
}
