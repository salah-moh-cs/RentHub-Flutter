import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../data/model/user_account_model.dart';
import '../widgets/user_profile_body.dart';

class CurrentUserProfileView extends StatelessWidget {
  const CurrentUserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    return Scaffold(
      body: StreamBuilder(
          stream: db.collection('users').doc(UserAccount.info!.uid).snapshots(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              Fluttertoast.showToast(msg: "${"error".tr} : ${snapshot.error}");
              printInfo(info: snapshot.error.toString());
              return Center(child: Text("${snapshot.error}"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            Map<String, dynamic>? data = snapshot.data!.data();

            if (data != null) {
              UserAccount.info = UserAccount.formJson(data);
              return CurrentUserProfileBody(user: UserAccount.info!);
            }
            return Center(child: Text("error".tr));
          }),
    );
  }
}
