import 'package:get/get.dart';

import 'code/ar.dart';
import 'code/en.dart';

class MyLocale implements Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "ar": ar,
        "en": en,
      };
}
