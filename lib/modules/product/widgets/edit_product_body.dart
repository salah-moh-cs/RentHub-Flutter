// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, prefer_typing_uninitialized_variables
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:praduation_project/core/theme/text_theme.dart';
import 'package:praduation_project/core/utils/helpers/custom_dialog.dart';

import 'package:praduation_project/global%20widget/loading_widget.dart';

import '../../../core/utils/helpers/rent_dailog.dart';
import '../../../data/model/category_model.dart';
import '../../../data/model/city_model.dart';
import '../../../data/model/product_model.dart';
import '../controllers/product_controller.dart';

class EditProductBody extends StatefulWidget {
  static const id = 'addproduct';

  const EditProductBody({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditProductBodyState createState() => _EditProductBodyState();
}

class _EditProductBodyState extends State<EditProductBody> {
  late ProductModel product;

  late var categoryC;
  late var cityC;
  late var productNameC;
  late String rently;
  late var priceC;
  late var detailC;
  late var brandC;
  late String subCategory;
  bool isLoading = false;

  late var minRentalPeriodC;

  late var maxRentalPeriodC;
  late String minRentalPeriodUnit;
  late String maxRentalPeriodUnit;

  final _key = GlobalKey<FormState>();
  List<Asset> assetImage = <Asset>[];
  List<String> imageUrls = <String>[];
  late List<String> networkUrl;

  update() async {
    setState(() => isLoading = true);

    try {
      bool isValidate = _key.currentState!.validate();
      if (isValidate) {
        await uploadImages();
        late List<String> networkUrls = imageUrls + networkUrl;
        if (networkUrls.isEmpty) {
          Get.snackbar(
            "error".tr,
            "enterAtLeastOneImage".tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: const EdgeInsets.all(8),
          );
          setState(() => isLoading = false);

          return;
        }

        product
            .copyWith(
              category: categoryC.text,
              subCategory: subCategory,
              city: cityC.text,
              productName: productNameC.text,
              detail: detailC.text,
              period: rently,
              price: double.parse(priceC.text),
              brandName: brandC.text,
              imagesUrl: networkUrl + imageUrls,
              maxRentalPeriod: "${maxRentalPeriodC.text} $maxRentalPeriodUnit",
              minRentalPeriod: "${minRentalPeriodC.text} $minRentalPeriodUnit",
              isacceptadmin: false,
            )
            .updateProduct();
      }
      final controller = Get.find<ProductController>();
      controller.update();

      Get.back();
    } catch (e) {
      e.printError();
    }

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    initProduct();
  }

  void initProduct() {
    final controller = Get.find<ProductController>();
    product = controller.product;

    categoryC = TextEditingController(text: product.category);
    cityC = TextEditingController(text: product.city);
    productNameC = TextEditingController(text: product.productName);
    rently = product.period;
    priceC = TextEditingController(text: product.price.toString());
    detailC = TextEditingController(text: product.detail);
    brandC = TextEditingController(text: product.brandName);
    subCategory = product.subCategory;
    minRentalPeriodC =
        TextEditingController(text: product.minRentalPeriod.split(' ')[0]);

    maxRentalPeriodC =
        TextEditingController(text: product.maxRentalPeriod.split(' ')[0]);

    minRentalPeriodUnit = product.minRentalPeriod.split(' ')[1];
    maxRentalPeriodUnit = product.maxRentalPeriod.split(' ')[1];

    networkUrl = product.imagesUrl;
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWidget(
      isLoading: isLoading,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _key,
          child: ListView(
            children: [
              const SizedBox(height: 10),
              categorydrop(),
              const SizedBox(height: 10),
              subcategorydrop(categoryC.text),
              const SizedBox(height: 10),
              citydrop(),
              const SizedBox(
                height: 10,
              ),
              // Name field
              EditField(
                maxLength: 25,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter ProductName'.tr;
                  }
                  return null;
                },
                controller: productNameC,
                hint: 'enterProductName'.tr,
                onsubmit: (value) {
                  setState(() {});
                },
              ),
              //Detail field

              EditField(
                maxLength: 250,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Detail'.tr;
                  }
                  return null;
                },
                controller: detailC,
                hint: 'enterDetail'.tr,
                onsubmit: (value) {
                  setState(() {});
                },
              ),
              // price field
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'enterPrice'.tr,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(18.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Price'.tr;
                          }
                          try {
                            double.parse(value);
                          } catch (e) {
                            return "enterJustNumber".tr;
                          }
                          return null;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                              4), // restrict to 4 digits
                        ],
                        controller: priceC,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (value) {
                          // setState(() {
                          //   priceC.text = value;
                          // });
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        String? result = await Get.dialog(const RentDialog());
                        if (result != null) {
                          rently = result;
                          setState(() {});
                        }
                      },
                      child: Text(rently),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              EditField(
                maxLength: 25,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter BrandName'.tr;
                  }
                  return null;
                },
                controller: brandC,
                hint: 'enterBrandName'.tr,
                onsubmit: (value) {
                  setState(() {
                    brandC.text = value;
                  });
                },
              ),

              // ! Min..................
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Min Rental Period:',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField(
                      value: minRentalPeriodUnit,
                      onChanged: (value) {
                        setState(() {
                          minRentalPeriodUnit = value.toString();
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'days',
                          child: Text('Days'),
                        ),
                        DropdownMenuItem(
                          value: 'weeks',
                          child: Text('Weeks'),
                        ),
                        DropdownMenuItem(
                          value: 'months',
                          child: Text('Months'),
                        ),
                      ],
                      decoration: _customInputDecorationv2(),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: minRentalPeriodC,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '';
                          }
                          try {
                            int.parse(value);
                          } catch (e) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        decoration: _customInputDecorationv3(),
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          setState(() {});
                        },
                        style: TextStyle(
                          fontSize: 16,
                          color: Get.theme.colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // ! Max..................
              Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Max Rental Period:',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField(
                      value: maxRentalPeriodUnit,
                      onChanged: (value) {
                        setState(() {
                          maxRentalPeriodUnit = value.toString();
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'days',
                          child: Text('Days'),
                        ),
                        DropdownMenuItem(
                          value: 'weeks',
                          child: Text('Weeks'),
                        ),
                        DropdownMenuItem(
                          value: 'months',
                          child: Text('Months'),
                        ),
                      ],
                      decoration: _customInputDecorationv2(),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: maxRentalPeriodC,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '';
                          }
                          try {
                            int.parse(value);
                          } catch (e) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        decoration: _customInputDecorationv3(),
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          setState(() {});
                        },
                        style: TextStyle(
                          fontSize: 16,
                          color: Get.theme.colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ! pickImages..................
              SizedBox(
                height: 250,
                child: Column(
                  children: [
                    // ElevatedButton(
                    //   onPressed: () {
                    //     loadAsset();
                    //   },
                    //   child: Text('pickImages'.tr),
                    // ),
                    Expanded(
                      child: BuildGridView(
                        assetImage: assetImage,
                        networkUrl: networkUrl,
                        networkUrlChange: (newValue) {
                          setState(() => networkUrl = newValue);
                        },
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
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                onPressed: () {
                  CustomDialog.showYesNoDialog(
                    noButtonText: "no".tr,
                    title: "editproduct".tr,
                    content: "backtoadmin".tr,
                    yesButtonText: "Update".tr,
                    onYesPressed: () => update(),
                  );
                },
                color: Get.theme.colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'uploadProduct'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              SizedBox(height: Get.height * .05),
            ],
          ),
        ),
      ),
    );
  }

  //--------------------------******************************-------------------------------------------------------------------

  DropdownButtonFormField<String> citydrop() {
    return DropdownButtonFormField(
      validator: (String? v) {
        if (v == null || v.isEmpty) {
          return 'Please Select City';
        }
        return null;
      },
      hint: Text('selectCity'.tr),
      value: cityC.text,
      decoration: _customInputDecoration(),
      onChanged: (value) {
        setState(() {
          if (value != null) {
            cityC.text = value;
          }
        });
      },
      items: cities
          .skip(1)
          .map((e) => DropdownMenuItem(
                value: e.name,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    e.name.tr,
                  ),
                ),
              ))
          .toList(),
    );
  }

  InputDecoration _customInputDecoration() {
    return InputDecoration(
      hintText: 'selectCity'.tr,
      labelText: 'City'.tr,
      labelStyle: AppStyles.headLine4.copyWith(
        color: Get.theme.colorScheme.onBackground,
      ),
      hintStyle: AppStyles.headLine4.copyWith(
        color: Get.theme.colorScheme.onBackground,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Get.theme.colorScheme.secondary),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Get.theme.colorScheme.secondary),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Get.theme.colorScheme.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      errorStyle: const TextStyle(color: Colors.red),
    );
  }

  InputDecoration _customInputDecorationv2() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Get.theme.colorScheme.secondary),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Get.theme.colorScheme.secondary),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Get.theme.colorScheme.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      errorStyle: const TextStyle(color: Colors.red),
    );
  }

  InputDecoration _customInputDecorationv3() {
    return InputDecoration(
      hintText: '0',
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Get.theme.colorScheme.primary),
        borderRadius: BorderRadius.circular(5.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Get.theme.colorScheme.secondary),
        borderRadius: BorderRadius.circular(5.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }

  DropdownButtonFormField<String> categorydrop() {
    return DropdownButtonFormField(
      validator: (String? v) {
        if (v == null || v.isEmpty) {
          return 'Please Select Category';
        }
        return null;
      },
      hint: Text('selectCategory'.tr),
      value: categoryC.text,
      decoration: InputDecoration(
        hintText: 'selectCategory'.tr,
        labelText: 'Category'.tr,
        labelStyle: AppStyles.headLine4.copyWith(
          color: Get.theme.colorScheme.onBackground,
        ),
        hintStyle: AppStyles.headLine4.copyWith(
          color: Get.theme.colorScheme.onBackground,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Get.theme.colorScheme.secondary),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Get.theme.colorScheme.secondary),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Get.theme.colorScheme.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        errorStyle: const TextStyle(color: Colors.red),
      ),
      onChanged: (value) {
        setState(() {
          if (value != null) {
            categoryC.text = value;
          }
        });
      },
      items: Category.categories
          .map((e) => DropdownMenuItem(
                value: e.name,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    e.name,
                  ),
                ),
              ))
          .toList(),
    );
  }

  DropdownButtonFormField<String> subcategorydrop(String categoryid) {
    return DropdownButtonFormField(
      validator: (String? v) {
        if (v == null || v.isEmpty) {
          return 'Please Select SubCategory';
        }
        return null;
      },
      hint: Text('selectSubCategory'.tr),
      value: subCategory,
      decoration: InputDecoration(
        hintText: 'selectSubCategory'.tr,
        labelText: 'SubCategory'.tr,
        labelStyle: AppStyles.headLine4.copyWith(
          color: Get.theme.colorScheme.onBackground,
        ),
        hintStyle: AppStyles.headLine4.copyWith(
          color: Get.theme.colorScheme.onBackground,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Get.theme.colorScheme.secondary),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Get.theme.colorScheme.secondary),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Get.theme.colorScheme.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        errorStyle: const TextStyle(color: Colors.red),
      ),
      onChanged: (value) {
        setState(() {
          if (value != null) {
            subCategory = value;
          }
        });
      },
      items: Category.getSubCategorie(categoryid.toLowerCase())
          .skip(1)
          .map((e) => DropdownMenuItem(
                value: e.toLowerCase(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    e,
                  ),
                ),
              ))
          .toList(),
    );
  }

  loadAsset() async {
    List<Asset> resultImages = <Asset>[];
    String error = "somethingWentWrong".tr;
    try {
      resultImages = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: assetImage,
      );
      setState(() {
        assetImage = resultImages;
      });
    } catch (e) {
      error = e.toString();
      printInfo(info: error);
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

  uploadImages() async {
    for (var image in assetImage) {
      await postImages(image).then((downloadUrl) {
        imageUrls.add(downloadUrl.toString());
      }).catchError((e) {
        printInfo(info: e.toString());
      });
    }
  }
}

class EditField extends StatelessWidget {
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final String hint;
  final int? maxLines;
  final int maxLength;
  final void Function(String)? onsubmit;

  const EditField({
    Key? key,
    required this.validator,
    required this.controller,
    required this.hint,
    required this.onsubmit,
    this.maxLines,
    required this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        labelText: hint,
        labelStyle: AppStyles.headLine4.copyWith(
          color: Get.theme.colorScheme.onBackground,
        ),
        hintStyle: AppStyles.headLine4.copyWith(
          color: Get.theme.colorScheme.onBackground,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Get.theme.colorScheme.secondary),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Get.theme.colorScheme.secondary),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Get.theme.colorScheme.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        errorStyle: const TextStyle(color: Colors.red),
      ),
      maxLength: maxLength,
      controller: controller,
      validator: validator,
      onFieldSubmitted: onsubmit,
    );
  }
}

class BuildGridView extends StatefulWidget {
  List<Asset> assetImage;

  List<String> networkUrl;
  final ValueChanged<List<String>>? networkUrlChange;
  final ValueChanged<List<Asset>>? assetImageChange;
  BuildGridView({
    super.key,
    required this.assetImage,
    required this.networkUrl,
    this.networkUrlChange,
    this.assetImageChange,
  });

  @override
  State<BuildGridView> createState() => BuildGridViewState();
}

class BuildGridViewState extends State<BuildGridView> {
  List<dynamic> allImages = [];

  void onTap() async {
    try {
      printInfo(info: (allImages.length - 10).clamp(0, 10).toString());
      final resultImages = await MultiImagePicker.pickImages(
        maxImages: (10 - allImages.length).clamp(0, 10),
        enableCamera: true,
        selectedAssets: widget.assetImage,
      );
      widget.assetImage = resultImages;
      allImageCallBack();
      setState(() {});
      if (widget.assetImageChange != null) {
        widget.assetImageChange!(widget.assetImage);
      }
    } catch (e) {
      e.toString();
    }
  }

  void allImageCallBack() {
    allImages = [];
    for (var item in widget.assetImage) {
      allImages.add(item);
    }
    for (var item in widget.networkUrl) {
      allImages.add(item);
    }
  }

  @override
  void initState() {
    super.initState();
    allImageCallBack();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: decoration(),
      child: allImages.isEmpty
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [const Icon(Icons.add), Text("pickImages".tr)],
              ),
            )
          : GridView.count(
              crossAxisCount: 3,
              children: List.generate(
                allImages.length + 1,
                (index) {
                  if (index == allImages.length) {
                    // The last element, add your widget here
                    return allImages.length < 10
                        ? Container(
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Get.theme.colorScheme.background,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: InkWell(
                              onTap: onTap,
                              borderRadius: BorderRadius.circular(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.add),
                                  Text("pickImages".tr)
                                ],
                              ),
                            ),
                          )
                        : const SizedBox();
                  } else {
                    final item = allImages[index];
                    if (item is Asset) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DeleteImageAtIndex(
                          onTap: () {
                            setState(() => allImages.removeAt(index));

                            widget.assetImage =
                                allImages.whereType<Asset>().toList();

                            if (widget.assetImageChange != null) {
                              widget.assetImageChange!(widget.assetImage);
                            }
                          },
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: AssetThumb(
                              asset: item,
                              width: 150,
                              height: 150,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DeleteImageAtIndex(
                          onTap: () {
                            setState(() => allImages.removeAt(index));
                            widget.networkUrl =
                                allImages.whereType<String>().toList();

                            if (widget.networkUrlChange != null) {
                              widget.networkUrlChange!(widget.networkUrl);
                            }
                          },
                          child: Card(
                            child: CachedNetworkImage(
                              imageUrl: item,
                              width: 150,
                              height: 150,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
    );
  }
}

BoxDecoration decoration() {
  return BoxDecoration(
    color: Colors.grey.withOpacity(0.3),
    borderRadius: BorderRadius.circular(8.0),
  );
}

InputDecoration inputdecoration() {
  return InputDecoration(
    hintText: 'selectCity'.tr,
    labelText: 'City'.tr,
    labelStyle: const TextStyle(color: Colors.black),
    hintStyle: const TextStyle(color: Colors.grey),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blue),
      borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(8),
    ),
    errorStyle: const TextStyle(color: Colors.red),
  );
}

class DeleteImageAtIndex extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const DeleteImageAtIndex(
      {super.key, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              height: 15,
              width: 15,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 12,
              ),
            ),
          ),
        )
      ],
    );
  }
}
