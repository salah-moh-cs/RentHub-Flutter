import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:praduation_project/data/model/user_account_model.dart';
import 'package:praduation_project/modules/product/controllers/product_controller.dart';
import '../../../core/utils/helpers/custom_dialog.dart';
import '../../../global widget/custom_button.dart';
import '../../../global widget/custom_dropdown_option.dart';
import '../../auth/controller/auth_controller.dart';

// ignore: must_be_immutable
class ProductBottomBar extends GetView<ProductController> {
  bool? adm;
  ProductBottomBar({Key? key, this.adm}) : super(key: key);
  final any = AuthController.instance.isUserSignedInAnonymously();

  @override
  Widget build(BuildContext context) {
    final isSameUser = UserAccount.info!.uid == controller.product.userId;
    final isAdmin = UserAccount.info!.isAdmin;

    late bool isFavorit;

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(UserAccount.info!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Fluttertoast.showToast(msg: "${"error".tr} : ${snapshot.error}");
          printInfo(info: snapshot.error.toString());
          return Center(child: Text("${snapshot.error}"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        Map<String, dynamic>? data = snapshot.data!.data();
        final List<dynamic> favoritesList = data?['favorites'] ?? [];
        favoritesList == []
            ? isFavorit = false
            : isFavorit = favoritesList.contains(controller.product.productUid);
        if (data != null) {
          UserAccount.info = UserAccount.formJson(data);
        }

        return Container(
          height: Get.height * .09,
          width: Get.width,
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.background,
          ),
          child: Row(
            children: [
              Expanded(
                  child: any == true
                      ? const SizedBox()
                      : CustomDropDownOption(
                          options: isAdmin
                              ? [
                                  if (adm == true)
                                    Option(
                                      label: "accept".tr,
                                      onTap: () async {
                                        await controller.product.accept;
                                      },
                                    ),
                                  if (adm == true)
                                    Option(
                                      label: "delete".tr,
                                      onTap: () async {
                                        await controller.product.delete();
                                      },
                                    )
                                  else
                                    Option(
                                      label: "reject".tr,
                                      onTap: () async {
                                        await controller.product.reject;
                                      },
                                    ),
                                ]
                              : [
                                  Option(
                                    label: "sendReport".tr,
                                    icon: const Icon(Icons.report),
                                    onTap: () {
                                      Get.back();
                                      // print("object");
                                      showReportDialog();
                                    },
                                  ),
                                ],
                        )),
              Expanded(
                child: any == true
                    ? const SizedBox()
                    : CustomButton(
                        color: isAdmin || isSameUser
                            ? Colors.red
                            : Get.theme.colorScheme.background,
                        onPressed: () async {
                          if (isAdmin || isSameUser) {
                            await CustomDialog.showYesNoDialog(
                              noButtonText: "no".tr,
                              yesButtonText: "yes".tr,
                              title: "delete".tr,
                              icons: Icons.delete,
                              content: "deletewarning".tr,
                              yesButtonColor: Colors.red,
                              onYesPressed: () async {
                                await controller.product.delete();
                              },
                            );
                          } else {
                            isFavorit = !isFavorit;
                            if (isFavorit == true) {
                              controller.addfavorites();
                            } else {
                              controller.removefavorites();
                            }
                          }
                        },
                        label: Icon(
                          (isAdmin || isSameUser)
                              ? Icons.delete
                              : (isFavorit
                                  ? Icons.favorite
                                  : Icons.favorite_border),
                          color: (isAdmin || isSameUser)
                              ? Get.theme.colorScheme.background
                              : Colors.red,
                        ),
                      ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                flex: 5,
                child: GetBuilder<ProductController>(builder: (controller) {
                  final isRent = controller.product.isRent;
                  return CustomPrimaryButton(
                    label: isSameUser
                        ? isRent
                            ? "makeItAvailable".tr
                            : "makeItRented".tr
                        : isRent
                            ? 'notAvailable'.tr
                            : 'available'.tr,
                    textColor: Colors.white,
                    backgroundColor:
                        isRent ? Get.theme.colorScheme.primary : Colors.green,
                    onPresssed: () async {
                      if (isSameUser) {
                        if (isRent == false) {
                          makeItRented();
                        } else {
                          makeItAvailable();
                        }
                      } else {
                        if (isRent) {
                          showNotAvailableDialog();
                        } else {
                          showAvailableDialog();
                        }
                      }
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  void makeItRented() async {
    final product = controller.product;
    DateTime now = DateTime.now();
    DateTime? futureDate;

    futureDate = await showDatePicker(
      confirmText: "oK".tr,
      cancelText: "cancel".tr,
      helpText: "howLongHasThisProductBeenRented".tr,
      context: Get.context!,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (futureDate != null) {
      DateTime futureDateTime = DateTime(
        futureDate.year,
        futureDate.month,
        futureDate.day,
        now.hour,
        now.minute,
      );

      product.addToTimeList(now, futureDateTime);
      controller.changeRented();
    }
  }

  void makeItAvailable() => controller.changeRented();

  void showNotAvailableDialog() => CustomDialog.showDoneDialog(
      doneButtonText: "done".tr,
      title: "",
      content: "${"available".tr} ${controller.product.getTimeDifference(0)}");

  void showAvailableDialog() => CustomDialog.showDoneDialog(
      doneButtonText: "done".tr,
      title: "available".tr,
      content: any ? "guset".tr : "hurryUpToReserveTheProduct".tr);

  void showReportDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return ReportDialog(
          onSendReport: (selectedOption, comment) {
            controller.product.addToReport(
              UserAccount.info!.uid,
              selectedOption,
            );
            Fluttertoast.showToast(msg: 'reportHasBeenSent'.tr);
          },
        );
      },
    );
  }
}

class ReportDialog extends StatefulWidget {
  final void Function(String, String) onSendReport;

  const ReportDialog({super.key, required this.onSendReport});

  @override
  // ignore: library_private_types_in_public_api
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  String? selectedOption;
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('sendReport'.tr)),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            const SizedBox(height: 14),
            buildOption('inaccurateProductDescription'.tr),
            const SizedBox(height: 14),
            buildOption('poorProductCondition'.tr),
            const SizedBox(height: 14),
            buildOption('unresponsiveSeller'.tr),
            const SizedBox(height: 14),
            buildOption('other'.tr),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: selectedOption != null
              ? () {
                  widget.onSendReport(selectedOption!, commentController.text);
                  Get.back();
                }
              : null,
          child: Text('send'.tr),
        ),
      ],
    );
  }

  Widget buildOption(String label) {
    return GestureDetector(
      child: Container(
        color: selectedOption == label
            ? Get.theme.colorScheme.primary
            : Get.theme.colorScheme.onSecondary,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(child: Text(label)),
        ),
      ),
      onTap: () {
        setState(() {
          selectedOption = label;
        });
      },
    );
  }
}
