import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_search_delegate.dart';

class CustomSearchWidget extends StatelessWidget {
  const CustomSearchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            height: Get.height * .07,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              onTap: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              readOnly: true,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "iAmSearchingFor".tr,
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                prefixIconColor: Colors.grey,
                prefixIcon: const Icon(
                  Icons.search,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
