import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';
import '../widgets/favorite_appbar.dart';
import '../widgets/favorite_body.dart';

class FavoriteView extends GetView<FavoriteController> {
  const FavoriteView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FavoriteAppBar(),
      body: FavoriteBody(),
    );
  }
}
