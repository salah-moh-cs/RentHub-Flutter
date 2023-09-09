// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/modules/admin/bindings/admin_home_binding.dart';
import 'package:praduation_project/modules/admin/views/admin_home_view.dart';
import 'package:praduation_project/modules/auth/controller/auth_controller.dart';
import 'package:praduation_project/modules/favorites/views/favorite_view.dart';
import 'package:praduation_project/modules/auth/view/login/login_view.dart';
import 'package:praduation_project/data/model/user_account_model.dart';

import '../../../core/value/languages/language_dialog.dart';
import '../../../global widget/custom_user_accounts_drawer_header.dart';
import '../../about/about.dart';
import '../../favorites/bindings/favorite_binding.dart';

class HomeDrawers extends StatefulWidget {
  const HomeDrawers({Key? key}) : super(key: key);

  @override
  _HomeDrawersState createState() => _HomeDrawersState();
}

class _HomeDrawersState extends State<HomeDrawers> {
  final any = AuthController.instance.isUserSignedInAnonymously();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 225,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            CustomUserAccountsDrawerHeader(),
            if (UserAccount.info!.isAdmin)
              any
                  ? const SizedBox()
                  : ListTile(
                      leading: const Icon(Icons.admin_panel_settings),
                      title: Text('admin'.tr),
                      onTap: () {
                        Get.back();
                        Get.to(
                          () => const AdminHomeView(),
                          binding: AdminHomeBinding(),
                        );
                      },
                    ),
            any
                ? const SizedBox()
                : ListTile(
                    leading: const Icon(Icons.notifications),
                    title: Text("favorites".tr),
                    onTap: () {
                      Get.back();
                      Get.to(() => const FavoriteView(),
                          binding: FavoriteBinding());
                    },
                    trailing: ClipOval(
                      child: Container(
                        color: UserAccount.info!.favorites == null
                            ? Colors.red
                            : Colors.green,
                        height: 20,
                        width: 20,
                        child: Center(
                          child: Text(
                            UserAccount.info?.favorites?.length.toString() ??
                                "0",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text('languagee'.tr),
              onTap: () {
                Get.dialog(const SelectedLanguageDialog());
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.code),
              title: Text("about".tr),
              onTap: () {
                Get.back();
                Get.to(() => const AboutScreen());
                // print(UserAccount.info);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: Text("logout".tr),
              onTap: () {
                AuthController.instance.logOut();
                Get.offAll(const LoginView());
              },
            ),
          ],
        ),
      ),
    );
  }
}
