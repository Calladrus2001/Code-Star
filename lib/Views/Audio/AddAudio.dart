import 'dart:io';
import 'package:code_star/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class AddAudioScreen extends StatefulWidget {
  const AddAudioScreen({Key? key}) : super(key: key);

  @override
  State<AddAudioScreen> createState() => _AddAudioScreenState();
}

class _AddAudioScreenState extends State<AddAudioScreen> {
  List<XFile>? _images = [];
  final ImagePicker _picker = ImagePicker();
  bool haveImages = false;
  int index = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            SizedBox(height: 40),

            /// help btn
            Row(
              children: [
                Expanded(child: SizedBox(width: 1)),
                GestureDetector(
                  child: Icon(Icons.help_outline, color: clr1),
                  onTap: () {
                    Get.defaultDialog(
                        title: "Help",
                        titleStyle: TextStyle(color: Colors.grey),
                        radius: 10,
                        content: Text(
                            "1. Select images of the study material you would like to made Audiofile for.\n\n"
                            "2. Press the Upload Button to generate the AudioFile and save it to Cloud.\n\n"
                            "3. Thats it!"));
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
            SizedBox(height: 20),

            /// pick image
            haveImages
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            if (index >= 1) {
                              setState(() {
                                index -= 1;
                              });
                            }
                          },
                          icon: Icon(Icons.keyboard_arrow_left)),
                      SizedBox(width: 20),
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Image.file(
                          File(_images![index].path),
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(width: 20),
                      IconButton(
                          onPressed: () {
                            if (index < _images!.length - 1) {
                              setState(() {
                                index += 1;
                              });
                            }
                          },
                          icon: Icon(Icons.keyboard_arrow_right))
                    ],
                  )
                : GestureDetector(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Icon(
                        Icons.add_photo_alternate_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    onTap: () async {
                      _images = await _picker.pickMultiImage();
                      if (_images != null) {
                        setState(() {
                          haveImages = true;
                        });
                      }
                    },
                  ),
            SizedBox(height: 16),
            Center(child: Text("${index + 1}/${_images!.length}")),
            SizedBox(height: 24),

            /// generate AudioFile
            haveImages
                ? GestureDetector(
                    child: Container(
                      height: 50,
                      width: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: clr1,
                      ),
                      child: Icon(
                        Icons.upload_rounded,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      //TODO: do the magic
                    },
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
