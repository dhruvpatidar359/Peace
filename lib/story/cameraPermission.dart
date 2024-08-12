import 'package:camera_universal/camera_universal.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audioplayers/audioplayers.dart';

import 'dart:io';

import '../rive/rive.dart';

class CameraPermission extends StatefulWidget {
  const CameraPermission({Key? key}) : super(key: key);

  @override
  State<CameraPermission> createState() => _CameraPermissionState();
}

class _CameraPermissionState extends State<CameraPermission> {
  final RiveAnimations riveAnimations = RiveAnimations();
  final player = AudioPlayer();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  CameraController cameraController = CameraController();
  String? evaluationResult; // Variable to store evaluation result

  @override
  void dispose() {
    player.dispose();
    cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    task();
  }

  Future<void> task() async {
    await cameraController.initializeCameras();

    await cameraController.initializeCamera(
      setState: setState,
    );
    await cameraController.activateCamera(
      setState: setState,
      mounted: () {
        return mounted;
      },
    );
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
            FuturisticBox(
              image: _image,
              cameraController: cameraController,
            ),
          ],
        ),
      ),
    );
  }
}

class FuturisticBox extends StatefulWidget {
  final CameraController cameraController;
  File? image;

  FuturisticBox({this.image, required this.cameraController});

  @override
  State<FuturisticBox> createState() => _FuturisticBoxState();
}

class _FuturisticBoxState extends State<FuturisticBox> {
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
                    'Just show who you are, please select an image',
                    speed: Duration(milliseconds: 80),
                  ),
                ],
                isRepeatingAnimation: false,
              ),
            ),
            SizedBox(height: 20),
            if (widget.image != null)
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    widget.image!,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    int cameraId = widget.cameraController.camera_id;

                    widget.image = File((await widget
                            .cameraController.camera_windows
                            .takePicture(cameraId))
                        .path);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    "Capture your Environment",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            if (widget.image != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Courier',
                    color: Colors.white,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'evaluationResult = Whoooo! Human species (Homo Sapiens) evaluated from Orangutan.',
                        speed: Duration(milliseconds: 80),
                      ),
                    ],
                    isRepeatingAnimation: false,
                  ),
                ),
              ),
            // Display the evaluation result below the capture button
          ],
        ),
      ),
    );
  }
}
