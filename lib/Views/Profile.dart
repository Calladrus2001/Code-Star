import 'package:code_star/Utils/constants.dart';
import 'package:code_star/Views/Auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final box = GetStorage();
  late String userID;

  @override
  void initState() {
    userID = box.read("userID");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: clr1,
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(40))),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.account_circle_rounded,
                            color: clr1,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text("UserID: ${userID}",
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: SizedBox(height: 1)),
            GestureDetector(
              child: Center(
                  child: Chip(
                elevation: 2.0,
                backgroundColor: clr1,
                label: Text("Logout",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500)),
              )),
              onTap: () {
                setState(() {
                  box.remove("userID");
                  userID = "";
                });
                Get.to(() => AuthScreen());
              },
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
