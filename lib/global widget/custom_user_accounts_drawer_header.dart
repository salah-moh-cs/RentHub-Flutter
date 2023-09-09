import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/model/user_account_model.dart';
import '../modules/auth/controller/auth_controller.dart';
import '../modules/user_profile/view/current_user_profile_view.dart';

class CustomUserAccountsDrawerHeader extends StatefulWidget {
  const CustomUserAccountsDrawerHeader({
    super.key,
  });

  @override
  State<CustomUserAccountsDrawerHeader> createState() =>
      _CustomUserAccountsDrawerHeaderState();
}

class _CustomUserAccountsDrawerHeaderState
    extends State<CustomUserAccountsDrawerHeader> {
  final isAnonymous = AuthController.instance.isUserSignedInAnonymously();

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: isAnonymous
          ? const Text("Welcome to RentHub")
          : Text(
              UserAccount.info!.username,
              style: const TextStyle(color: Colors.white),
            ),
      accountEmail:
          isAnonymous ? const SizedBox() : Text(UserAccount.info!.email),
      currentAccountPicture: isAnonymous
          ? const SizedBox()
          : Material(
              color: Colors.black26,
              elevation: 8,
              borderRadius: BorderRadius.circular(50),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                splashColor: Colors.black26,
                onTap: () {
                  if (UserAccount.info!.isAdmin) return;

                  Get.back();
                  Get.to(() => const CurrentUserProfileView());
                },
                child: Ink.image(
                  image: CachedNetworkImageProvider(
                    UserAccount.info!.imageurl,
                  ),
                  height: Get.height * 0.2,
                  width: Get.width * 0.2,
                  fit: BoxFit.cover,
                ),
              ),
            ),
      decoration: BoxDecoration(
        color: Colors.black26,
        image: DecorationImage(
          image: !Get.isDarkMode
              ? const AssetImage("assets/images/dark.jpg")
              : const AssetImage("assets/images/light.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      otherAccountsPictures: [
        ThemeSwitcher(
          builder: (context) => IconButton(
            tooltip: EasyDynamicTheme.of(context).themeMode == ThemeMode.system
                ? "System"
                : !Get.isDarkMode
                    ? "Dark"
                    : "Light",
            icon: Icon(
              EasyDynamicTheme.of(context).themeMode == ThemeMode.system
                  ? Icons.brightness_auto
                  : Get.isDarkMode
                      ? Icons.brightness_2
                      : Icons.wb_sunny_outlined,
              color: EasyDynamicTheme.of(context).themeMode == ThemeMode.system
                  ? Colors.white
                  : Colors.amber,
            ),
            onPressed: () {
              EasyDynamicTheme.of(context).changeTheme();
              Get.back();
            },
          ),
        ),
      ],
    );
  }
}
