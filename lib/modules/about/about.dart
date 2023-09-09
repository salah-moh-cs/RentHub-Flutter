import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:praduation_project/core/utils/helpers/system_helper.dart';
import '../../data/services/chat_db.dart';
import '../auth/controller/auth_controller.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final any = AuthController.instance.isUserSignedInAnonymously();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: any
          ? const SizedBox()
          : FloatingActionButton(
              tooltip: "Contact Support",
              backgroundColor: Get.theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(70)),
              onPressed: () async {
                // print(UserAccount.info!.uid);
                await ChatDatabase.chatChecker(
                    uuid: 'WsBCfKl3zqOChn2dOp9WSZe5W0P2');
              },
              child: LottieBuilder.asset(
                  'assets/lottie/144860-customer-support.json')),
      extendBodyBehindAppBar: true,
      body: Body(context),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Body(BuildContext context) {
    final isdarkMode = Theme.of(context).brightness == Brightness.dark;

    double height = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    double width = MediaQuery.of(context).size.width;

    return CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            elevation: 0,
            backgroundColor:
                isdarkMode ? const Color(0xff303030) : const Color(0xfffafafa),
            iconTheme: const IconThemeData(color: Colors.black),
            expandedHeight: height * 0.44,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(80),
                            bottomRight: Radius.circular(80)),
                        image: DecorationImage(
                          image: AssetImage('assets/logo/about.gif'),
                          fit: BoxFit.fill,
                        )),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
              ),
              tooltip: 'Go back',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            centerTitle: true,
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Column(
              children: [
                Contact_Addresses(
                    title: 'Facebook',
                    subtitle: 'RentHub',
                    logo: 'assets/logo/facebook_logo.gif',
                    url:
                        'https://web.facebook.com/profile.php?id=100030479496261',
                    color: const Color(0xFF3a449d)),
                Contact_Addresses(
                    title: 'WhatsApp',
                    subtitle: '0782726064',
                    logo: 'assets/logo/whatsapp_logo.gif',
                    url: 'https://wsend.co/962782726064',
                    color: Colors.green),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            const SizedBox(height: 60)
          ])),
        ]);
  }

  // ignore: non_constant_identifier_names
  Widget Contact_Addresses(
      {required String title,
      required String subtitle,
      required String logo,
      required String url,
      required Color color}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: MaterialButton(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: ListTile(
          title: Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          leading: Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: AssetImage(logo))),
          ),
          subtitle:
              Text("  $subtitle", style: const TextStyle(color: Colors.white)),
          trailing: SizedBox(
            width: 55,
            height: 55,
            child: Transform.rotate(
              angle: 3.1,
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/logo/arrow.gif"))),
              ),
            ),
          ),
        ),
        onPressed: () {
          Fluttertoast.showToast(msg: title);
          SystemHelper.makelink(url);
        },
      ),
    );
  }
}
