import 'package:flutter/material.dart';

enum Animation { Blinking, Happy, Stable }

class RiveModel extends ChangeNotifier {
  Animation _currentAnimation = Animation.Stable;

  Animation get currentAnimation => _currentAnimation;

  set currentAnimation(Animation value) {
    _currentAnimation = value;
    notifyListeners();
  }
}
