import 'package:get/get.dart';

import '../controllers/first_controller.dart';

class FirstBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FirstController>(
      () => FirstController(),
    );
  }
}
