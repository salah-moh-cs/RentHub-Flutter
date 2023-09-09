import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeHelper {
  InputDecoration textInputDecoration({
    String lableText = "",
    String hintText = "",
    bool isPassword = false,
    bool showPassword = false,
    ValueChanged<bool>? onPasswordChange,
  }) {
    return InputDecoration(
      labelText: lableText,
      hintText: hintText,
      errorMaxLines: 2,
      filled: true,
      suffix: isPassword
          ? IconButton(
              icon:
                  Icon(showPassword ? Icons.visibility : Icons.visibility_off),
              splashRadius: 15,
              onPressed: () {
                if (onPasswordChange != null) {
                  onPasswordChange(!showPassword);
                }
              },
            )
          : const Padding(padding: EdgeInsets.all(18.0)),
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.grey)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade400)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0)),
    );
  }

  BoxDecoration buttonBoxDecoration(
    BuildContext context,
  ) {
    return BoxDecoration(
      boxShadow: const [
        BoxShadow(
          offset: Offset(0, 4),
          blurRadius: 5.0,
        )
      ],
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 1.0],
        colors: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.secondary,
        ],
      ),
      borderRadius: BorderRadius.circular(8.0),
    );
  }

  ButtonStyle buttonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      minimumSize: MaterialStateProperty.all(const Size(50, 50)),
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      shadowColor: MaterialStateProperty.all(Colors.transparent),
      overlayColor: MaterialStateProperty.all(Get.theme.colorScheme.primary),
    );
  }

  AlertDialog alartDialog(String title, String content, BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: Text(
            "oK".tr,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class LoginFormStyle {}
