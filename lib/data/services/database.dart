import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:praduation_project/data/model/chatuser_db.dart';
import 'package:praduation_project/data/model/user_account_model.dart';
import 'package:praduation_project/global%20widget/no_internet_view.dart';

class DatabaseFirestore extends GetxController {
  Future addUserInfoToDB(String userId, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  static User? get userInfo {
    return FirebaseAuth.instance.currentUser;
  }

  static FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;

  // static Future<void> addUser(
  //     String phoneNumber, String username, String imgUrl) async {
  //   Map<String, dynamic> data = {
  //     "email": userInfo!.email.toString(),
  //     "Uid": userInfo!.uid,
  //     "Phone": phoneNumber,
  //     "username": username,
  //     "imgUrl": imgUrl,
  //   };

  //   await firebaseInstance.collection("users").doc(userInfo?.uid).set(data);
  // }
  static Future<UserAccount> getUser() async {
    Completer<UserAccount> completer = Completer<UserAccount>();

    Timer(const Duration(seconds: 7), () {
      if (!completer.isCompleted) {
        Get.offAll(() => const NoInternetView());
      }
    });

    try {
      final paths =
          await firebaseInstance.collection("users").doc(userInfo?.uid).get();
      Map<String, dynamic> data = paths.data() ?? {};

      if (!completer.isCompleted) {
        completer.complete(UserAccount.formJson(data));
      }
      // } on FirebaseException catch (e) {
      //   if (!completer.isCompleted) {qضq
      //     showDialog(
      //       context: Get.overlayContext!,
      //       builder: (BuildContext context) {
      //         return AlertDialog(
      //           title: Text('Firebase Exception'),
      //           content: Text(e.message.toString()),
      //         );
      //       },
      //     );
      //   }
    } catch (e) {
      if (!completer.isCompleted) {
        Get.offAll(() => const NoInternetView());
      }
    }

    return completer.future;
  }

  static Future<void> updateUserImage(String url) async {
    await firebaseInstance
        .collection("users")
        .doc(userInfo?.uid)
        .update({'imageurl': url});
  }

  static Future<void> updateUsername(String? newUsername) async {
    if (newUsername != null) {
      try {
        DatabaseFirestore.firebaseInstance
            .collection("users")
            .doc(userInfo!.uid)
            .update({'userName': newUsername});
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
  }

  static Future<void> updatePhoneNumber(String? newPhoneNumber) async {
    if (newPhoneNumber != null) {
      try {
        DatabaseFirestore.firebaseInstance
            .collection("users")
            .doc(userInfo!.uid)
            .update({'mobileNumber': newPhoneNumber});
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
  }

  static Future<void> updateIsVerify(bool isEmailVerified) async {
    try {
      await firebaseInstance
          .collection("users")
          .doc(userInfo?.uid)
          .update({'isEmailVerified': isEmailVerified});
    } catch (e) {
      if (kDebugMode) {
        print("errrrror ${e.toString()}");
      }
    }
  }

  static Stream<UserAccountChat> getUserByIdStream(String id) {
    return firebaseInstance.collection("users").doc(id).snapshots().map((doc) {
      final data = doc.data() ?? {};

      return UserAccountChat.formJson(data);
    });
  }

  static incrementReviwed(String thisuid) async {
    try {
      if (kDebugMode) {
        print("done");
      }
      await firebaseInstance.collection('users').doc(thisuid).update({
        "reviewd": FieldValue.arrayUnion([userInfo!.uid])
      });
    } catch (e) {
      if (kDebugMode) {
        print(thisuid);
      }
      if (kDebugMode) {
        print('Error updating document: $e');
      }
    }
  }

  static Future<UserAccountChat?> getUserById(String id) async {
    try {
      final doc = await firebaseInstance.collection("users").doc(id).get();
      final data = doc.data() ?? {};
      final userAccountChat = UserAccountChat.formJson(data);
      if (userAccountChat.uid == null) {
        return null;
      }
      return userAccountChat;
    } catch (err) {
      rethrow;
    }
  }
}
  // Future<void> addNewProduct(Map productdata, File image) async {
  //   var pathimage = image.toString();
  //   var temp = pathimage.lastIndexOf('/');
  //   var result = pathimage.substring(temp + 1);
  //   print(result);
  //   final ref =
  //       FirebaseStorage.instance.ref().child('product_images').child(result);
  //   var response = await ref.putFile(image);
  //   print("Updated $response");
  //   var imageUrl = await ref.getDownloadURL();

  //   try {
  //     var response = await firebaseInstance.collection('productlist').add({
  //       'product_name': productdata['p_name'],
  //       'product_price': productdata['p_price'],
  //       "product_upload_date": productdata['p_upload_date'],
  //       'product_image': imageUrl,
  //       'user_Id': userInfo!.uid,
  //       "phone_number": productdata['phone_number'],
  //     });
  //     print("Firebase response1111 $response");
  //     Get.back();
  //   } catch (exception) {
  //     print("Error Saving Data at firestore $exception");
  //   }
  // }

