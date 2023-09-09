import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import '../../../core/theme/text_theme.dart';
import '../../../core/utils/helpers/rent_dailog.dart';
import 'edit_product_body.dart';

// ignore: must_be_immutable
class CustomDropdownFormField extends StatelessWidget {
  final String? value;
  final String? hint;
  final String? labelText;
  final List<String> items;
  AutovalidateMode? autovalidateMode;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  CustomDropdownFormField({
    Key? key,
    required this.autovalidateMode,
    this.value,
    this.hint,
    this.labelText,
    required this.items,
    this.onChanged,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      key: key,
      autovalidateMode: autovalidateMode,
      value: value,
      hint: hint != null ? Text(hint!.tr) : null,
      decoration: CustomInputDecoration.getDecoration(
        hintText: hint,
        labelText: hint,
      ),
      onChanged: onChanged,
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(item.tr),
              ),
            ),
          )
          .toList(),
      validator: validator,
    );
  }
}

// ignore: must_be_immutable
class EditField extends StatelessWidget {
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String? hint;
  final int? maxLines;
  TextInputType? keyboardType;
  final int? maxLength;
  final void Function(String)? onsubmit;

  EditField({
    Key? key,
    this.validator,
    this.controller,
    this.keyboardType,
    this.hint,
    this.onsubmit,
    this.maxLines,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: CustomInputDecoration.getDecoration(
        hintText: hint,
        labelText: hint,
      ),
      maxLength: maxLength,
      controller: controller,
      validator: validator,
      onFieldSubmitted: onsubmit,
    );
  }
}

class ProductFormFields {
  static Widget productNameField(TextEditingController controller) {
    return EditField(
      maxLength: 20,
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (kDebugMode) {
            print("checked");
          }
          return 'pleaseEnterProductName'.tr;
        }
        return null;
      },
      controller: controller,
      hint: 'enterProductName'.tr,
      onsubmit: (value) {
        // setState(() {});
      },
    );
  }

  static Widget detailField(TextEditingController controller) {
    return EditField(
      maxLength: 250,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'pleaseEnterDetail'.tr;
        }
        return null;
      },
      controller: controller,
      hint: 'enterDetail'.tr,
    );
  }

  static Widget priceField(TextEditingController controller, String rently,
      Function(String?) onRentSelected) {
    return Row(
      children: [
        Expanded(
          child: EditField(
            keyboardType: TextInputType.number,
            maxLength: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'pleaseEnterPrice'.tr;
              }
              try {
                double.parse(value);
              } catch (e) {
                return "enterJustNumber".tr;
              }
              return null;
            },
            controller: controller,
            hint: 'enterPrice'.tr,
          ),
        ),
        TextButton(
          onPressed: () async {
            String? result = await Get.dialog(const RentDialog());
            if (result != null) {
              onRentSelected(result);
              // setstate();
            }
          },
          child: Text(
            rently.tr,
            style: AppStyles.headLine5.copyWith(
              color: Get.theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ],
    );
  }

  static Widget brandNameField(TextEditingController controller) {
    return EditField(
      maxLength: 20,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'pleaseEnterBrandName'.tr;
        }
        return null;
      },
      controller: controller,
      hint: 'enterBrandName'.tr,
    );
  }
}

// ignore: must_be_immutable
class BuildGridView extends StatefulWidget {
  List<Asset> assetImage;

  // List<String> networkUrl;
  // final ValueChanged<List<String>>? networkUrlChange;
  final ValueChanged<List<Asset>>? assetImageChange;
  BuildGridView({
    super.key,
    required this.assetImage,
    // required this.networkUrl,
    // this.networkUrlChange,
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
    // for (var item in widget.networkUrl) {
    // allImages.add(item);
    // }
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
                            // widget.networkUrl =
                            allImages.whereType<String>().toList();

                            // if (widget.networkUrlChange != null) {
                            // widget.networkUrlChange!(widget.networkUrl);
                            // }
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

class RentalPeriodRow extends StatelessWidget {
  final String label;
  final String value;
  final void Function(String?)? onChanged;
  final TextEditingController? controller;

  const RentalPeriodRow({
    Key? key,
    required this.label,
    required this.value,
    this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label.tr,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            items: [
              DropdownMenuItem(
                value: 'days',
                child: Text('days'.tr),
              ),
              DropdownMenuItem(
                value: 'weeks',
                child: Text('weeks'.tr),
              ),
              DropdownMenuItem(
                value: 'months',
                child: Text('months'.tr),
              ),
            ],
            decoration: CustomInputDecoration.getDecoration(),
          ),
        ),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 0, left: 8, right: 8, top: 21),
            child: EditField(
              hint: "0",
              maxLength: 2,
              controller: controller,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '';
                }
                try {
                  int.parse(value);
                } catch (e) {
                  return 'pleaseEnterAValidNumber'.tr;
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}

class CustomInputDecoration {
  static InputDecoration getDecoration({
    String? hintText,
    String? labelText,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      labelStyle: AppStyles.headLine5.copyWith(
        color: Get.theme.colorScheme.onBackground,
      ),
      hintStyle: AppStyles.headLine5.copyWith(
        color: Get.theme.colorScheme.onBackground,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Get.theme.colorScheme.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Get.theme.colorScheme.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Get.theme.colorScheme.secondary),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      errorStyle: const TextStyle(color: Colors.red),
    );
  }
}
