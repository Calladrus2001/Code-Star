import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:code_star/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

enum pageStatus { START, ONGOING }

class HearingTest extends StatefulWidget {
  const HearingTest({Key? key}) : super(key: key);

  @override
  State<HearingTest> createState() => _HearingTestState();
}

class _HearingTestState extends State<HearingTest> {
  final box = GetStorage();
  late String? UserID = "";
  pageStatus status = pageStatus.START;
  bool isDiffSelected = false;
  int? _value = 0;
  List<String> urls = [];
  final audioplayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    UserID = box.read("UserID");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.help_outline, color: clr1),
              ),
              status == pageStatus.START
                  ? Column(
                      children: [
                        Container(
                          height: 250,
                          child: Image(
                              image: AssetImage("assets/images/writing.png")),
                        ),
                        SizedBox(height: 32),
                        Text(
                          "Select difficulty level",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List<Widget>.generate(
                            3,
                            (int index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: ChoiceChip(
                                  selectedColor: clr1,
                                  disabledColor: Colors.grey,
                                  label: Text('${difficult[index]}',
                                      style: TextStyle(color: Colors.white)),
                                  selected: _value == index,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _value = selected ? index : null;
                                      if (_value == null) {
                                        isDiffSelected = false;
                                      } else {
                                        isDiffSelected = true;
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                          ).toList(),
                        ),
                        SizedBox(height: 16),

                        SizedBox(height: 32),

                        /// start button
                        GestureDetector(
                          child: Center(
                              child: Container(
                                  height: 50,
                                  width: 200,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: clr1,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  child: Text("Start the Writing Test",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)))),
                          onTap: () async {
                            if (isDiffSelected) {
                              var response = await http.get(Uri.parse(
                                  "$baseUrl/eval?userID=$UserID&type=Writing"));
                              if (response.statusCode == 200) {
                                var responseString = response.body;
                                Map<String, dynamic> res =
                                    jsonDecode(responseString);
                                setState(() {
                                  urls = res["urls"];
                                  status = pageStatus.ONGOING;
                                });
                              }
                            } else {
                              Get.snackbar(
                                  "Code:Star", "Empty Input fields detected");
                            }
                          },
                        )
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
