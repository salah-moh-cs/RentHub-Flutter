import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/model/chatuser_db.dart';
import '../../../data/model/user_account_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../../global widget/custom_card.dart';
import '../../../global widget/image_viewer_list.dart';

class CustomHeaderWidget extends StatelessWidget {
  final UserAccountChat user;
  const CustomHeaderWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          GestureDetector(
            onTap: () {
              ImageViewerList.show(imageUrls: [user.imageurl]);
            },
            child: Hero(
              tag: user.imageurl,
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image(
                    fit: BoxFit.cover,
                    width: 140,
                    height: 140,
                    image: CachedNetworkImageProvider(user.imageurl),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              user.username,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.remove_red_eye),
              const SizedBox(width: 10),
              Text(
                '${'visitors'.tr} : ${user.reviewd?.length ?? "0"}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

class CustomCurrentHeaderWidget extends StatefulWidget {
  final UserAccount user;
  const CustomCurrentHeaderWidget({
    super.key,
    required this.user,
  });

  @override
  State<CustomCurrentHeaderWidget> createState() =>
      _CustomCurrentHeaderWidgetState();
}

class _CustomCurrentHeaderWidgetState extends State<CustomCurrentHeaderWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          GestureDetector(
            onTap: () {
              ImageViewerList.show(imageUrls: [widget.user.imageurl]);
            },
            child: Stack(
              children: [
                Hero(
                  tag: widget.user.imageurl,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image(
                          fit: BoxFit.cover,
                          width: 140,
                          height: 140,
                          image:
                              CachedNetworkImageProvider(widget.user.imageurl),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isLoading)
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: CircularProgressIndicator(),
                  ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: MaterialButton(
                    height: 35,
                    minWidth: 35,
                    shape: CircleBorder(
                      side: BorderSide(
                        color: Get.theme.colorScheme.background,
                        width: 4,
                      ),
                    ),
                    color: Get.theme.colorScheme.background,
                    child: Icon(
                      Icons.edit,
                      size: 16.0,
                      color: Get.theme.colorScheme.onBackground,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => bottomSheet(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              widget.user.username,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.remove_red_eye),
              const SizedBox(width: 10),
              Text(
                '${'visitors'.tr}: ${widget.user.reviewd?.length ?? "0"}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: Get.height * .35,
      width: Get.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Center(
            child: Text(
              "chosesProfilePhoto".tr,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: CustomCard(
                  title: "camera".tr,
                  icons: Icons.camera,
                  onTap: () {
                    updateUserProfileImage(ImageSource.camera);
                  },
                ),
              ),
              Expanded(
                child: CustomCard(
                  title: "gallery".tr,
                  icons: Icons.image,
                  onTap: () {
                    updateUserProfileImage(ImageSource.gallery);
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> updateUserProfileImage(ImageSource source) async {
    String? path = await ImageManipulation.takeImage(source);

    if (path != null) {
      Get.back();

      setState(() {
        isLoading = true;
      });
      await ImageManipulation.uploadImageToFirebaseStorage(path);
      final url = await ImageManipulation.getDownloadImageUrl(path);
      if (kDebugMode) {
        print("ImageManipulation: url -> $url");
      }

      UserAccount.info!.updateImage(url);

      setState(() {
        isLoading = false;
      });
    } else {
      Get.back();
    }
  }
}

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
      if (kDebugMode) {
        print("ImageManipulation: url -> $url");
      }
      return url;
    }
    return null;
  }
}
