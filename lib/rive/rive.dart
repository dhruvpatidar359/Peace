import 'package:rive/rive.dart';

class RiveAnimations {
  static final RiveAnimations _singleton = RiveAnimations._internal();

  factory RiveAnimations() {
    return _singleton;
  }

  RiveAnimations._internal();
  SMIInput<double>? _numberExampleInput;

  void Function(Artboard)? onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'shinkuMain');
    artboard.addController(controller!);
    _numberExampleInput = controller.findInput<double>('index') as SMINumber;
  }

  void setAnimationIndex(double index) {
    _numberExampleInput?.value = index;
  }
}
