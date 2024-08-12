import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:peace/models/RiveModel.dart';
import 'package:peace/story/booting.dart';
import 'package:peace/story/cameraPermission.dart';
import 'package:peace/story/intro.dart';
import 'package:peace/story/micPermission.dart';

import 'package:peace/weather/weatherWidgets.dart';
import 'package:weather_animation/weather_animation.dart';

import 'home/home.dart';
import 'models/AppState.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AppState>(AppState());
  getIt.registerSingleton<RiveModel>(RiveModel());
  Animate.restartOnHotReload = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'flexible',
      theme: ThemeData(fontFamily: 'Voyager'),
      home: BootScreen(),
    );
  }
}
