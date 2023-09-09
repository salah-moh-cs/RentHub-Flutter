import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AddProductAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('addProduct'.tr),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
