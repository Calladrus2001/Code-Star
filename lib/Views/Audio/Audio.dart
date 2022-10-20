import 'dart:convert';

import 'package:blur/blur.dart';
import 'package:code_star/Utils/constants.dart';
import 'package:code_star/Views/Audio/AddAudio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:code_star/Views/Evaluate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({Key? key}) : super(key: key);

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final box = GetStorage();
  late String userID;
  late List<dynamic> audioFiles;
  bool haveFiles = true;

  @override
  void initState() {
    userID = box.read("userID");
    getAudioFiles();
    super.initState();
  }

  void getAudioFiles() async {
    var response =
        await http.get(Uri.parse("${baseUrl}/getAudio?userID=${userID}"));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseString = jsonDecode(response.body);
      audioFiles = responseString["audioFiles"];
      if (audioFiles != null) {
        setState(() {
          haveFiles = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthVal = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: clr1,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Get.to(() => AddAudioScreen());
        },
      ),
      body: haveFiles
          ? Stack(
              children: [
                /// Main Body
                Positioned(
                    top: 50,
                    left: 1,
                    right: 1,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Container(
                              height: 600,
                              width: double.infinity,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: audioFiles.length,
                                  itemBuilder: (context, int idx) {
                                    return Card(
                                      elevation: 2.0,
                                      child: ListTile(
                                        leading: Text(audioFiles[idx]["name"]),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                    )),

                /// Evaluate Yourself Button
                Positioned(
                  bottom: 20,
                  left: widthVal / 3,
                  child: GestureDetector(
                    child: Chip(
                      backgroundColor: Colors.white,
                      elevation: 4.0,
                      label: Text(
                        "Evaluate Yourself",
                        style: TextStyle(color: clr1),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),

                /// Evaluation options
              ],
            )
          : Center(child: CircularProgressIndicator(color: clr1)),
    );
  }
}
