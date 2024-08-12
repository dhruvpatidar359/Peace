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

  StreamController<List<double>> _audioSamplesController =
      StreamController<List<double>>.broadcast();
  StreamController<String> _recognizedTextController =
      StreamController<String>.broadcast();

  Stream<List<double>> get audioSamplesStream => _audioSamplesController.stream;
  Stream<String> get recognizedTextStream => _recognizedTextController.stream;

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
    // Convert audio data to samples for visualization
    List<double> samples = audioDataToSamples(audioData);
    _audioSamplesController.add(samples);

    final resultReady = await _recognizer!.acceptWaveformBytes(audioData);
    if (resultReady) {
      final result = await _recognizer!.getResult();
      _recognizedTextController.add(result);
      handleCommandResult(result);
    } else {
      final partialResult = await _recognizer!.getPartialResult();
      _recognizedTextController.add(partialResult);
      print("Partial: $partialResult");
    }
  }

  List<double> audioDataToSamples(Uint8List audioData) {
    // Convert the audio data to a list of doubles
    // This is a simplified conversion and may need to be adjusted based on your audio format
    List<double> samples = [];
    for (int i = 0; i < audioData.length; i += 2) {
      if (i + 1 < audioData.length) {
        int sample = audioData[i] | (audioData[i + 1] << 8);
        if (sample > 32767) sample -= 65536;
        samples.add(sample / 32768.0);
      }
    }
    // Downsample to 50 points for visualization
    return downsample(samples, 50);
  }

  List<double> downsample(List<double> samples, int targetLength) {
    if (samples.length <= targetLength) return samples;

    List<double> downsampled = [];
    double ratio = samples.length / targetLength;
    for (int i = 0; i < targetLength; i++) {
      int index = (i * ratio).round();
      downsampled.add(samples[index]);
    }
    return downsampled;
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
