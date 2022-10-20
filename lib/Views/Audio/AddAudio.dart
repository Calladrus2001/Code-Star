import 'dart:io';
import 'package:code_star/Utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AddAudioScreen extends StatefulWidget {
  const AddAudioScreen({Key? key}) : super(key: key);

  @override
  State<AddAudioScreen> createState() => _AddAudioScreenState();
}

class _AddAudioScreenState extends State<AddAudioScreen> {
  List<XFile>? _images = [];
  final ImagePicker _picker = ImagePicker();
  bool haveImages = false;
  bool haveAudio = false;
  int index = 0;
  String text = "";
  late String downloadUrl;
  late FlutterTts flutterTts;

  void initTTS() async {
    flutterTts = FlutterTts();
    await flutterTts.setSpeechRate(0.6);
  }

  @override
  void initState() {
    initTTS();
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

            /// checklist
            haveImages
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text == null
                              ? CircularProgressIndicator()
                              : Icon(Icons.check),
                          SizedBox(width: 10),
                          Text(text == null
                              ? "Getting Text from images"
                              : "Got Text from images"),
                        ],
                      )
                    ],
                  )
                : SizedBox(),
            SizedBox(height: 16),

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
                      synth(text);
                    },
                  ),
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
    await flutterTts.synthesizeToFile(text, "tts.wav");
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    final destination = "${FirebaseAuth.instance.currentUser!.email}/tts.wav";
    final ref = FirebaseStorage.instance.ref(destination);
    print(appDocPath);
    UploadTask? task = ref.putFile(File(
        "/storage/emulated/0/Android/data/com.example.code_star/files/tts.wav"));
    task.then((res) async {
      downloadUrl = await res.ref.getDownloadURL();
      //TODO: mongoDB add download url for user
      setState(() {
        haveAudio = true;
      });
    });
  }
}
