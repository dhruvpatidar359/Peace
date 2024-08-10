import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool _isGiminiAnswering = false;
  String _prompt = "";
  String _currentWeather = "";

  String get prompt => _prompt;
  String get currentWeather => _currentWeather;

  set setCurrentWeather(String value) {
    _currentWeather = value;
    notifyListeners();
  }

  set setPrompt(String value) {
    _prompt = value;
    notifyListeners();
  }

  bool get isGiminiAnswering => _isGiminiAnswering;
  set setGeminiAnswering(bool value) {
    _isGiminiAnswering = value;
    notifyListeners();
  }
}
