import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/main.dart';
import 'package:pomodoro/pages/settings.dart';
import 'package:pomodoro/utils/globals.dart';
import 'package:pomodoro/utils/pomodoro.dart';
import 'package:timer_controller/timer_controller.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TimerController? _controller;
  bool isShortBreak = true;
  int index = 0;
  late Pomodoro currentPomodoro;
  late int totalPeriod;

  final AudioPlayer webPlayer = AudioPlayer();
  final AssetsAudioPlayer player = AssetsAudioPlayer.newPlayer();

  @override
  void initState() {
    getPomodoros();
    setCurrentPomodoro();
    super.initState();
  }

  void setCurrentPomodoro() {
    currentPomodoro = pomodoros[index];
    totalPeriod = currentPomodoro.period * 60;
    _controller = TimerController.seconds(totalPeriod);
  }

  void changePomodoro() {
    setState(() {
      switch (index) {
        case 0:
          if (isShortBreak) {
            index = 1;
          } else {
            index = 2;
          }
          isShortBreak = !isShortBreak;
          break;
        case 1 || 2:
          index = 0;
          break;
      }
      setCurrentPomodoro();
    });
  }

  @override
  Widget build(BuildContext context) {
    double minDimension = min(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    double divisor = isPhone
        ? 3
        : minDimension > 500
            ? 8
            : 5;
    double radius = minDimension / divisor;
    return _controller == null
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : TimerControllerListener(
            controller: _controller!,
            listener: (context, value) async {
              if (value.status == TimerStatus.finished) {
                if (kIsWeb == true) {
                  await webPlayer.play(
                      AssetSource("../../assets/audio/bell.mp3"),
                      mode: PlayerMode.lowLatency);
                } else {
                  await webPlayer.play(AssetSource('audio/bell.mp3'));
                }
                if (index == 0) {
                  prefs.setInt(
                      "dailycomplete", prefs.getInt("dailycomplete")! + 1);
                }
                print(prefs.getInt("dailycomplete"));
                changePomodoro();
              }
            },
            child: TimerControllerBuilder(
                controller: _controller!,
                builder: (context, value, child) {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => const SettingsPage(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.settings_rounded,
                            color: text,
                          ),
                        )
                      ],
                    ),
                    body: Center(
                      child: SingleChildScrollView(
                        child: SizedBox(
                          // width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: radius * 2.3,
                                height: radius * 2.3,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(radius * 2),
                                  border: Border.fromBorderSide(
                                    BorderSide(
                                      color: text,
                                      width: radius / 20,
                                    ),
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    if (value.status == TimerStatus.initial ||
                                        value.status == TimerStatus.paused) {
                                      _controller!.start();
                                    } else if (value.status ==
                                        TimerStatus.running) {
                                      _controller!.pause();
                                    } else {
                                      _controller!.start();
                                    }
                                  },
                                  onLongPress: () {
                                    if (value.status == TimerStatus.paused ||
                                        value.status == TimerStatus.finished) {
                                      _controller!.reset();
                                    }
                                  },
                                  child: CircularPercentIndicator(
                                    percent: value.status == TimerStatus.initial
                                        ? totalPeriod / totalPeriod
                                        : value.remaining / totalPeriod,
                                    radius: radius,
                                    lineWidth: radius,
                                    progressColor: value.status ==
                                            TimerStatus.initial
                                        ? Colors.transparent
                                        : value.status == TimerStatus.running
                                            ? text
                                            : text.withAlpha(150),
                                    backgroundColor: Colors.transparent,
                                    animateFromLastPercent: true,
                                    animation: true,
                                    animationDuration: 600,
                                    center: value.status == TimerStatus.running
                                        ? null
                                        : Icon(
                                            Icons.play_arrow_rounded,
                                            size: radius,
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ...List.generate(prefs.getInt("dailygoal")!,
                                      (index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: index <
                                                prefs.getInt("dailycomplete")!
                                            ? Colors.white
                                            : Colors.white12,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${(value.remaining ~/ 60).toString().padLeft(2, "0")} : ${(value.remaining % 60).toString().padLeft(2, "0")}",
                                style: TextStyle(
                                  fontSize: radius / (isPhone ? 5 : 2.5),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.5,
                                ),
                              ),
                              SizedBox(
                                height: isPhone ? 10 : 5,
                              ),
                              InkWell(
                                onTap: () {
                                  if (value.status != TimerStatus.running) {
                                    //change pomodoro when timer not running
                                    changePomodoro();
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.unfold_more_rounded),
                                      Text(
                                        currentPomodoro.name,
                                        style: TextStyle(
                                            fontSize:
                                                radius / (isPhone ? 6 : 3)),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
  }
}
