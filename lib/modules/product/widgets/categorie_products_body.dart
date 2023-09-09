import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/data/model/city_model.dart';
import 'package:praduation_project/global%20widget/user_and_product_stream_builder.dart';

import '../../../data/model/category_model.dart';

class CategorieProductsBody extends StatefulWidget {
  final String? categoryId;
  const CategorieProductsBody({Key? key, this.categoryId}) : super(key: key);

  @override
  State<CategorieProductsBody> createState() => _CategorieProductsBodyState();
}

class _CategorieProductsBodyState extends State<CategorieProductsBody> {
  String selectedCity = "all";
  String selectedSubCategory = "all";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedCity,
                  decoration: InputDecoration(
                    labelText: 'selectCity'.tr,
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedCity = value ?? "all";
                    });
                  },
                  items: cities
                      .map((e) => DropdownMenuItem<String>(
                            value: e.name,
                            child: Text(
                              e.name.tr,
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedSubCategory,
                  decoration: InputDecoration(
                    labelText: 'selectSubCategory'.tr,
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedSubCategory = value ?? "all";
                    });
                  },
                  items: Category.getSubCategorie(
                          widget.categoryId?.toLowerCase() ?? '')
                      .map((e) => DropdownMenuItem<String>(
                            value: e.toLowerCase(),
                            child: Text(
                              e.tr,
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: UserAndProductStreamBuilder(
            categoryid: widget.categoryId,
            city: selectedCity,
            subCategory: selectedSubCategory,
          ),
        ),
      ],
    );
  }
}
