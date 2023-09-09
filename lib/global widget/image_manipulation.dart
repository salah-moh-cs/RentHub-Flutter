import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

abstract class ImageManipulation {
  static final ImagePicker imagePicker = ImagePicker();

  static Future<String?> takeImage(ImageSource source) async {
    XFile? image = await imagePicker.pickImage(source: source);
    if (image != null) {
      return image.path;
    }
    return null;
  }

  static Future<void> uploadImageToFirebaseStorage(String path) async {
    File uploadFile = File(path);

    await firebase_storage.FirebaseStorage.instance
        .ref('uploads/${uploadFile.path}')
        .putFile(uploadFile);
  }

  static Future<String> getDownloadImageUrl(String path) async {
    File uploadFile = File(path);
    return firebase_storage.FirebaseStorage.instance
        .ref('uploads/${uploadFile.path}')
        .getDownloadURL();
  }

  static Future<String?> sendToFirebase(ImageSource source,
      {bool isBack = false}) async {
    String? path = await takeImage(source);

    if (isBack) Get.back();

    if (path != null) {
      await uploadImageToFirebaseStorage(path);
      final url = await getDownloadImageUrl(path);

      return url;
    }
    return null;
  }
}
