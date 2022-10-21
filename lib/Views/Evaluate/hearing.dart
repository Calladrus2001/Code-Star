import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class HearingTest extends StatefulWidget {
  const HearingTest({Key? key}) : super(key: key);

  @override
  State<HearingTest> createState() => _HearingTestState();
}

class _HearingTestState extends State<HearingTest> {
  final audioplayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
