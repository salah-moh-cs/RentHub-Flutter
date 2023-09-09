import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/helpers/system_helper.dart';
import '../../../data/model/chatuser_db.dart';

import '../../../data/model/user_account_model.dart';
import 'custom_header_widget.dart';
import 'custom_profile_listtile.dart';
import 'custom_stream_user_products.dart';

class UserProfileBody extends StatelessWidget {
  const UserProfileBody({
    super.key,
    required this.user,
  });

  final UserAccountChat user;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      children: <Widget>[
        const SizedBox(height: 20),
        CustomHeaderWidget(user: user),
        CustomProfileListTile(
          label: user.phoneNumber,
          icons: Icons.phone,
          onTap: () => SystemHelper.makeCall(user.phoneNumber),
        ),
        CustomProfileListTile(
          label: user.email,
          icons: Icons.email,
        ),
        const SizedBox(height: 20),
        CustomStreamUserProducts(user: user),
        SizedBox(height: Get.height * .1),
      ],
    );
  }
}

class CurrentUserProfileBody extends StatelessWidget {
  const CurrentUserProfileBody({
    super.key,
    required this.user,
  });

  final UserAccount user;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      children: <Widget>[
        const SizedBox(height: 20),
        CustomCurrentHeaderWidget(
          user: user,
        ),
        CustomProfileListTile(
          label: user.username,
          icons: Icons.person,
          showCopyButton: false,
        ),
        CustomProfileListTile(
          label: user.email,
          icons: Icons.email,
          showCopyButton: false,
        ),
        CustomProfileListTile(
          label: user.phoneNumber,
          icons: Icons.phone,
          showCopyButton: false,
        ),
        SizedBox(height: Get.height * .1),
      ],
    );
  }
}
