// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:praduation_project/data/model/user_account_model.dart';

class ProductModel {
  String category;
  String subCategory;
  String city;
  bool isRent;
  String productName;
  String detail;
  double price;
  String brandName;
  String period;
  List<String> imagesUrl;
  Timestamp? createdAt;
  String? userId;
  bool isacceptadmin;
  String? productUid;
  List<dynamic>? rate;
  double rating;
  List<Map<String, dynamic>>? comments = [];
  List<Map<String, dynamic>>? report = [];
  String maxRentalPeriod;
  String minRentalPeriod;
  List<Map<String, dynamic>>? timeList = [];

  ProductModel({
    this.category = "",
    this.subCategory = "",
    this.city = "",
    this.timeList,
    this.productName = "",
    this.detail = "",
    this.price = 0,
    this.brandName = "",
    this.period = "Daily",
    required this.imagesUrl,
    this.createdAt,
    this.userId,
    this.isacceptadmin = false,
    this.productUid,
    this.rating = 5.0,
    this.rate = const [
      {"rating": 5, "userId": "No Rate"}
    ],
    this.comments,
    this.report,
    this.isRent = false,
    this.maxRentalPeriod = "",
    this.minRentalPeriod = "",
  });

  CollectionReference db = FirebaseFirestore.instance.collection('products');

  void clearReports() {
    report?.clear();
    db.doc(productUid).update({'report': []});
  }

  double get getRates {
    double sum = 0.0;
    int count = 0;
    rate?.forEach((entry) {
      if (entry is Map && entry.containsKey('rating')) {
        var rating = entry['rating'];

        if (rating is num) {
          sum += rating.toDouble();
          count++;
        }
      }
    });
    double rating = (sum / count).clamp(1, 5).toDouble();
    printInfo(info: "rating $rating.0");
    return rating;
  }

  Future<void> addToFirebase() async {
    const uuid = Uuid();

    productUid = uuid.v4();
    await db.doc(productUid).set(toJson());
  }

  Future<void> updateProduct() async {
    await db.doc(productUid).update(toJson());
  }

  bool get isFavorite {
    List<dynamic>? favoriteProducts = UserAccount.info?.favorites;
    if (favoriteProducts == null) return false;
    return favoriteProducts.contains(productUid);
  }

  Future<bool> isProductInFavorites(String? productId, String? userId) async {
    final favoritesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites');
    final productDoc = await favoritesCollection.doc(productId).get();
    return productDoc.exists;
  }

  Future<void> delete() async {
    try {
      await db.doc(productUid).delete();
    } catch (e) {
      e.printError();
    }
  }

  Future<void> updateRating(double newRating) async {
    printInfo(info: newRating.toString());
    await db.doc(productUid).update({'rating': newRating.toDouble()});
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      category: json['category'],
      subCategory: json['subcategory'],
      city: json['city'],
      productName: json['productName'],
      detail: json['detail'],
      price: double.tryParse(json['price'].toString()) ?? 0,
      timeList: List<Map<String, dynamic>>.from(json['timeList'] ?? []),
      brandName: json['brandName'],
      period: json['period'],
      imagesUrl: List<String>.from(json['imagesUrl']),
      createdAt: json["createdAt"] ?? Timestamp.now(),
      userId: json["userId"],
      isacceptadmin: json["isaccept"],
      productUid: json["productuid"],
      rate: json["rate"],
      rating: json["rating"] as double,
      comments: List<Map<String, dynamic>>.from(json['comments'] ?? []),
      report: List<Map<String, dynamic>>.from(json['report'] ?? []),
      maxRentalPeriod: json['maxRentalPeriod'] ?? "1",
      minRentalPeriod: json['minRentalPeriod'],
      isRent: json['isRent'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'category': category.toLowerCase(),
      'subcategory': subCategory.toLowerCase(),
      'city': city,
      'productName': productName,
      'detail': detail,
      'price': price,
      'brandName': brandName,
      'period': period,
      'imagesUrl': imagesUrl,
      'createdAt': Timestamp.now(),
      'userId': UserAccount.info!.uid,
      'phoneNumber': UserAccount.info!.phoneNumber,
      'isaccept': isacceptadmin,
      'productuid': productUid,
      'rate': rate,
      'comments': [],
      'report': [],
      'timeList': timeList,
      'rating': getRates,
      'maxRentalPeriod': maxRentalPeriod,
      'minRentalPeriod': minRentalPeriod,
      'isRent': isRent,
    };
    return data;
  }

  Future<void> addComment({required String comment}) async {
    final uuid = UserAccount.info!.uid;
    comments!.add({uuid: comment});

    await db.doc(productUid).update({'comments': comments});
  }

  Future<void> deleteComment(int index) async {
    try {
      comments!.removeAt(index);
      await db.doc(productUid).update({'comments': comments});
    } catch (e) {
      e.printError();
    }
  }

  void addToReport(String userId, String comment) {
    final reportData = {
      'userId': userId,
      'comment': comment,
    };

    final reportList = report ?? [];

    final existingReportIndex =
        reportList.indexWhere((report) => report['userId'] == userId);

    if (existingReportIndex != -1) {
      reportList[existingReportIndex]['comment'] = comment;
    } else {
      reportList.add(reportData);
    }

    db.doc(productUid).update({
      'report': reportList,
    });
  }

  void updateRate(double rating, String userId) {
    if (rate!.any((entry) => entry['userId'] == userId)) {
      // User has already rated, update the existing rating
      final index = rate!.indexWhere((entry) => entry['userId'] == userId);
      rate![index] = {'userId': userId, 'rating': rating};
    } else {
      // User has not yet rated, add a new rating
      rate!.add({'userId': userId, 'rating': rating});
    }
    db.doc(productUid).update({
      'rate': rate,
    });
    // print(getRates);
    updateRating(getRates);
  }

  void updateRentStatus(ProductModel product, bool isrent) {
    FirebaseFirestore.instance
        .collection('products')
        .doc(product.productUid)
        .update({'isRent': isrent}).then((_) {
      printInfo(info: "set to true method");
      printInfo(
          info:
              'Rent status updated successfully in Firebase!${product.isRent}');
    }).catchError((error) {
      printInfo(info: 'Failed to update rent status: $error');
    });
  }

  void addToTimeList(DateTime now, DateTime futureTime) {
    final Duration difference = futureTime.difference(now);

    final Map<String, dynamic> timeEntry = {
      'now': Timestamp.fromDate(now),
      'future': Timestamp.fromDate(futureTime),
      'difference': difference.inMinutes,
    };

    if (timeList != null && timeList!.isNotEmpty) {
      timeList!.removeRange(1, timeList!.length);
    }

    if (timeList != null && timeList!.isNotEmpty) {
      timeList![0] = timeEntry;
    } else {
      timeList = [timeEntry];
    }

    db.doc(productUid).update({
      'timeList': timeList,
    }).then((_) {
      printInfo(info: 'Time list updated successfully in Firebase!');
    }).catchError((error) {
      printInfo(info: 'Failed to update time list: $error');
    });
  }

  String getTimeDifference(int index) {
    if (timeList != null && index >= 0 && index < timeList!.length) {
      final Timestamp nowTimestamp = Timestamp.now();
      final Timestamp futureTimestamp = timeList![index]['future'];

      final DateTime now = nowTimestamp.toDate();
      final DateTime future = futureTimestamp.toDate();

      final Duration difference = future.difference(now);

      final int days = difference.inDays;
      final int hours = difference.inHours.remainder(24);

      String differenceString = '';

      if (days > 0) {
        differenceString += '$days ${"days".tr}';
      }

      if (hours > 0) {
        //Todo ................................
        differenceString += '${"and".tr}$hours ${"hours".tr}';
      }

      // printInfo(info: "Time difference: ${differenceString.trim()}");
      return differenceString.trim();
    }
    printInfo(info: "ssssssssss");
    return "";
  }

  Future<void> changeRented() async {
    try {
      isRent = !isRent;
      printInfo(info: "Product is reanted: $isRent");
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productUid)
          .update({'isRent': isRent});
    } catch (e) {
      e.printError();
    }
  }

  Future<void> get accept async {
    try {
      isacceptadmin = true;
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productUid)
          .update({'isaccept': true});
    } catch (e) {
      e.printError();
    }
  }

  Future<void> get reject async {
    try {
      isacceptadmin = false;
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productUid)
          .update({'isaccept': false});
    } catch (e) {
      e.printError();
    }
  }

  Future<void> update() async {
    try {
      isacceptadmin = false;
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productUid)
          .update(toJson());
    } catch (e) {
      e.printError();
    }
  }

  ProductModel copyWith({
    String? category,
    String? subCategory,
    String? city,
    bool? isRent,
    String? productName,
    String? detail,
    double? price,
    String? brandName,
    String? period,
    List<String>? imagesUrl,
    Timestamp? createdAt,
    String? userId,
    bool? isacceptadmin,
    String? productUid,
    List<dynamic>? rate,
    double? rating,
    List<Map<String, dynamic>>? comments,
    List<Map<String, dynamic>>? report,
    String? maxRentalPeriod,
    String? minRentalPeriod,
    List<Map<String, dynamic>>? timeList,
  }) {
    return ProductModel(
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      city: city ?? this.city,
      isRent: isRent ?? this.isRent,
      productName: productName ?? this.productName,
      detail: detail ?? this.detail,
      price: price ?? this.price,
      brandName: brandName ?? this.brandName,
      period: period ?? this.period,
      imagesUrl: imagesUrl ?? this.imagesUrl,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      isacceptadmin: isacceptadmin ?? this.isacceptadmin,
      productUid: productUid ?? this.productUid,
      rate: rate ?? this.rate,
      rating: rating ?? this.rating,
      comments: comments ?? this.comments,
      report: report ?? this.report,
      maxRentalPeriod: maxRentalPeriod ?? this.maxRentalPeriod,
      minRentalPeriod: minRentalPeriod ?? this.minRentalPeriod,
      timeList: timeList ?? this.timeList,
    );
  }
}
