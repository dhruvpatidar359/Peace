import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../home/home.dart';

class BootScreen extends StatefulWidget {
  const BootScreen({Key? key}) : super(key: key);

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Create an animation with a curve
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Play the animation
    _controller.forward();

    // Play the audio after a short delay

    player.play(
      AssetSource("audios/booting.wav"),
    );

    // Delay navigation to the next screen after the audio is complete
  }

  @override
  void dispose() {
    _controller.dispose();
    player.dispose();
    super.dispose();
  }

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Or your desired background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Boot Animation

            AnimatedTextKit(
              onNext: (int _, bool __) {
                if (counter >= 2) return;
                player.stop();
                player.play(
                  AssetSource("audios/booting.wav"),
                );
                counter++;
              },
              totalRepeatCount: 3,
              animatedTexts: [
                TypewriterAnimatedText("Booting...",
                    textStyle: TextStyle(fontSize: 32, color: Colors.white))
              ],
              isRepeatingAnimation: true,
              repeatForever: false,
            ),

            // Loading Animation

            // Play Sound Effect on boot
          ],
        ),
      ),
    );
  }
}
