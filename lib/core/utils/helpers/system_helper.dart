import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SystemHelper {
  static void makeCall(String phoneNumber) {
    try {
      launchUrl(Uri.parse("tel://$phoneNumber"));
    } catch (e) {
      if (kDebugMode) {
        print("error when make a call: $e");
      }
    }
  }

  static void makelink(String link) {
    try {
      launchUrl(Uri.parse(link));
    } catch (e) {
      if (kDebugMode) {
        print("error when make a call: $e");
      }
    }
  }

  static void closeKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
}
