// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:praduation_project/data/services/database.dart';

class UserAccount {
  static UserAccount? info;

  String username;
  String phoneNumber;
  String email;
  bool isadmin;
  String imageurl;
  String uid;
  List? reviewd;
  List<dynamic>? favorites;
  bool isEmailVerified;
  UserAccount({
    this.isadmin = false,
    required this.username,
    required this.phoneNumber,
    required this.email,
    required this.imageurl,
    required this.uid,
    this.favorites,
    required this.isEmailVerified,
    this.reviewd,
  });

  factory UserAccount.formJson(Map<String, dynamic> json) {
    info = UserAccount(
      isadmin: json["isadmin"] ?? false,
      username: json['userName'] ?? "null user",
      phoneNumber: json["mobileNumber"] ?? "null phone",
      email: json["email"] ?? "null email",
      imageurl: json["imageurl"] ?? "null img",
      uid: json["Uid"] ?? "null uid",
      isEmailVerified: json["isEmailVerified"] ?? false,
      reviewd: json["reviewd"],
      favorites: json["favorites"],
    );
    return info!;
  }
  static void clearUserData() {
    info = null;
  }

  static void setdata() {
    info = info = UserAccount(
      imageurl: '',
      reviewd: [],
      favorites: [],
      isadmin: false,
      isEmailVerified: true,
      uid: UserAccount.info!.uid,
      email: '',
      username: 'Guest',
      phoneNumber: '',
    );
  }

  bool get isAdmin {
    // List<String> adminsUuid = [
    //   "WsBCfKl3zqOChn2dOp9WSZe5W0P2",
    //   "pJJfj0PadeQYi4UmHC2AIaHnBMs1",
    // ];
    // printInfo(info: adminsUuid.contains(uid).toString());
    // print(isadmin);
    return isadmin; // adminsUuid.contains(uid);
  }

  Future<void> addToFavorites(String productId) async {
    favorites ??= [];

    if (!favorites!.contains(productId)) {
      favorites!.add(productId);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'favorites': favorites});
    }
  }

  Future<void> removeFromFavorites(String productId) async {
    if (favorites != null && favorites!.contains(productId)) {
      favorites!.remove(productId);
      printInfo(info: "uuuid $uid");

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'favorites': favorites});
    }
  }

  Future<void> updateImage(String? url) async {
    if (url != null) {
      try {
        DatabaseFirestore.updateUserImage(url);
        imageurl = url;
      } catch (e) {
        printError(info: e.toString());
      }
    }
  }

  Future<void> updateIsVerify(bool? isEmailVerified) async {
    if (isEmailVerified != null) {
      try {
        printInfo(info: isEmailVerified.toString());

        DatabaseFirestore.updateIsVerify(isEmailVerified);
        isEmailVerified = isEmailVerified;
      } catch (e) {
        printError(info: e.toString());
      }
    }
  }

  Future<void> updateUsername(String? username) async {
    if (username != null) {
      try {
        DatabaseFirestore.updateUsername(username);
        this.username = username;
      } catch (e) {
        printError(info: e.toString());
      }
    }
  }

  static void updateViewr(String thisid) async {
    try {
      DatabaseFirestore.incrementReviwed(thisid);
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> updatePhoneNumber(String? phoneNumber) async {
    if (phoneNumber != null) {
      try {
        DatabaseFirestore.updatePhoneNumber(phoneNumber);
        this.phoneNumber = phoneNumber;
      } catch (e) {
        printError(info: e.toString());
      }
    }
  }

  UserAccount copyWith({
    String? username,
    String? phoneNumber,
    String? email,
    String? imageurl,
    List? reviewd,
    List<dynamic>? favorites,
    bool? isEmailVerified,
  }) {
    return UserAccount(
      uid: uid,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      imageurl: imageurl ?? this.imageurl,
      reviewd: reviewd ?? this.reviewd,
      favorites: favorites ?? this.favorites,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  @override
  String toString() {
    return '''
UserAccount(
  imageurl: $imageurl,
  username: $username,
  phoneNumber: $phoneNumber,
  email: $email,
  uid: $uid, 
  reviewd: $reviewd, 
  favorites: $favorites,
  isEmailVerified: $isEmailVerified)
''';
  }

  Future<void> update() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update(toJson());
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userName': username,
      'mobileNumber': phoneNumber,
      'email': email,
      'imageurl': imageurl,
      'Uid': uid,
      'reviewd': reviewd,
      'favorites': favorites,
      'isEmailVerified': isEmailVerified,
    };
  }
}
