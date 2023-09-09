import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoriteAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FavoriteAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('favorites'.tr),
      centerTitle: true,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
