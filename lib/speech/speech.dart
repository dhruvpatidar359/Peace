import 'dart:async';
import 'dart:typed_data';

import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:vosk_flutter/vosk_flutter.dart';
import 'package:weather/weather.dart';
import 'package:record/record.dart';

import '../location/geolocator.dart';
import '../models/AppState.dart';
import '../rive/rive.dart';

class Speech {
  static final Speech _singleton = Speech._internal();

  factory Speech() {
    return _singleton;
  }

  Speech._internal();

  final vosk = VoskFlutterPlugin.instance();
  final RiveAnimations riveAnimations = RiveAnimations();
  final AudioRecorder _audioRecorder = AudioRecorder();

  String modelPath = "assets/models/vosk-model-en-in-0.5.zip";

  Model? _model;
  Recognizer? _recognizer;
  StreamSubscription<Uint8List>? _audioSubscription;

  Future<void> initVosk({required String modelPath}) async {
    final enSmallModelPath = await ModelLoader().loadFromAssets(modelPath);
    _model = await vosk.createModel(enSmallModelPath);
    _recognizer = await vosk.createRecognizer(
      model: _model!,
      sampleRate: 16000,
    );
  }

  Future<void> startListening() async {
    if (_recognizer == null) {
      await initVosk(modelPath: modelPath);
    }

    if (await _audioRecorder.hasPermission()) {
      Stream<Uint8List> stream =
          await _audioRecorder.startStream(const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
      ));

      _audioSubscription = stream.listen(
        (Uint8List data) async {
          await processAudio(data);
        },
        onError: (error) {
          print("Audio recording error: $error");
        },
        onDone: () {
          print("Audio recording completed");
        },
      );
    } else {
      print("Microphone permission not granted");
    }
  }

  Future<void> processAudio(Uint8List audioData) async {
    final resultReady = await _recognizer!.acceptWaveformBytes(audioData);
    if (resultReady) {
      final result = await _recognizer!.getResult();
      handleCommandResult(result);
    } else {
      final partialResult = await _recognizer!.getPartialResult();
      print("Partial: $partialResult");
    }
  }

  void handleCommandResult(String result) async {
    print("Full result: $result");
    if (result.contains("listen")) {
      riveAnimations.setAnimationIndex(3);
      GetIt.instance<AppState>().setListeningForAssistant = true;
    } else if (result.contains("weather")) {
      Position position = await determinePosition();
      WeatherFactory wf = WeatherFactory("e0ea4d8d7c2cf8cf263acac053719a6f",
          language: Language.ENGLISH);

      Weather w = await wf.currentWeatherByLocation(
          position.latitude, position.latitude);

      GetIt.instance<AppState>().setCurrentWeather = w.weatherDescription!;
      Timer(
        Duration(seconds: 8),
        () {
          GetIt.instance<AppState>().setCurrentWeather = "";
        },
      );
    } else if (result.contains("close") ||
        result.contains("okay") ||
        result.contains("done")) {
      riveAnimations.setAnimationIndex(4);
      GetIt.instance<AppState>().setGeminiAnswering = false;
      GetIt.instance<AppState>().setPrompt = "";
    } else if (result.contains("clock") || result.contains("study")) {
      // Implement clock or study functionality
    } else if (result.contains("backup") || result.contains("completed")) {
      // Implement backup or completed functionality
    } else if (GetIt.instance<AppState>().listeningForAssistant) {
      // If assistant is listening, send the speech to Gemini
      riveAnimations.setAnimationIndex(4);
      GetIt.instance<AppState>().setGeminiAnswering = true;
      final model = GenerativeModel(
          model: 'gemini-pro',
          apiKey: "AIzaSyB2JUqaldnZ44xfjR6Y2h3SOKv80okJAjo");
      final prompt = result;
      final content = [Content.text(prompt)];

      final response = await model.generateContent(content);

      GetIt.instance<AppState>().setPrompt = response.text!;
      GetIt.instance<AppState>().setListeningForAssistant = false;
    }
  }

  Future<void> stopListening() async {
    await _audioSubscription?.cancel();
    _audioSubscription = null;
    await _audioRecorder.stop();
  }

  void dispose() async {
    await stopListening();
    await _recognizer?.dispose();
    // await _model?.dispose();
    _audioRecorder.dispose();
  }
}
