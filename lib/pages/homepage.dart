import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/main.dart';
import 'package:pomodoro/pages/custom_indicator.dart';
import 'package:pomodoro/pages/settings.dart';
import 'package:pomodoro/utils/globals.dart';
import 'package:pomodoro/utils/pomodoro.dart';
import 'package:timer_controller/timer_controller.dart';

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

  late int dailyGoal;

  final AudioPlayer webPlayer = AudioPlayer();

  @override
  void initState() {
    getPomodoros();
    setCurrentPomodoro();
    dailyGoal = prefs.getInt("dailygoal")!;
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
        : minDimension > 450
            ? 8
            : 6;
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
                        if (!kIsWeb)
                          IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          const SettingsPage(),
                                    ),
                                  )
                                  .then((_) => {
                                        setState(() {
                                          dailyGoal =
                                              prefs.getInt("dailygoal")!;
                                        })
                                      });
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
                              CustomIndicator(
                                percent: value.remaining / totalPeriod,
                                radius: radius,
                                controller: _controller!,
                                child: Container(),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ...List.generate(dailyGoal, (index) {
                                      return Container(
                                        margin: const EdgeInsets.all(5),
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: index <
                                                  prefs.getInt("dailycomplete")!
                                              ? Colors.white
                                              : Colors.white12,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
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
                                onTap: value.status != TimerStatus.running
                                    ? () => changePomodoro()
                                    : null,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    right: 20,
                                    left: 10,
                                    top: 5,
                                    bottom: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white12,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: const Icon(
                                            Icons.unfold_more_rounded),
                                      ),
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
