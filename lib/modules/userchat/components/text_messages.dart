import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:praduation_project/global%20widget/image_viewer_list.dart';

import '../../../core/value/colors.dart';
import '../../../data/model/chat_message.dart';

import '../../../data/model/chatuser_db.dart';
import '../../../data/model/user_account_model.dart';

class MesssageTextBody extends StatelessWidget {
  final ChatMessage messages;
  final UserAccountChat value;

  const MesssageTextBody({
    Key? key,
    required this.messages,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isArabic = Intl.getCurrentLocale().startsWith('ar');

    return GestureDetector(
      onTap: () {
        printInfo(info: value.toString());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPaddin * .75,
          vertical: kDefaultPaddin / 4,
        ),
        child: Row(
          mainAxisAlignment: messages.sender == UserAccount.info!.uid
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (messages.sender != UserAccount.info!.uid) ...[
              CircleAvatar(
                radius: 18,
                backgroundImage: CachedNetworkImageProvider(value.imageurl),
              ),
              const SizedBox(
                width: kDefaultPaddin / 2,
              ),
            ],
            Flexible(
              child: IntrinsicWidth(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: messages.sender == UserAccount.info!.uid
                        ? Get.theme.colorScheme.secondary
                        : Get.theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    messages.msg,
                    style: TextStyle(
                      color: UserAccount.info!.uid == messages.sender
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge!.color,
                      fontFamily: "Poppins",
                    ),
                    softWrap: true,
                    textAlign: !isArabic ? TextAlign.right : TextAlign.left,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MesssageImageBody extends StatelessWidget {
  final UserAccountChat value;

  final ChatMessage messages;
  const MesssageImageBody(
      {super.key, required this.messages, required this.value});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ImageViewerList(
              imageUrls: [messages.msg],
            ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Row(
          mainAxisAlignment: messages.sender == UserAccount.info!.uid
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (messages.sender != UserAccount.info!.uid) ...[
              CircleAvatar(
                radius: 18,
                backgroundImage: CachedNetworkImageProvider(value.imageurl),
              ),
              const SizedBox(
                width: kDefaultPaddin / 2,
              ),
            ],
            Container(
              height: 100,
              width: Get.width * .5,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: messages.sender == UserAccount.info!.uid
                    ? Get.theme.colorScheme.secondary
                    : kDotPrimaryColor,
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(messages.msg),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
