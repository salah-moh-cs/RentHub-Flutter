import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/product_model.dart';
import '../../../global widget/product_card.dart';

class CustomSearchDelegate extends SearchDelegate {
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  String get searchFieldLabel => "search".tr;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = "",
        icon: const Icon(Icons.close),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => Get.back(),
      icon: const Icon(Icons.arrow_back),
      tooltip: 'back'.tr,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const SizedBox();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '${'searchResultsFor'.tr} "$query"',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .orderBy("rating", descending: true)
                  .where("isaccept", isEqualTo: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return Center(child: Text('noProductFound'.tr));
                }
                final values = snapshot.data!.docs;
                List<ProductModel> products = [];
                for (final val in values) {
                  ProductModel product = ProductModel.fromJson(
                    val.data() as Map<String, dynamic>,
                  );
                  products.add(product);
                }

                List<ProductModel> filteredProducts = products
                    .where(
                      (product) => product.productName.toLowerCase().contains(
                            query.toLowerCase(),
                          ),
                    )
                    .toList();

                return filteredProducts.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final product = filteredProducts[index];
                          return ProductCard(product: product);
                        },
                      )
                    : Center(child: Text('noProductFound'.tr));
              },
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '${'searchResultsFor'.tr}"$query"',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('products')
                .orderBy("rating", descending: true)
                .where("isaccept", isEqualTo: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return Center(child: Text('noProductFound'.tr));
              }
              final values = snapshot.data!.docs;
              List<ProductModel> products = [];
              for (final val in values) {
                ProductModel product = ProductModel.fromJson(
                  val.data() as Map<String, dynamic>,
                );
                products.add(product);
              }

              List<ProductModel> filteredProducts = products
                  .where(
                    (product) => product.productName.toLowerCase().contains(
                          query.toLowerCase(),
                        ),
                  )
                  .toList();

              return filteredProducts.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredProducts.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == filteredProducts.length) {
                          return SizedBox(height: Get.height * .1);
                        } else {
                          final product = filteredProducts[index];
                          return ProductCard(product: product);
                        }
                      },
                    )
                  : Center(child: Text('noProductFound'.tr));
            },
          ),
        ),
      ],
    );
  }
}
