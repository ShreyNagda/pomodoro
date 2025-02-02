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
import 'package:pomodoro/widgets/daily_goal.dart';
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
    return _controller == null
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: LayoutBuilder(builder: (context, constraints) {
              double minDimension =
                  min(constraints.maxWidth, constraints.maxHeight);
              double divisor = isPhone
                  ? 3
                  : minDimension < 300
                      ? 4
                      : 6;
              double radius = minDimension / divisor;
              return OrientationBuilder(builder: (context, orientation) {
                return TimerControllerListener(
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
                        prefs.setInt("dailycomplete",
                            prefs.getInt("dailycomplete")! + 1);
                      }
                      changePomodoro();
                    }
                  },
                  child: TimerControllerBuilder(
                      controller: _controller!,
                      builder: (context, value, child) {
                        return Stack(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: _controller!.value.status !=
                                      TimerStatus.running
                                  ? IconButton(
                                      onPressed: _controller!.value.status ==
                                              TimerStatus.running
                                          ? null
                                          : () {
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
                                                              prefs.getInt(
                                                                  "dailygoal")!;
                                                        })
                                                      });
                                            },
                                      icon: Icon(
                                        Icons.settings_rounded,
                                        color: text,
                                      ),
                                    )
                                  : null,
                            ),
                            Center(
                              child: orientation == Orientation.portrait ||
                                      MediaQuery.of(context).size.height > 300
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomIndicator(
                                          percent:
                                              value.remaining / totalPeriod,
                                          radius: radius,
                                          controller: _controller!,
                                          child: Container(),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        DailyGoal(
                                            dailyGoal: dailyGoal,
                                            dailyComplete:
                                                prefs.getInt("dailycomplete") ??
                                                    8),
                                        const SizedBox(height: 10),
                                        Text(
                                          "${(value.remaining ~/ 60).toString().padLeft(2, "0")} : ${(value.remaining % 60).toString().padLeft(2, "0")}",
                                          style: TextStyle(
                                            fontSize:
                                                radius / (isPhone ? 5 : 2.5),
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2.5,
                                          ),
                                        ),
                                        SizedBox(
                                          height: isPhone ? 10 : 5,
                                        ),
                                        InkWell(
                                          onTap: value.status !=
                                                  TimerStatus.running
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white12,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child: const Icon(Icons
                                                      .unfold_more_rounded),
                                                ),
                                                Text(
                                                  currentPomodoro.name,
                                                  style: TextStyle(
                                                      fontSize: radius /
                                                          (isPhone ? 6 : 3)),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CustomIndicator(
                                              percent:
                                                  value.remaining / totalPeriod,
                                              radius: radius,
                                              controller: _controller!,
                                              child: Container(),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            DailyGoal(
                                                dailyGoal: dailyGoal,
                                                dailyComplete: prefs.getInt(
                                                        "dailycomplete") ??
                                                    8)
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${(value.remaining ~/ 60).toString().padLeft(2, "0")} : ${(value.remaining % 60).toString().padLeft(2, "0")}",
                                              style: TextStyle(
                                                fontSize: radius /
                                                    (isPhone ? 5 : 2.5),
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 2.5,
                                              ),
                                            ),
                                            SizedBox(
                                              height: isPhone ? 10 : 5,
                                            ),
                                            InkWell(
                                              onTap: value.status !=
                                                      TimerStatus.running
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
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white12,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      child: const Icon(Icons
                                                          .unfold_more_rounded),
                                                    ),
                                                    Text(
                                                      currentPomodoro.name,
                                                      style: TextStyle(
                                                          fontSize: radius /
                                                              (isPhone
                                                                  ? 6
                                                                  : 3)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                            ),
                          ],
                        );
                      }),
                );
              });
            }),
          );
  }
}
