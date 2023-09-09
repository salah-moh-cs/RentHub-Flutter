import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdminHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(builder: (context) {
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        );
      }),
      title: Text("adminhome".tr),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
