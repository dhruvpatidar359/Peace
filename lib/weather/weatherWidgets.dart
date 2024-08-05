import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:weather_animation/weather_animation.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key, required this.weather});

  final weather;
  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.weather == "clear sky") {
      return Stack(children: [
        SunWidget(
          sunConfig: SunConfig(
              width: 360,
              blurSigma: 13,
              blurStyle: BlurStyle.solid,
              isLeftLocation: true,
              coreColor: Color(0xffff9800),
              midColor: Color(0xffffee58),
              outColor: Color(0xffffa726),
              animMidMill: 1500,
              animOutMill: 1500),
        ),
        Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(36.0, 0, 0, 0),
                  child: Text(
                    "Clear Sky",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 42),
                  ),
                ))
            .animate()
            .shimmer(
              color: Colors.orange,
              duration: 4.seconds,
            )
            .fadeIn(),
      ]);
    } else if (widget.weather.contains("clouds")) {
      return Stack(
        children: [
          WindWidget(
            windConfig: WindConfig(
                width: 6,
                y: 300,
                windGap: 14,
                blurSigma: 13,
                color: Color(0xff607d8b),
                slideXStart: 0,
                slideXEnd: 350,
                pauseStartMill: 50,
                pauseEndMill: 6000,
                slideDurMill: 1000,
                blurStyle: BlurStyle.solid),
          ),
          CloudWidget(
            cloudConfig: CloudConfig(
                size: 250,
                color: Color(0xaaffffff),
                icon: IconData(63056, fontFamily: 'MaterialIcons'),
                widgetCloud: null,
                x: 70,
                y: 5,
                scaleBegin: 1,
                scaleEnd: 1.1,
                scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                slideX: 11,
                slideY: 5,
                slideDurMill: 2000,
                slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
          ),
          CloudWidget(
            cloudConfig: CloudConfig(
                size: 250,
                color: Color(0x13ffffff),
                icon: IconData(63056, fontFamily: 'MaterialIcons'),
                widgetCloud: null,
                x: 126,
                y: 5,
                scaleBegin: 1,
                scaleEnd: 1.1,
                scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                slideX: 11,
                slideY: 5,
                slideDurMill: 2000,
                slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
          ),
          CloudWidget(
            cloudConfig: CloudConfig(
                size: 189,
                color: Color(0xaaffffff),
                icon: IconData(63056, fontFamily: 'MaterialIcons'),
                widgetCloud: null,
                x: 19,
                y: 0,
                scaleBegin: 1,
                scaleEnd: 1.1,
                scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                slideX: 11,
                slideY: 5,
                slideDurMill: 2000,
                slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
          ),
          CloudWidget(
            cloudConfig: CloudConfig(
                size: 58,
                color: Color(0xaae1f5fe),
                icon: IconData(63056, fontFamily: 'MaterialIcons'),
                widgetCloud: null,
                x: 70,
                y: 5,
                scaleBegin: 1,
                scaleEnd: 1.1,
                scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                slideX: 11,
                slideY: 5,
                slideDurMill: 2000,
                slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
          ),
          Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(36.0, 0, 0, 0),
                    child: Text(
                      "Clouds",
                      style:
                          GoogleFonts.poppins(color: Colors.blue, fontSize: 42),
                    ),
                  ))
              .animate()
              .shimmer(
                color: Colors.white,
                duration: 4.seconds,
              )
              .fadeIn(),
        ],
      ).animate().slideX(begin: 0, end: 1, duration: Duration(seconds: 8));
    } else if (widget.weather == "shower rain") {
      return Stack(children: [
        RainWidget(
            rainConfig: RainConfig(
                color: Colors.blueAccent,
                areaYStart: 0,
                areaXStart: 0,
                areaXEnd: MediaQuery.sizeOf(context).width)),
        Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(36.0, 0, 0, 0),
                  child: Text(
                    "Shower Rain",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 42),
                  ),
                ))
            .animate()
            .shimmer(
              color: Colors.blue,
              duration: 4.seconds,
            )
            .fadeIn(),
      ]); // Replace with your ShowerRainWidget implementation
    } else if (widget.weather == "rain") {
      return Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: RainWidget(
            rainConfig: RainConfig(
                count: 30,
                lengthDrop: 13,
                widthDrop: 4,
                color: Colors.blue,
                isRoundedEndsDrop: true,
                widgetRainDrop: null,
                fallRangeMinDurMill: 500,
                fallRangeMaxDurMill: 1500,
                areaXStart: 0,
                areaXEnd: MediaQuery.sizeOf(context).width,
                areaYStart: 0,
                areaYEnd: MediaQuery.sizeOf(context).height,
                slideX: 2,
                slideY: 0,
                slideDurMill: 2000,
                slideCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                fallCurve: Cubic(0.55, 0.09, 0.68, 0.53),
                fadeCurve: Cubic(0.95, 0.05, 0.80, 0.04)),
          ),
        ).animate().fadeIn(duration: Duration(seconds: 1)),
        Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 0, 0, 0),
                  child: Text(
                    "Rain",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 42),
                  ),
                ))
            .animate()
            .shimmer(
              color: Colors.lightBlueAccent,
              duration: 4.seconds,
            )
            .fadeIn(),
      ]);
      // Replace with your RainWidget implementation
    } else if (widget.weather == "thunderstorm") {
      return Stack(
        children: [
          Align(
            alignment: Alignment(0, -1),
            child: Container(
              height: 200,
              width: 400,
              child: ThunderWidget(
                thunderConfig: ThunderConfig(
                    thunderWidth: 11,
                    blurSigma: 28,
                    blurStyle: BlurStyle.solid,
                    color: Color(0x99ffee58),
                    flashStartMill: 50,
                    flashEndMill: 300,
                    pauseStartMill: 50,
                    pauseEndMill: 6000,
                    points: [Offset(0, -30)]),
              ),
            ),
          ),
          WindWidget(
            windConfig: WindConfig(
                width: 5,
                y: 10,
                windGap: 10,
                blurSigma: 6,
                color: Color(0xff607d8b),
                slideXStart: 0,
                slideXEnd: 350,
                pauseStartMill: 50,
                pauseEndMill: 6000,
                slideDurMill: 1000,
                blurStyle: BlurStyle.solid),
          ),
          RainWidget(
            rainConfig: RainConfig(
                count: 40,
                lengthDrop: 13,
                widthDrop: 4,
                color: Color(0x9978909c),
                isRoundedEndsDrop: true,
                widgetRainDrop: null,
                fallRangeMinDurMill: 500,
                fallRangeMaxDurMill: 1500,
                areaXStart: 0,
                areaYStart: 0,
                areaXEnd: MediaQuery.sizeOf(context).width,
                areaYEnd: MediaQuery.sizeOf(context).height,
                slideX: 2,
                slideY: 0,
                slideDurMill: 2000,
                slideCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                fallCurve: Cubic(0.55, 0.09, 0.68, 0.53),
                fadeCurve: Cubic(0.95, 0.05, 0.80, 0.04)),
          ),
          WindWidget(
            windConfig: WindConfig(
                width: 7,
                y: 300,
                windGap: 15,
                blurSigma: 7,
                color: Color(0xff607d8b),
                slideXStart: 0,
                slideXEnd: 350,
                pauseStartMill: 50,
                pauseEndMill: 6000,
                slideDurMill: 1000,
                blurStyle: BlurStyle.solid),
          ),
          Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(36.0, 0, 0, 0),
                    child: Text(
                      "Thunderstorm",
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 42),
                    ),
                  ))
              .animate()
              .shimmer(
                color: Colors.yellow,
                duration: 4.seconds,
              )
              .fadeIn(),
        ],
      ).animate().fadeIn(duration: Duration(seconds: 1));
      // Replace with your ThunderstormWidget implementation
    } else if (widget.weather == "snow") {
      return Stack(
        children: [
          SnowWidget(
            snowConfig: SnowConfig(
                count: 50,
                size: 20,
                color: Color(0xb3ffffff),
                icon: IconData(57399, fontFamily: 'MaterialIcons'),
                widgetSnowflake: null,
                areaXStart: 0,
                areaXEnd: MediaQuery.sizeOf(context).width,
                areaYEnd: MediaQuery.sizeOf(context).height,
                waveRangeMin: 20,
                areaYStart: 0,
                waveRangeMax: 70,
                waveMinSec: 5,
                waveMaxSec: 20,
                waveCurve: Cubic(0.45, 0.05, 0.55, 0.95),
                fadeCurve: Cubic(0.60, 0.04, 0.98, 0.34),
                fallMinSec: 10,
                fallMaxSec: 60),
          ),
          Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(36.0, 0, 0, 0),
                    child: Text(
                      "Snow",
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 42),
                    ),
                  ))
              .animate()
              .shimmer(
                color: Colors.lightBlue,
                duration: 4.seconds,
              )
              .fadeIn(),
        ],
      )
          .animate()
          .fadeIn(duration: Duration(seconds: 1))
          .fadeOut(duration: 8.seconds);
      // Replace with your SnowWidget implementation
    } else if (widget.weather == "mist") {
      return Stack(children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color(0xff424242),
              Color(0xffcfd8dc),
            ],
          )),
        ),
        Align(
                alignment: Alignment.center,
                child: Text(
                  "Mist",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 42),
                ))
            .animate()
            .shimmer(
              duration: 4.seconds,
            )
            .fadeIn(),
      ]).animate().fadeOut(duration: 8.seconds);
    }
    return Container();
  }
}
