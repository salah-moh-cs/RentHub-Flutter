import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../global widget/custom_button.dart';

class CustomProfileListTile extends StatelessWidget {
  final String label;
  final IconData icons;
  final Function()? onTap;
  final bool showCopyButton;
  const CustomProfileListTile({
    super.key,
    required this.label,
    required this.icons,
    this.onTap,
    this.showCopyButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
        leading: Icon(icons),
        title: SelectableText(label),
        onTap: onTap,
        trailing: showCopyButton
            ? CustomButton(
                width: 35,
                height: 35,
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: label));
                  Fluttertoast.showToast(
                    msg: "copiedToClipboard".tr,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Get.theme.colorScheme.background,
                    textColor: Get.theme.colorScheme.onBackground,
                  );
                },
                label: const Icon(Icons.copy),
              )
            : null,
      ),
    );
  }
}
