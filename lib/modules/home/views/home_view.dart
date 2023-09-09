// ignore_for_file: unused_element

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:praduation_project/modules/product/views/add_product_view.dart';
import '../../../core/utils/helpers/update_dailog.dart';
import '../../../data/services/database.dart';
import '../../auth/controller/auth_controller.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_appbar.dart';
import '../widgets/home_body.dart';
import '../widgets/home_bottomappbar.dart';
import '../widgets/home_drawers.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final any = AuthController.instance.isUserSignedInAnonymously();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      drawer: const HomeDrawers(),
      body: const HomeBody(),
      floatingActionButton: any == true
          ? const SizedBox()
          : Obx(() {
              switch (controller.currentPage.value) {
                case 0:
                  return const _AddProductButton();
                case 2:
                  return const _AddProductButton();
                case 3:
                  return const _EditUserAccountButton();

                default:
                  return const SizedBox();
              }
            }),
      bottomNavigationBar: const HomeBottomAppBar(),
    );
  }
}

class _AddProductButton extends StatelessWidget {
  const _AddProductButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: "addProduct".tr,
      onPressed: () {
        Get.put(DatabaseFirestore());
        Get.to(() => const AddProductView());
      },
      child: const Icon(Icons.add),
    );
  }
}

class _EditUserAccountButton extends StatelessWidget {
  const _EditUserAccountButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: "edit".tr,
      onPressed: () {
        Get.dialog(EditCurrentUserDialog());
      },
      child: const Icon(Icons.edit),
    );
  }
}
