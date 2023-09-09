// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:praduation_project/data/model/user_account_model.dart';
import 'package:praduation_project/global%20widget/custom_button.dart';
import 'package:praduation_project/global%20widget/loading_widget.dart';
import '../../../data/model/category_model.dart';
import '../../../data/model/city_model.dart';
import '../../../data/model/product_model.dart';
import 'add_product_widget.dart';

class AddProductBody extends StatefulWidget {
  static const id = 'addproduct';

  const AddProductBody({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  AddProductBodyState createState() => AddProductBodyState();
}

class AddProductBodyState extends State<AddProductBody> {
  List<Asset> assetImage = <Asset>[];
  List<String> imageUrls = <String>[];
  // late List<String> networkUrl;

  var categoryC = TextEditingController();
  var cityC = TextEditingController();
  var subCategoryC = TextEditingController();
  var productNameC = TextEditingController();
  String rently = "daily".tr;
  var priceC = TextEditingController();
  var detailC = TextEditingController();
  var brandC = TextEditingController();
  String subCategory = "";
  bool isLoading = false;
  final categoryKey = GlobalKey<FormState>();
  final cityKey = GlobalKey<FormState>();
  final subCategoryKey = GlobalKey<FormState>();
  var minRentalPeriodC = TextEditingController();
  var maxRentalPeriodC = TextEditingController();
  String minRentalPeriodUnit = 'days';
  String maxRentalPeriodUnit = 'days';
  final _key = GlobalKey<FormState>();
  List<Asset> images = <Asset>[];
  // List<String> imageUrls = <String>[];

  save() async {
    setState(() => isLoading = true);
    bool isValidate = _key.currentState!.validate();
    printInfo(info: isValidate.toString());
    try {
      if (isValidate) {
        await uploadImages();
        if (imageUrls.isEmpty) {
          setState(() => isLoading = false);
          Get.snackbar(
            "error".tr,
            "enterAtLeastOneImage".tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: const EdgeInsets.all(8),
          );
          return;
        }
        ProductModel(
          category: categoryC.text,
          subCategory: subCategoryC.text,
          city: cityC.text,
          productName: productNameC.text,
          detail: detailC.text,
          period: rently,
          price: double.parse(priceC.text),
          brandName: brandC.text,
          imagesUrl: imageUrls,
          userId: UserAccount.info!.uid,
          maxRentalPeriod: "${maxRentalPeriodC.text} $maxRentalPeriodUnit",
          minRentalPeriod: "${minRentalPeriodC.text} $minRentalPeriodUnit",
          isacceptadmin: false,
        ).addToFirebase();
        Get.back();
      }
    } catch (e) {
      printInfo(info: isValidate.toString());

      e.printError();
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    printInfo(info: categoryC.text);
    return LoadingWidget(
      isLoading: isLoading,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    CustomDropdownFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      value: categoryC.text.isNotEmpty ? categoryC.text : null,
                      hint: 'selectCategory'.tr,
                      labelText: 'category'.tr,
                      items: Category.categories.map((e) => e.name).toList(),
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            categoryC.text = value;
                            subCategoryC.text = "";
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'pleaseSelectCategory'.tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomDropdownFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      value: cityC.text.isNotEmpty ? cityC.text : null,
                      hint: 'selectCity'.tr,
                      labelText: 'city'.tr,
                      items: cities.map((e) => e.name).skip(1).toList(),
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            cityC.text = value;
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'pleaseSelectCity'.tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomDropdownFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      value: subCategoryC.text.isNotEmpty
                          ? subCategoryC.text
                          : null,
                      hint: 'selectSubCategory'.tr,
                      labelText: 'subCategory'.tr,
                      items:
                          Category.getSubCategorie(categoryC.text.toLowerCase())
                              .skip(1)
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            subCategoryC.text = value;
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'pleaseSelectSubCategory'.tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    ProductFormFields.productNameField(productNameC),
                    const SizedBox(height: 10),
                    ProductFormFields.brandNameField(brandC),

                    const SizedBox(height: 10),

                    ProductFormFields.detailField(detailC),

                    const SizedBox(height: 10),
                    ProductFormFields.priceField(priceC, rently, (result) {
                      rently = result!;
                      setState(() {});
                    }),
                    const SizedBox(height: 10),

                    // ! Min..................
                    RentalPeriodRow(
                      label: 'minRentalPeriod'.tr,
                      value: minRentalPeriodUnit,
                      onChanged: (value) {
                        setState(() {
                          minRentalPeriodUnit = value.toString();
                        });
                      },
                      controller: minRentalPeriodC,
                    ),
                    const SizedBox(height: 10),
                    RentalPeriodRow(
                      label: 'maxRentalPeriod'.tr,
                      value: maxRentalPeriodUnit,
                      onChanged: (value) {
                        setState(() {
                          maxRentalPeriodUnit = value.toString();
                        });
                      },
                      controller: maxRentalPeriodC,
                    ),
                    const SizedBox(height: 10),
                    // ! pickImages..................
                    SizedBox(
                      height: 250,
                      child: Column(
                        children: [
                          Expanded(
                            child: BuildGridView(
                              assetImage: assetImage,
                              // networkUrl: networkUrl,
                              // networkUrlChange: (newValue) {
                              //   setState(() => networkUrl = newValue);
                              // },
                              assetImageChange: (newValue) {
                                setState(() => assetImage = newValue);
                              },
                              // onPressed: () => loadAsset(),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 12.0),

                    CustomButton(
                      onPressed: save,
                      color: Get.theme.colorScheme.primary,
                      label: Text(
                        'uploadProduct'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.background,
                        ),
                      ),
                    ),

                    SizedBox(height: Get.height * .05),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadAssets() async {
    // print("objesssct");

    List<Asset> resultList = <Asset>[];
    final permissionStatus1 = await Permission.storage.request();

    final permissionStatus = await Permission.camera.request();

    String error = "somethingWentWrong".tr;

    if (permissionStatus.isGranted && permissionStatus1.isGranted) {
      // print("objesssct");

      try {
        resultList = await MultiImagePicker.pickImages(
          maxImages: 10,
          enableCamera: true,
        );
        setState(() {
          assetImage = resultList;
        });
      } catch (e) {
        error = e.toString();
        printInfo(info: error);
      }
    } else {
      // print(permissionStatus1.isGranted);
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Photos Permission Required'.tr),
            content: Text('Please grant permission to access photos.'.tr),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
                child: Text('Go to Settings'.tr),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> uploadImages() async {
    for (var image in assetImage) {
      String filename = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child("images/$filename");
      ByteData byteData = await image.getByteData(quality: 50);
      Uint8List imageData = byteData.buffer.asUint8List();
      UploadTask uploadTask = storageReference.putData(imageData);
      TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() {});
      String downloadUrl = await storageSnapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
      // print(imageUrls);
    }
  }

  Future postImages(Asset imagefile) async {
    String filename = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage db = FirebaseStorage.instance;
    await db
        .ref()
        .child("images")
        .child(filename)
        .putData((await imagefile.getByteData()).buffer.asUint8List());

    return db.ref().child("images").child(filename).getDownloadURL();
  }

  // uploadImages() async {
  //   for (var image in images) {
  //     await postImages(image).then((downloadUrl) {
  //       imageUrls.add(downloadUrl.toString());
  //     }).catchError((e) {
  //       printInfo(info: e.toString());
  //     });
  //   }
  // }
}
