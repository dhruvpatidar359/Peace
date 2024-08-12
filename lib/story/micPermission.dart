import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:peace/home/home.dart';
import 'package:rive/rive.dart' as rive;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:permission_handler/permission_handler.dart';
import '../rive/rive.dart';
import '../speech/speech.dart'; // Assume this is where your Speech class is defined

class MicrophonePermission extends StatefulWidget {
  const MicrophonePermission({Key? key}) : super(key: key);

  @override
  State<MicrophonePermission> createState() => _MicrophonePermissionState();
}

class _MicrophonePermissionState extends State<MicrophonePermission> {
  final RiveAnimations riveAnimations = RiveAnimations();
  final Speech speech = Speech();
  final player = AudioPlayer();
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    player.play(AssetSource("audios/gibberish.mp3"),
        position: Duration(milliseconds: 2200));
    // Any initialization tasks can go here
  }

  @override
  void dispose() {
    speech.dispose();
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
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width / 2,
              child: rive.RiveAnimation.asset(
                'assets/modeSelection.riv',
                stateMachines: ["shinkuMain"],
                onInit: (artboard) {
                  riveAnimations.onRiveInit(artboard);
                },
              ),
            ),
            FuturisticMicBox(
              speech: speech,
              onListeningChanged: (bool listening) {
                setState(() {
                  isListening = listening;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FuturisticMicBox extends StatefulWidget {
  final Speech speech;
  final Function(bool) onListeningChanged;

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
      widget.onListeningChanged(true);
    }
  }

  @override
  void dispose() {
    widget.speech.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height / 1.5,
        width: MediaQuery.of(context).size.width / 4,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.purpleAccent.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: Colors.purpleAccent.withOpacity(0.7),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!hasPermission) ...[
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Courier',
                  color: Colors.white,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'I would like to talk to you, would you please give me permission?',
                      speed: Duration(milliseconds: 80),
                    ),
                  ],
                  isRepeatingAnimation: false,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: requestMicrophonePermission,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  "Give Access to Microphone",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ] else ...[
              Text(
                "Listening...",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              SizedBox(height: 20),
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: Home(), type: PageTransitionType.fade));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.purpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    "Dashboard",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
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
