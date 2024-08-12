import 'package:camera_universal/camera_universal.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:simple_camera_windows/backup/simple_camera_windows.dart';
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

  Future<void> _selectImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
        await player.play(AssetSource("audios/whooo.mp3"));
      }
    } catch (e) {
      print("Failed to pick image: $e");
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    task();
  }

  Future<void> task() async {
    // cameraController.camera_windows.camera(0);
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
      body: Camera(
        cameraController: cameraController,
        onCameraNotInit: (context) {
          return const SizedBox.shrink();
        },
        onCameraNotSelect: (context) {
          return const SizedBox.shrink();
        },
        onCameraNotActive: (context) {
          return const SizedBox.shrink();
        },
        onPlatformNotSupported: (context) {
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class FuturisticBox extends StatelessWidget {
  final VoidCallback onButtonPressed;
  final File? image;

  FuturisticBox({required this.onButtonPressed, this.image});

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
            if (image != null)
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    image!,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    "Select an Image",
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
