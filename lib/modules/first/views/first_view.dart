import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:praduation_project/modules/first/widgets/first_body.dart';

import '../controllers/first_controller.dart';

class FirstView extends GetView<FirstController> {
  const FirstView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FirstBody(),
    );
  }
}
