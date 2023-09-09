import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/chatuser_db.dart';
import '../../../global widget/user_and_product_stream_builder.dart';

class CustomStreamUserProducts extends StatelessWidget {
  final UserAccountChat user;
  const CustomStreamUserProducts({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${'productFor'.tr} ${user.username}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        UserAndProductStreamBuilder(
          shrinkWrap: true,
          customuuid: user.uid,
        ),
      ],
    );
  }
}
