import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/value/colors.dart';
import '../../data/model/chat_message.dart';
import '../../data/model/chatuser_db.dart';
import '../../data/services/chat_db.dart';
import '../../global widget/image_manipulation.dart';
import '../../global widget/loading_widget.dart';
import '../user_profile/view/user_profile_view.dart';
import 'components/text_messages.dart';

class ChatMessages extends StatefulWidget {
  final String docId;
  final UserAccountChat value;

  const ChatMessages({Key? key, required this.docId, required this.value})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController msgController = TextEditingController();
  bool uploadingImage = false;
  bool isLoading = false;

  @override
  void dispose() {
    _scrollController.dispose();
    msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.onBackground,
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.off(() => UserProfileView(
                      user: widget.value,
                    ));
              },
              child: CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(widget.value.imageurl),
              ),
            ),
            const SizedBox(width: kDefaultPaddin * 0.75),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => UserProfileView(
                          user: widget.value,
                        ));
                  },
                  child: Text(
                    widget.value.username,
                    style: const TextStyle(fontFamily: "Poppins", fontSize: 16),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: LoadingWidget(
        isLoading: isLoading,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.background,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16.0),
                  ),
                ),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chat')
                      .doc(widget.docId)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot) {
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
                    final values =
                        snapshot.data?.data() as Map<String, dynamic>;

                    List<ChatMessage> chats = [];
                    List<dynamic> dataMessage = values['messages'];
                    for (var element in dataMessage) {
                      Map<String, dynamic> map =
                          element as Map<String, dynamic>;
                      ChatMessage message = ChatMessage.fromMap(map);
                      chats.add(message);
                    }

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      scrollToBottom();
                    });

                    return Column(
                      children: [
                        chats.isEmpty
                            ? Expanded(
                                child: Center(
                                  child: Text("chatIsEmpty".tr),
                                ),
                              )
                            : Expanded(
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: chats.length,
                                  itemBuilder: (context, index) {
                                    final messages = chats[index];
                                    if (messages.messageType ==
                                        ChatMessageType.image) {
                                      return MesssageImageBody(
                                        value: widget.value,
                                        messages: messages,
                                      );
                                    }
                                    return MesssageTextBody(
                                      messages: messages,
                                      value: widget.value,
                                    );
                                  },
                                ),
                              ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    onTap: () {
                      if (kDebugMode) {
                        print("object");
                      }
                      Future.delayed(const Duration(milliseconds: 400), () {
                        scrollToBottom();
                      });
                    },
                    style: TextStyle(
                      color: Get.theme.colorScheme.background,
                    ),
                    decoration: InputDecoration(
                      hintText: "typeMessage".tr,
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Get.theme.colorScheme.background,
                      ),
                    ),
                    controller: msgController,
                  ),
                ),
                MaterialButton(
                  minWidth: 35,
                  onPressed: () async {
                    final path =
                        await ImageManipulation.takeImage(ImageSource.gallery);
                    if (path != null) {
                      setState(() {
                        isLoading = true;
                      });

                      await ImageManipulation.uploadImageToFirebaseStorage(
                          path);
                      final url =
                          await ImageManipulation.getDownloadImageUrl(path);
                      ChatDatabase.sendImageMessage(widget.docId, url);
                      msgController.clear();
                      scrollToBottom();

                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: Icon(
                    Icons.image,
                    color: Get.theme.colorScheme.background,
                  ),
                ),
                MaterialButton(
                  minWidth: 35,
                  onPressed: () {
                    final text = msgController.text;

                    if (text.isEmpty) return;
                    msgController.clear();

                    // Update the 'lastmessage' and 'lasttime' fields in Firestore
                    final currentTime = DateTime.now();
                    FirebaseFirestore.instance
                        .collection('chat')
                        .doc(widget.docId)
                        .update({
                      'lastmessage': text,
                      'lasttime': currentTime.toIso8601String(),
                    }).then((value) {
                      // After successfully updating the values, print the last message and time
                      if (kDebugMode) {
                        print('Last Message: $text');
                      }
                      if (kDebugMode) {
                        print('Last Time: $currentTime');
                      }

                      // Then send the message
                      ChatDatabase.sendTextMessage(widget.docId, text);
                      // scrollToBottom();
                    }).catchError((error) {
                      // If an error occurs while updating, print the error message
                      if (kDebugMode) {
                        print(
                            'Error updating lastmessage and lasttime: $error');
                      }
                    });
                  },
                  child: Icon(
                    Icons.send,
                    color: Get.theme.colorScheme.background,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void scrollToBottom() {
    try {
      if (_scrollController.position.maxScrollExtent > 0) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      // Handle the error or display a toast message
      if (kDebugMode) {
        print('Error scrolling to bottom: $e');
      }
      // Display a toast message using Fluttertoast library
    }
  }
}
