import 'package:blur/blur.dart';
import 'package:code_star/Utils/constants.dart';
import 'package:code_star/Views/Audio/AddAudio.dart';
import 'package:code_star/Views/Evaluate.dart';
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
    double widthVal = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: clr1,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Get.to(() => AddAudioScreen());
        },
      ),
      body: Stack(
        children: [
          /// Main Body
          Positioned(top: 20, child: Column()),

          /// Evaluate Yourself Button
          Positioned(
            bottom: 20,
            left: widthVal / 2 - 75,
            right: widthVal / 2 - 75,
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
      ),
    );
  }
}
