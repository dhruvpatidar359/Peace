import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:vosk_flutter/vosk_flutter.dart';
import 'package:weather/weather.dart';

import '../location/geolocator.dart';

import '../models/AppState.dart';
import '../rive/rive.dart';

// code for the command up listener(vosk)
// code for the gemini listener

class Speech {
  static final Speech _singleton = Speech._internal();

  factory Speech() {
    return _singleton;
  }

  Speech._internal();

  final vosk = VoskFlutterPlugin.instance();
  final RiveAnimations riveAnimations = RiveAnimations();
  stt.SpeechToText speech = stt.SpeechToText();

  String modelPath = "assets/models/vosk-model-small-en-in-0.4.zip";

  SpeechService? _speechService;

  Future<void> initSpeechService({required String modelPath}) async {
    final enSmallModelPath = await ModelLoader().loadFromAssets(modelPath);
    final model = await vosk.createModel(enSmallModelPath);
    final recognizer = await vosk.createRecognizer(
      model: model,
      sampleRate: 16000,
    );
    _speechService = await vosk.initSpeechService(recognizer);
  }

  Future<void> commandListenerStart() async {
    if (_speechService == null) {
      await initSpeechService(modelPath: modelPath);
    }

    _speechService?.onResult().forEach((result) async {
      print(result);
      if (result.contains("listen")) {
        riveAnimations.setAnimationIndex(3);
        await _speechService?.stop();

        await assistantListenerStart();
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
      } else if (result.contains("backup") || result.contains("completed")) {}
    });
    await _speechService?.start();
  }

  Future<void> stopCommandListener() async {
    _speechService?.stop();
  }

  Future<void> assistantListenerStart() async {
    bool available = await speech.initialize(
      onError: (errorNotification) {
        print(errorNotification.errorMsg);
      },
    );
    if (available) {
      speech.listen(
        listenOptions: stt.SpeechListenOptions(partialResults: false),
        onResult: (result) async {
          GetIt.instance<AppState>().setGeminiAnswering = true;
          riveAnimations.setAnimationIndex(4);
          final model = GenerativeModel(
              model: 'gemini-pro',
              apiKey: "AIzaSyB2JUqaldnZ44xfjR6Y2h3SOKv80okJAjo");
          final prompt = result.recognizedWords;
          final content = [Content.text(prompt)];

          final response = await model.generateContent(content);

          GetIt.instance<AppState>().setPrompt = response.text!;

          await _speechService?.start();
        },
      );
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }
}
