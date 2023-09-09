import 'package:flutter/material.dart';
import 'package:praduation_project/data/model/user_account_model.dart';

import '../../../global widget/user_and_product_stream_builder.dart';

class MyProductBody extends StatelessWidget {
  const MyProductBody({super.key});

  @override
  Widget build(BuildContext context) {
    return UserAndProductStreamBuilder(
      isaccept: null,
      shrinkWrap: true,
      customuuid: UserAccount.info!.uid,
    );
  }
}
