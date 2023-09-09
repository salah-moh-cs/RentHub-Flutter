import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:praduation_project/core/utils/helpers/custom_dialog.dart';
import 'package:praduation_project/modules/auth/view/login/widgets/themehelper.dart';
import 'package:praduation_project/modules/product/controllers/product_controller.dart';

import '../../../core/theme/text_theme.dart';
import '../../../data/model/chatuser_db.dart';
import '../../../data/model/user_account_model.dart';
import '../../../data/services/database.dart';

class ProductCommentsWidget extends StatelessWidget {
  const ProductCommentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (controller) {
      final List<Map<String, dynamic>> comments = controller.comments;

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "comments".tr,
            style: AppStyles.headLine2,
          ),
          SizedBox(height: Get.height * .02),
          if (comments.isNotEmpty)
            ListView.builder(
              itemCount: comments.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final comment = comments[index];
                final uuid = comment.keys.toList()[0];
                final message = comment[uuid];

                return CommentCard(
                  uuid: uuid,
                  message: message,
                  index: index,
                );
              },
            ),
        ],
      );
    });
  }
}

class CommentCard extends GetView<ProductController> {
  final String uuid;
  final String message;
  final int index;
  const CommentCard(
      {super.key,
      required this.index,
      required this.uuid,
      required this.message});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseFirestore.getUserById(uuid),
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

        if (user != null) {
          final isSameUser = UserAccount.info!.uid == user.uid;
          return Slidable(
            enabled: isSameUser || UserAccount.info!.isAdmin,
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) {
                    CustomDialog.showYesNoDialog(
                      title: "delete".tr,
                      icons: Icons.delete,
                      content: "deletewarning".tr,
                      yesButtonColor: Colors.red,
                      onYesPressed: () =>
                          controller.deleteComment(index: index),
                    );
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  icon: Icons.delete,
                  label: 'delete'.tr,
                ),
              ],
            ),
            child: Card(
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(user.imageurl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                title: Text(
                  user.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: SelectableText(message),
              ),
            ),
          );
        }
        return const _LoadingListTile(hasError: true);
      },
    );
  }
}

class _LoadingListTile extends StatelessWidget {
  final bool hasError;
  const _LoadingListTile({this.hasError = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
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
          margin: const EdgeInsets.only(top: 4.0),
          height: hasError ? 4 : null,
          width: Get.width * .1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: hasError ? Colors.red : Colors.grey.withOpacity(.8),
          ),
          child: hasError ? null : const LinearProgressIndicator(),
        ),
      ),
    );
  }
}

class CommentUserInput extends GetView<ProductController> {
  CommentUserInput({super.key});
  final user = UserAccount.info!;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          height: 35,
          width: 35,
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Container(
          padding: const EdgeInsets.only(top: 0.0),
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.commentController,
                  decoration: ThemeHelper().textInputDecoration(
                    lableText: "comment".tr,
                    hintText: "enterYourComment".tr,
                  ),
                ),
              ),
              Obx(() {
                return IconButton(
                  onPressed: controller.isCommentEmpty.value
                      ? null
                      : controller.sendComment,
                  icon: Icon(
                    Icons.send,
                    color: controller.isCommentEmpty.value
                        ? Colors.grey
                        : Get.theme.colorScheme.primary,
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
