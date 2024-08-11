import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../rive/rive.dart';

class IntroNext extends StatefulWidget {
  const IntroNext({super.key});

  @override
  State<IntroNext> createState() => _IntroNextState();
}

class _IntroNextState extends State<IntroNext> {
  final RiveAnimations riveAnimations = RiveAnimations();
  final player = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState

    player.play(
      AssetSource("audios/gibberish.mp3"),
    );

    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height / 2,
              width: MediaQuery.sizeOf(context).width / 2,
              child: RiveAnimation.asset(
                stateMachines: ["shinkuMain"],
                'assets/modeSelection.riv',
                onInit: (artboard) {
                  riveAnimations.onRiveInit(artboard);
                },
              ),
            ),
            FuturisticBox()
          ],
        ),
      ),
    );
  }
}

class FuturisticBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: MediaQuery.sizeOf(context).height / 1.5,
        width: MediaQuery.sizeOf(context).width / 4,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: Colors.blueAccent.withOpacity(0.7),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 18.0,
                fontFamily: 'Courier',
                color: Colors.white,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Ugh... My circuits are buzzing...\nI sense something... or someone.',
                    speed: Duration(milliseconds: 80),
                  ),
                ],
                isRepeatingAnimation: false,
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  // Add your button action here
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  "Relax, I'm here.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
