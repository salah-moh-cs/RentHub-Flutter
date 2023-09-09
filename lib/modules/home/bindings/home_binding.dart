import 'package:get/get.dart';
import 'package:praduation_project/modules/first/controllers/first_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<FirstController>(
      () => FirstController(),
    );
  }
}
