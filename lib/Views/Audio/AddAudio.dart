import 'dart:io';
import 'package:code_star/Utils/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddAudioScreen extends StatefulWidget {
  const AddAudioScreen({Key? key}) : super(key: key);

  @override
  State<AddAudioScreen> createState() => _AddAudioScreenState();
}

class _AddAudioScreenState extends State<AddAudioScreen> {
  final box = GetStorage();
  List<XFile>? _images = [];
  final ImagePicker _picker = ImagePicker();
  bool haveImages = false;
  bool haveAudio = false;
  bool uploading = true;
  int index = 0;
  String text = "";
  DateTime rn = DateTime.now();
  TextEditingController nameController = new TextEditingController();
  late String downloadUrl;
  late String userID;
  late FlutterTts flutterTts;
  var progress = 0.0;

  void initTTS() async {
    flutterTts = FlutterTts();
  }

  @override
  void initState() {
    userID = box.read("userID");
    initTTS();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
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
                        titleStyle: TextStyle(color: clr1),
                        radius: 10,
                        content: Text(
                          "1. Select images of the study material you would like to made Audiofile for.\n\n"
                          "2. Press the Upload Button to generate the AudioFile and save it to Cloud.\n\n"
                          "3. Thats it!",
                          style: TextStyle(color: Colors.grey),
                        ));
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
                          color: clr1,
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
                        imagesToText(_images!);
                        setState(() {
                          haveImages = true;
                        });
                      }
                    },
                  ),
            SizedBox(height: 16),
            haveImages
                ? Center(child: Text("${index + 1}/${_images!.length}"))
                : SizedBox(),
            SizedBox(height: 24),

            /// name textfield
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Enter name of Audiobook',
                  hintText: 'ex. myAwesomeNotes',
                ),
              ),
            ),
            SizedBox(height: 32),

            /// generate AudioFile
            haveAudio
                ? Chip(
                    backgroundColor: Colors.green.shade500,
                    label: Text("Audiobook is available now",
                        style: TextStyle(color: Colors.white)),
                  )
                : GestureDetector(
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
                      if (nameController.text == "" || _images == []) {
                        Get.snackbar(
                            "Code:Star", "Empty input fields detected");
                      } else
                        synth(text);
                    },
                  ),
            SizedBox(height: 64),

            ///upload progress
            uploading
                ? Center(
                    child: Text("Upload: " + progress.toString() + "%",
                        style: TextStyle(color: Colors.grey)))
                : SizedBox()
          ],
        ),
      ),
    );
  }

  void imagesToText(List<XFile> _images) {
    for (int i = 0; i < _images.length; i++) {
      getRecognisedText(_images[i]);
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final TextRecognizer textRecognizer =
        TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        text = text + line.text + "\n";
      }
    }
    textRecognizer.close();
  }

  void synth(String text) async {
    await flutterTts.synthesizeToFile(text, "${nameController.text}.wav");
    await flutterTts.awaitSynthCompletion(true).then((value) async {
      final destination = "${userID}/${nameController.text}.wav";
      final ref = FirebaseStorage.instance.ref(destination);
      UploadTask? task = ref.putFile(File(
          "/storage/emulated/0/Android/data/com.example.code_star/files/${nameController.text}.wav"));
      task.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
            setState(() {
              uploading = false;
            });
            break;
        }
      });
      task.then((res) async {
        downloadUrl = await res.ref.getDownloadURL();
        var response = await http.post(Uri.parse("${baseUrl}/addAudio"), body: {
          "userID": userID,
          "name": "${nameController.text}",
          "downloadUrl": downloadUrl,
          "time":
              "${DateFormat.MMMMd().format(rn)} ${DateFormat.jm().format(rn)}"
        });
        if (response.statusCode == 200) {
          setState(() {
            haveAudio = true;
          });
        }
      });
    });
  }
}
