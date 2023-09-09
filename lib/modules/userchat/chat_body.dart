import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:praduation_project/data/services/chat_db.dart';
import 'package:praduation_project/data/services/database.dart';
import 'package:praduation_project/data/model/user_account_model.dart';

import '../../data/model/chatuser_db.dart';
import 'chat_message.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late Stream<List<QueryDocumentSnapshot>> chatStream;

  @override
  void initState() {
    super.initState();
    chatStream = ChatDatabase.getUserChat();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<QueryDocumentSnapshot>>(
            stream: chatStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
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
              List<QueryDocumentSnapshot<Object?>>? values = snapshot.data!;

              return ListView.builder(
                itemCount: values.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      values[index].data() as Map<String, dynamic>;

                  return UserChatIcon(
                    docsId: values[index].id,
                    data: data,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class UserChatIcon extends StatelessWidget {
  const UserChatIcon({
    Key? key,
    required this.data,
    required this.docsId,
  }) : super(key: key);

  final Map<String, dynamic> data;
  final String docsId;

  @override
  Widget build(BuildContext context) {
    String id = data['to'];
    if (id == UserAccount.info!.uid) {
      id = data['from'];
    }

    return StreamBuilder<UserAccountChat>(
      stream: DatabaseFirestore.getUserByIdStream(id),
      builder: (
        BuildContext context,
        AsyncSnapshot<UserAccountChat> snapshot,
      ) {
        if (snapshot.hasError) {
          Fluttertoast.showToast(
            msg: "${"error".tr} : ${snapshot.error}",
          );
          printInfo(info: snapshot.error.toString());
          return Center(child: Text("${snapshot.error}"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final value = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.only(right: 8.0, top: 8.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundImage: CachedNetworkImageProvider(value.imageurl),
              ),
              subtitle: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chat')
                    .doc(docsId)
                    .snapshots(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot,
                ) {
                  if (snapshot.hasData) {
                    Map<String, dynamic>? chatData =
                        snapshot.data!.data() as Map<String, dynamic>?;

                    if (chatData != null) {
                      String lastMessage = chatData['lastmessage'] ?? '';

                      return data["messages"].isEmpty
                          ? const Text("Press to chat")
                          : data["messages"].last["msg"].toString().startsWith(
                                    'https://firebasestorage',
                                  )
                              ? const Text("Image press to see")
                              : Text(
                                  lastMessage,
                                  overflow: TextOverflow.ellipsis,
                                );
                    }
                  }
                  return Container();
                },
              ),
              title: Text(value.username),
              onTap: () {
                printInfo(info: docsId);
                Get.to(
                  () => ChatMessages(
                    docId: docsId,
                    value: value,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
