import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/product_model.dart';
import '../../../global widget/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminHomeView extends StatefulWidget {
  const AdminHomeView({super.key});

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  FirebaseFirestore db = FirebaseFirestore.instance;
  bool isFavourite = false;
  List favourotes = [];
  List<ProductModel> products = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("adminPage".tr),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'pending'.tr),
            Tab(text: 'highreports'.tr),
            Tab(text: 'allitems'.tr),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: db
                      .collection('products')
                      .orderBy("rate", descending: true)
                      .where(
                        "isaccept",
                        isEqualTo: false,
                      )
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      Fluttertoast.showToast(
                          msg: "${"error".tr} : ${snapshot.error}");
                      printInfo(info: snapshot.error.toString());
                      return Center(child: Text("${snapshot.error}"));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final values = snapshot.data!.docs;
                    products = [];
                    for (final val in values) {
                      ProductModel product = ProductModel.fromJson(
                          val.data() as Map<String, dynamic>);
                      products.add(product);
                    }

                    return products.isNotEmpty
                        ? ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (BuildContext context, int index) {
                              final product = products[index];
                              return ProductCard(product: product);
                            },
                          )
                        : Center(
                            child: Text(
                              'noProductFound'.tr,
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
          Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: db
                      .collection('products')
                      .orderBy("rate", descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      Fluttertoast.showToast(
                          msg: "${"error".tr} : ${snapshot.error}");
                      printInfo(info: snapshot.error.toString());
                      return Center(child: Text("${snapshot.error}"));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final values = snapshot.data!.docs;
                    List<ProductModel> products = [];
                    for (final val in values) {
                      ProductModel product = ProductModel.fromJson(
                          val.data() as Map<String, dynamic>);
                      products.add(product);
                    }
                    final filteredProducts = products.where((product) =>
                        product.report != null && product.report!.length > 10);
                    return filteredProducts.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredProducts.length,
                            itemBuilder: (BuildContext context, int index) {
                              final product = filteredProducts.elementAt(index);
                              return ProductCard(product: product);
                            },
                          )
                        : Center(
                            child: Text(
                              'noProductFound'.tr,
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
          Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: db
                      .collection('products')
                      .orderBy("rate", descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      Fluttertoast.showToast(
                          msg: "${"error".tr} : ${snapshot.error}");
                      printInfo(info: snapshot.error.toString());
                      return Center(child: Text("${snapshot.error}"));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final values = snapshot.data!.docs;
                    products = [];
                    for (final val in values) {
                      ProductModel product = ProductModel.fromJson(
                          val.data() as Map<String, dynamic>);
                      products.add(product);
                    }

                    return products.isNotEmpty
                        ? ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (BuildContext context, int index) {
                              printInfo(info: Get.height.toString());
                              final product = products[index];
                              return ProductCard(product: product);
                            },
                          )
                        : Center(
                            child: Text(
                              'noProductFound'.tr,
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
