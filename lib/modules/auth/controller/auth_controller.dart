import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:praduation_project/modules/auth/view/otp/send_otp.dart';
import 'package:praduation_project/modules/home/bindings/home_binding.dart';
import 'package:praduation_project/modules/home/views/home_view.dart';
import 'package:praduation_project/data/services/database.dart';
import 'package:praduation_project/data/model/user_account_model.dart';
import '../../../data/model/product_model.dart';
import '../view/login/login_view.dart';

class AuthController extends GetxController {
  List<ProductModel> loginUserData = [];
  //final firebaseinstance = FirebaseFirestore.instance;
  //GoogleSignIn googleSignIn = GoogleSignIn(scopes: ["email"]);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //Authcontroller.intance
  static AuthController instance = Get.find();
  //email , password,name

  FirebaseAuth auth = FirebaseAuth.instance;

//register method
  Future<void> createUserWithEmailAndPassword(
      String email,
      String password,
      String imagUrl,
      String username,
      String phone,
      bool isEmailVerified) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      Map<String, dynamic> userInfoMap = {
        "email": email,
        "userName": username,
        "imageurl": imagUrl,
        "mobileNumber": phone,
        "reviewd": [],
        "isEmailVerified": isEmailVerified,
        "Uid": auth.currentUser!.uid,
      };

      DatabaseFirestore().addUserInfoToDB(auth.currentUser!.uid, userInfoMap);

      await DatabaseFirestore.getUser();
      if (UserAccount.info!.isEmailVerified == false) {
        Get.off(() => const SendOTPView());
      } else {
        Get.off(() => HomeView(), binding: HomeBinding());
      }
    } on FirebaseAuthException catch (e) {
      // Create custom error message
      String errorMessage = 'unableToCreateAccountPleaseTryAgainLater'.tr;
      printError(info: e.code.toString());

      // Check the type of error and create a custom error message
      if (e.code == 'email-already-in-use') {
        errorMessage = 'thisEmailIsAlreadyInUsePleaseChooseAnotherEmail'.tr;
      } else if (e.code == 'weak-password') {
        errorMessage = 'thePasswordIsTooWeakPleaseChooseAStrongerPassword'.tr;
      }

      Get.snackbar("aboutUser".tr, errorMessage,
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text(
            'accountCreationFailed'.tr,
            style: const TextStyle(color: Colors.white),
          ),
          messageText: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ));
    }
  }

  void guestLogin() async {
    try {
      // Perform the anonymous login
      UserAccount.setdata(); // As
      await auth.signInAnonymously();

      Get.off(() => HomeView(), binding: HomeBinding());
    } catch (e) {
      if (kDebugMode) {
        print('Guest login failed: $e');
      }
    }
  }

  bool isUserSignedInAnonymously() {
    final currentUser = _auth.currentUser;
    if (currentUser != null && currentUser.isAnonymous) {
      return true;
    }
    return false;
  }

// login method
  Future<bool> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      await DatabaseFirestore.getUser();

      if (UserAccount.info!.isEmailVerified == false) {
        Get.off(const SendOTPView());
      } else {
        Get.off(() => HomeView(), binding: HomeBinding());
      }

      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'anErrorOccurredDuringLoginPleaseTryAgainLater'.tr;

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'invalidEmailAddressPleaseEnterAValidEmail'.tr;
          break;
        case 'user-disabled':
          errorMessage = 'Thisuseraccounthasbeendisabled'.tr;
          break;
        case 'user-not-found':
        case 'wrong-password':
          errorMessage = 'invalidEmailOrPasswordPleaseCheckYourCredentials'.tr;
          break;
        default:
          errorMessage = 'anErrorOccurredDuringLoginPleaseTryAgainLater'.tr;
      }

      Get.snackbar(
        "aboutLogin".tr,
        "loginMessage".tr,
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          'loginFailed'.tr,
          style: const TextStyle(color: Colors.white),
        ),
        messageText: Text(
          errorMessage,
          style: const TextStyle(color: Colors.white),
        ),
      );

      return false;
    }
  }

  void logOut() async {
    final isSignedInWithGoogle = await googleSignIn.isSignedIn();
    if (isSignedInWithGoogle) {
      printInfo(info: "Google Signout");
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
      // await auth.signOut();
    }

    final isSignedInWithEmail = auth.currentUser != null;
    if (isSignedInWithEmail) {
      await auth.signOut();
    }

    // Clear user data
    // UserAccount
    //     .clearUserData(); // Assuming you have a static method to clear user data in the UserAccount class

    Get.offAll(const LoginView());
  }

  Future<User?> googleSignInMethod() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      final email = user!.email;
      if (await checkEmailExists(email)) {
        await DatabaseFirestore.getUser();
        // ignore: unnecessary_null_comparison
        if (UserAccount.info!.phoneNumber == null) {
          String? phoneNumber = await promptPhoneNumber();

          Map<String, dynamic> userInfoMap = {
            "isadmin": false,
            "email": user.email,
            "userName": user.displayName,
            "isEmailVerified": true,
            "imageurl": user.photoURL,
            "mobileNumber": phoneNumber, // add phone number to user info map
            "Uid": user.uid
          };
          await addUserToFirestore(userCredential.user!.uid, userInfoMap);
          await DatabaseFirestore.getUser();
        }
      } else {
        // printInfo(info: user!.uid.toString());
// if(user.email)
        String? phoneNumber = await promptPhoneNumber();

        Map<String, dynamic> userInfoMap = {
          "email": user.email,
          "userName": user.displayName,
          "isEmailVerified": true,
          "imageurl": user.photoURL,
          "mobileNumber": phoneNumber, // add phone number to user info map
          "Uid": user.uid
        };
        await addUserToFirestore(userCredential.user!.uid, userInfoMap);
        await DatabaseFirestore.getUser();
      }
      Get.offAll(() => HomeView(), binding: HomeBinding());
    } catch (error) {
      printInfo(info: 'Error signing in with Google: $error');
      return null;
    }
    return null;
  }

  Future<bool> checkEmailExists(String? email) async {
    if (email == null) {
      return false;
    }
    try {
      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      final QuerySnapshot querySnapshot =
          await usersCollection.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printInfo(info: 'Error checking email in Firestore: $e');
      return false;
    }
  }

  Future<String?> promptPhoneNumber() async {
    String? phoneNumber;
    final phoneNumberKey = GlobalKey<FormFieldState<String>>();

    await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return false; // تعطيل زر الرجوع في الهاتف النقال
            },
            child: AlertDialog(
              title: Text('enterYourMobileNumber'.tr),
              content: TextFormField(
                key: phoneNumberKey,
                validator: validatePhoneNumber,
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  phoneNumber = value;
                },
                decoration: const InputDecoration(errorMaxLines: 3),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (phoneNumberKey.currentState!.validate()) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text('save'.tr),
                ),
              ],
            ),
          );
        });

    return phoneNumber;
  }

  String? validatePhoneNumber(String? value) {
    printInfo(info: "errorrrrrrrr");
    if (value == null || value.isEmpty) {
      return 'pleaseEnterYourMobileNumber'.tr;
    }
    final regexp = RegExp(r'^07\d{8}$');
    if (!regexp.hasMatch(value)) {
      return '${'pleaseEnterAValidPhoneNumber'.tr} : (${"ex".tr}:07xxxxxxxx)';
    }
    return null;
  }

  Future<void> addUserToFirestore(String uid, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).set(data);
  }
}

class GoogleSignInException implements Exception {
  final String message;

  GoogleSignInException(this.message);

  @override
  String toString() {
    return 'GoogleSignInException: $message';
  }
}
