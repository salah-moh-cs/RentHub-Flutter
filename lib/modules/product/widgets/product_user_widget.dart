// ignore_for_file: unused_element

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:praduation_project/core/theme/text_theme.dart';
import 'package:praduation_project/data/model/user_account_model.dart';
import 'package:praduation_project/modules/product/controllers/product_controller.dart';
import 'package:praduation_project/modules/user_profile/view/user_profile_view.dart';

import '../../../core/utils/helpers/system_helper.dart';
import '../../../data/model/chatuser_db.dart';
import '../../../data/services/chat_db.dart';
import '../../../data/services/database.dart';
import '../../../global widget/custom_button.dart';

class ProductUserWidget extends GetView<ProductController> {
  const ProductUserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final marktuuid = controller.product.userId!;
    final isSameUser = UserAccount.info!.uid == controller.product.userId!;
    if (isSameUser) return const SizedBox();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: DatabaseFirestore.getUserById(marktuuid),
          builder: (context, AsyncSnapshot<UserAccountChat?> snapshot) {
            if (snapshot.hasError) {
              Fluttertoast.showToast(msg: snapshot.error.toString());
              return Center(
                child: Text("${"error".tr} ..."),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const _LoadingListTile();
            }

            UserAccountChat? user = snapshot.data;

            if (user != null && user.uid != null) {
              return ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(user.imageurl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  user.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(user.phoneNumber),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      width: 20,
                      padding: const EdgeInsets.all(8.0),
                      label: const Icon(Icons.call),
                      color: Colors.green,
                      onPressed: () => SystemHelper.makeCall(user.phoneNumber),
                    ),
                    CustomButtonWithLoading(
                      width: 20,
                      padding: const EdgeInsets.all(8.0),
                      label: const Icon(Icons.message),
                      color: Colors.blue,
                      loadingColor: Get.theme.colorScheme.onBackground,
                      onPressed: () async {
                        await ChatDatabase.chatChecker(uuid: user.uid!);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Get.to(() => UserProfileView(user: user));
                },
              );
            } else {
              return const _LoadingListTile(hasError: true);
            }
          },
        ),
      ),
    );
  }
}

class _LoadingListTile extends StatelessWidget {
  final bool hasError;
  const _LoadingListTile({this.hasError = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: hasError ? Colors.transparent : Colors.grey,
        ),
        child: hasError
            ? Icon(
                Icons.error_rounded,
                color: Colors.red,
                size: Get.height * .06,
              )
            : null,
      ),
      title: Container(
        height: 20,
        width: Get.width * .1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: hasError ? Colors.transparent : Colors.grey,
        ),
        child: Text(
          "userNotFound".tr,
          style: AppStyles.subTitle3,
        ),
      ),
      subtitle: Container(
        height: hasError ? 4 : 12,
        width: Get.width * .1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: hasError ? Colors.red : Colors.grey,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: hasError
            ? []
            : [
                CustomButton(
                  width: 20,
                  padding: const EdgeInsets.all(18.0),
                  color: hasError ? Colors.red : Colors.grey,
                  onPressed: () {},
                ),
                CustomButton(
                  width: 20,
                  padding: const EdgeInsets.all(18.0),
                  color: hasError ? Colors.red : Colors.grey,
                  onPressed: () {},
                ),
              ],
      ),
    );
  }
}
