import 'package:flutter/material.dart';
import '../../../global widget/user_and_product_stream_builder.dart';

class AllproductBody extends StatelessWidget {
  const AllproductBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: UserAndProductStreamBuilder(
        shrinkWrap: true,
      ),
    );
  }
}
