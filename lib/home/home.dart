import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peace/gemini/ansBox.dart';
import 'package:peace/rive/rive.dart';
import 'package:peace/speech/speech.dart';
import 'package:rive/rive.dart';
import 'package:watch_it/watch_it.dart';
import 'package:weather_animation/weather_animation.dart';

import '../models/AppState.dart';
import '../weather/weatherWidgets.dart';

class Home extends WatchingStatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final RiveAnimations riveAnimations = RiveAnimations();
  late AnimationController _controller;
  late Animation<double> _animation;

  final Speech speech = Speech();

  bool close = false;

  @override
  void initState() {
    super.initState();
    initModel();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic, // Use a curved animation
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void initModel() async {
    await speech.initSpeechService(
        modelPath: "assets/models/vosk-model-small-en-in-0.4.zip");
    await speech.commandListenerStart();
  }

  void randomAnimation() {}

  @override
  Widget build(BuildContext context) {
    watchPropertyValue((AppState rv) {
      if (rv.isGiminiAnswering)
        _controller.forward();
      else {
        _controller.reverse();
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () async {
          await speech.commandListenerStart();
        },
        child: Stack(children: [
          Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final curvedOffset = Offset(
                  -MediaQuery.of(context).size.width / 2.5 * _animation.value,
                  -100 * _animation.value,
                );

                return Transform.translate(
                  offset: curvedOffset,
                  child: Transform.scale(
                    scale: 1.2 - _animation.value,
                    child: RiveAnimation.asset(
                      stateMachines: ["shinkuMain"],
                      'assets/modeSelection.riv',
                      onInit: (artboard) {
                        riveAnimations.onRiveInit(artboard);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Visibility(
            visible: watchPropertyValue((AppState rv) => rv.isGiminiAnswering),
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnsBoxGemini(
                  text: watchPropertyValue((AppState rv) => rv.prompt),
                ),
              ),
            ),
          ),
          Visibility(
            visible:
                watchPropertyValue((AppState rv) => rv.currentWeather) != ""
                    ? true
                    : false,
            child: Stack(children: [
              WeatherWidget(
                  weather:
                      watchPropertyValue((AppState rv) => rv.currentWeather))
            ]),
          )
        ]),
      ),
    );
  }
}
