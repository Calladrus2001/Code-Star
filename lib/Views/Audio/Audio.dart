import 'package:code_star/Utils/constants.dart';
import 'package:code_star/Views/Audio/AddAudio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({Key? key}) : super(key: key);

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: clr1),
        onPressed: () {
          Get.to(() => AddAudioScreen());
        },
      ),
    );
  }
}
