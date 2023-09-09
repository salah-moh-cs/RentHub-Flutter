// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:praduation_project/modules/first/controllers/first_controller.dart';
// import 'package:praduation_project/modules/first/widgets/custom_advertisements_card.dart';

// class CustomAdvertisementsWidget extends GetView<FirstController> {
//   const CustomAdvertisementsWidget({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: Get.height * .2,
//       child: ListView.builder(
//         padding: EdgeInsets.zero,
//         scrollDirection: Axis.horizontal,
//         physics: const PageScrollPhysics(),
//         itemCount: controller.advertisements.length,
//         itemBuilder: (context, index) {
//           final advertisement = controller.advertisements[index];
//           return CarouselContainer(
//             imageUrls: [
//               "assets/images/download.jpg",
//               "assets/images/download.jpg"
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
