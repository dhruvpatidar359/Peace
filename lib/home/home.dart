import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:peace/gemini/ansBox.dart';
import 'package:peace/rive/rive.dart';
import 'package:peace/speech/speech.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rive/rive.dart';
import 'package:watch_it/watch_it.dart';
import 'package:weather_animation/weather_animation.dart';

import '../models/AppState.dart';
import '../weather/weatherWidgets.dart';

class Home extends WatchingStatefulWidget {
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
    await speech.initVosk(
        modelPath: "assets/models/vosk-model-small-en-in-0.4.zip");
    // await speech.startListening();
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
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: FuturisticMicBox(
              speech: speech,
              onListeningChanged: true,
            ),
          ),
          Expanded(
            child: Stack(children: [
              Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    final curvedOffset = Offset(
                      -MediaQuery.of(context).size.width /
                          2.5 *
                          _animation.value,
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
                visible:
                    watchPropertyValue((AppState rv) => rv.isGiminiAnswering),
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
                      weather: watchPropertyValue(
                          (AppState rv) => rv.currentWeather))
                ]),
              )
            ]),
          ),
        ],
      ),
    );
  }
}

class FuturisticMicBox extends StatefulWidget {
  final Speech speech;
  final bool onListeningChanged;

  FuturisticMicBox({required this.speech, required this.onListeningChanged});

  @override
  State<FuturisticMicBox> createState() => _FuturisticMicBoxState();
}

class _FuturisticMicBoxState extends State<FuturisticMicBox> {
  bool hasPermission = false;
  List<double> audioSamples = List.filled(50, 0.0);
  String recognizedText = '';

  @override
  void initState() {
    super.initState();
    widget.speech.audioSamplesStream.listen((samples) {
      setState(() {
        audioSamples = samples;
      });
    });
    widget.speech.recognizedTextStream.listen((text) {
      setState(() {
        recognizedText = text;
      });
    });
  }

  Future<void> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    setState(() {
      hasPermission = status.isGranted;
    });
    if (hasPermission) {
      widget.speech.startListening();
      // widget.onListeningChanged(true);
    }
  }

  @override
  void dispose() {
    widget.speech.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            child: AudioVisualizer(audioSamples: audioSamples),
          ),
          SizedBox(height: 20),
          Text(
            textAlign: TextAlign.center,
            recognizedText,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class AudioVisualizer extends StatefulWidget {
  final List<double> audioSamples;

  AudioVisualizer({required this.audioSamples});

  @override
  _AudioVisualizerState createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: AudioVisualizerPainter(widget.audioSamples),
          size: Size(double.infinity, 100),
        );
      },
    );
  }
}

class AudioVisualizerPainter extends CustomPainter {
  final List<double> audioSamples;

  AudioVisualizerPainter(this.audioSamples);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purpleAccent
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final barWidth = size.width / audioSamples.length;
    final maxHeight = size.height;

    for (int i = 0; i < audioSamples.length; i++) {
      final barHeight = audioSamples[i].abs() * maxHeight;
      final startPoint = Offset(i * barWidth, size.height);
      final endPoint = Offset(i * barWidth, size.height - barHeight);
      canvas.drawLine(startPoint, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
