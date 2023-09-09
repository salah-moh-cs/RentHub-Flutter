class UserAccountChat {
  static UserAccountChat? info;

  String username;
  String phoneNumber;
  String email;
  String imageurl;
  String? uid;
  List? reviewd;
  bool isEmailVerified;
  UserAccountChat({
    required this.username,
    required this.phoneNumber,
    required this.email,
    required this.imageurl,
    required this.uid,
    required this.isEmailVerified,
    this.reviewd,
  });

  factory UserAccountChat.formJson(Map<String, dynamic> json) {
    info = UserAccountChat(
        uid: json["Uid"],
        username: json['userName'] ?? "null user",
        phoneNumber: json["mobileNumber"] ?? "null phone",
        email: json["email"] ?? "null email",
        imageurl: json["imageurl"] ?? "null img",
        isEmailVerified: json["isEmailVerified"] ?? false,
        reviewd: json["reviewd"]);
    return info!;
  }

  // void updateViewr(String thisid) async {
  //   // try {
  //   //   DataBasefirestore.incrementReviwed(thisid);
  //   // } catch (e) {
  //   //   printError(info: e.toString());
  //   // }
  // }
}
