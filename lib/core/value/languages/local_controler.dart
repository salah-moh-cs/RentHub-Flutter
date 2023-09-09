import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends GetxController {
  static final instance = Get.put(LocaleController());

  SharedPreferences? sharepref;

  @override
  void onInit() {
    initSharePref();
    super.onInit();
  }

  Locale get initalLang {
    Locale initalLang = const Locale('en');

    if (sharepref!.containsKey("lang")) {
      String? langCode = sharepref!.getString("lang");
      if (langCode == 'ar') {
        initalLang = const Locale('ar');
      }
    }
    return initalLang;
  }

  Locale get getLang {
    Locale initalLang = const Locale('en');

    if (sharepref!.containsKey("lang")) {
      String? langCode = sharepref!.getString("lang");
      if (langCode == 'ar') {
        initalLang = const Locale('ar');
      }
    }
    return initalLang;
  }

  Future<void> initSharePref() async {
    sharepref = await SharedPreferences.getInstance();
  }

  void changeLang(String codelang) {
    Locale locale = Locale(codelang);
    sharepref!.setString("lang", codelang);
    Get.updateLocale(locale);
  }
}
