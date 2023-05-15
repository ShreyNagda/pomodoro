import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:circle_list/circle_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kplayer/kplayer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pomodoro/model/timer_model.dart';
import 'package:pomodoro/pages/settings_page.dart';
import 'package:resize/resize.dart';
import 'package:timer_controller/timer_controller.dart';

import '../main.dart';
import '../utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    switch (receivedAction.buttonKeyPressed) {
      case 'start':
        _HomePageState.timerController.start();
        break;
    }
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static late TimerController timerController;

  int count = 0;

  late TimerModel timerModel;

  // int selectedIndex = 0;
  int maxvalue = 1;
  int selectedindex = 0;

  late double width;
  late double height;
  late double spacer;

  late PlayerController player;

  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.newPlayer();

  @override
  void initState() {
    setTimer();
    prefs.setBool(Constants.firstTimeOpen, false);
    if (!kIsWeb && !isMobile) {
      player = Player.asset(
        "assets/audio/bell.mp3",
        autoPlay: false,
      );
    }
    super.initState();
  }

  @override
  Future<void> dispose() async {
    timerController.dispose();
    // updateAppWidget();
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
      player.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (isMobile) {
        width = 100.w;
        spacer = 7.w;
      } else if (isWindows) {
        width = constraints.maxHeight > constraints.maxWidth
            ? constraints.maxWidth / 5
            : constraints.maxHeight / 5;
        spacer = width / 20;
      } else if (isTablet) {
        width = constraints.maxHeight > constraints.maxWidth
            ? constraints.maxWidth / 4
            : constraints.maxHeight / 4;
        spacer = width / 20;
      } else if (isWeb) {
        // print(constraints);
        width = constraints.maxHeight > constraints.maxWidth
            ? constraints.maxWidth / 4
            : constraints.maxHeight / 4;
        spacer = width / 20;
      }
      return Center(
        child: TimerControllerListener(
            controller: timerController,
            listener: (context, value) async {
              if (value.status == TimerStatus.finished) {
                if (kIsWeb) {
                  await AssetsAudioPlayer.newPlayer().open(
                    Audio('assets/audio/bell.mp3'),
                    autoStart: true,
                    loopMode: LoopMode.none,
                  );
                } else if (Platform.isWindows ||
                    Platform.isLinux ||
                    Platform.isMacOS) {
                  player.play();
                } else {
                  await AssetsAudioPlayer.newPlayer().open(
                    Audio('assets/audio/bell.mp3'),
                    autoStart: true,
                    loopMode: LoopMode.none,
                  );
                }
                changeTimerAfterFinish();
                if (prefs.getInt(Constants.pomodoroCompletedKey)! <
                    prefs.getInt(Constants.dailyGoalKey)!) {
                  if (prefs.getBool(Constants.autoStartBreakKey)! &&
                      selectedindex != 0) {
                    timerController.start();
                  } else if (prefs.getBool(Constants.autoStartPomodoroKey)! &&
                      selectedindex == 0) {
                    timerController.start();
                  } else {
                    service.createNotification(timerModel, timerController);
                  }
                } else {
                  if (isMobile) {
                    service.notifications.createNotification(
                      content: NotificationContent(
                        id: 1,
                        channelKey: 'pomodoro',
                        title: 'Daily Goal achieved :) ',
                      ),
                    );
                    if (prefs.getBool(Constants.autoStartBreakKey)! &&
                        selectedindex != 0) {
                      timerController.start();
                    } else if (prefs.getBool(Constants.autoStartPomodoroKey)! &&
                        selectedindex == 0) {
                      timerController.start();
                    }
                  }
                  // selectedindex = 0;
                  // setTimer();
                }
              }
            },
            child: TimerControllerBuilder(
                controller: timerController,
                builder: (context, value, child) {
                  // print(width);
                  return Scaffold(
                    // backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      // title: ,
                      leading: const SizedBox.shrink(),
                      actions: [
                        Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: value.status != TimerStatus.running &&
                              value.status != TimerStatus.paused,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(context, SettingsPage.route)
                                  .then((value) {
                                if (timerController.value.status !=
                                    TimerStatus.running) {
                                  setTimer();
                                }
                              });
                            },
                            icon: const Icon(Icons.list),
                          ),
                        ),
                      ],
                    ),
                    body: Center(
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          scrollbars: false,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircleList(
                                    rotateMode: RotateMode.stopRotate,
                                    initialAngle: (pi / 180) * 270,
                                    origin: const Offset(0, 0),
                                    // outerCircleColor: Colors.black,
                                    outerRadius: (width + spacer * 5),
                                    innerRadius: (width + spacer * 2),
                                    children: List.generate(
                                      timerModel.minutes,
                                      (index) => Transform.rotate(
                                        angle: radians(360 /
                                                timerModel.minutes *
                                                index)
                                            .toDouble(),
                                        child: Container(
                                          height: 1.5.mv,
                                          width: 0.5.mv,
                                          decoration: BoxDecoration(
                                            color:
                                                (value.remaining / 60).ceil() >
                                                        index
                                                    ? Colors.white
                                                    : Colors.white24,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: (width + spacer) * 2,
                                    height: (width + spacer) * 2,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.fromBorderSide(
                                        BorderSide(
                                          width: ResizeUtil().deviceType ==
                                                  DeviceType.Mobile
                                              ? 4.w
                                              : 5,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (value.status ==
                                            TimerStatus.running) {
                                          timerController.pause();
                                        } else {
                                          timerController.start();
                                        }
                                        service.deleteNotification(0);
                                      },
                                      onLongPress: () {
                                        timerController.reset();
                                        service.createNotification(
                                            timerModel, timerController);
                                      },
                                      child: CircularPercentIndicator(
                                        backgroundWidth: -1,
                                        // arcBackgroundColor: ,
                                        animation: true,
                                        animateFromLastPercent: true,
                                        animationDuration: 800,
                                        radius: width - spacer,
                                        lineWidth: width - spacer,
                                        progressColor:
                                            value.status == TimerStatus.paused
                                                ? Colors.white24
                                                : Colors.white,
                                        percent:
                                            value.status == TimerStatus.initial
                                                ? 0
                                                : value.remaining / maxvalue,
                                        backgroundColor: Colors.transparent,
                                        center: value.status ==
                                                TimerStatus.running
                                            ? const SizedBox()
                                            : value.status == TimerStatus.paused
                                                ? const Icon(
                                                    Icons.pause_rounded,
                                                  )
                                                : IconButton(
                                                    iconSize: 2.rem,
                                                    onPressed: () {
                                                      timerController.start();
                                                    },
                                                    icon: const Icon(
                                                      Icons.play_arrow_rounded,
                                                    ),
                                                  ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Wrap(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ...List.generate(
                                    prefs.getInt(Constants.dailyGoalKey) ?? 4,
                                    (index) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        // padding: const EdgeInsets.all(10),
                                        width: isMobile ? 4.sp : 2.sp,
                                        height: isMobile ? 4.sp : 2.sp,
                                        margin: EdgeInsets.fromLTRB(
                                            index % 4 == 0 ? 2.mv : 0, 0, 0, 0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (index + 1) >
                                                  (prefs.getInt(Constants
                                                          .pomodoroCompletedKey) ??
                                                      -1)
                                              ? Colors.white12
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  prefs.getInt(
                                              Constants.pomodoroCompletedKey)! >
                                          prefs.getInt(Constants.dailyGoalKey)!
                                      ? Text(
                                          '+${prefs.getInt(Constants.pomodoroCompletedKey)! - prefs.getInt(Constants.dailyGoalKey)!}',
                                          textScaleFactor: 0.7,
                                          style: isMobile
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!.copyWith()
                                              : isTablet
                                                  ? Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                  : Theme.of(context)
                                                      .textTheme
                                                      .labelLarge,
                                        )
                                      : const SizedBox.shrink()
                                ],
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () {
                                  if (value.status != TimerStatus.running) {
                                    changeTimerMode();
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  // decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.unfold_more_rounded),
                                      Column(
                                        children: [
                                          Text(
                                            timerModel.name,
                                            style: isMobile
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                : isTablet
                                                    ? Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                          ),
                                          Text(
                                            formatString(value.remaining),
                                            style: isMobile
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                : isTablet
                                                    ? Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })),
      );
    });
  }

  void changeTimerAfterFinish() {
    int pomodorosCompleted = prefs.getInt(Constants.pomodoroCompletedKey) ?? 0;

    switch (selectedindex) {
      case 0:
        pomodorosCompleted++;
        prefs.setInt(Constants.pomodoroCompletedKey, pomodorosCompleted);
        if (pomodorosCompleted != 0 &&
            (pomodorosCompleted % prefs.getInt(Constants.numberOfBreaksKey)! ==
                0)) {
          print('long break');
          selectedindex = 2;
        } else {
          print('short break');
          selectedindex = 1;
        }
        // if (pomodorosCompleted >= prefs.getInt(Constants.dailyGoalKey)!) {
        //   prefs.setInt(Constants.pomodoroCompletedKey, 0);
        // }
        break;
      case 1:
        selectedindex = 0;
        break;
      case 2:
        selectedindex = 0;
        break;
    }
    setTimer();
  }

  void changeTimerMode() {
    // prefs.setInt(Constants.pomodoroCompletedKey,
    //     prefs.getInt(Constants.pomodoroCompletedKey)! + 1);
    // if(selectedIndex == 0){
    //   if(prefs.getInt(Constants.pomodoroCompletedKey)! % 4 == 0){
    //     selectedIndex = 2;
    //   }else{
    //     selectedIndex = 1;
    //   }
    // }else{
    // }
    switch (selectedindex) {
      case 0:
        selectedindex = prefs.getInt(Constants.breakKey)!;
        setBreakKey();
        break;
      case 1:
        selectedindex = 0;
        break;
      case 2:
        selectedindex = 0;
        break;
    }
    setTimer();
  }

  void setBreakKey() {
    if (prefs.getInt(Constants.breakKey) == 1) {
      prefs.setInt(Constants.breakKey, 2);
    } else if (prefs.getInt(Constants.breakKey) == 2) {
      prefs.setInt(Constants.breakKey, 1);
    }
  }

  void setTimer() {
    setState(() {
      timerModel = timers[selectedindex];
      timerController = TimerController.seconds(timerModel.minutes * 60);
      maxvalue = timerModel.minutes * 60;
    });
  }

  String formatString(int remaining) {
    return '${(remaining / 60).floor().toString().padLeft(2, "0")} : ${(remaining % 60).toString().padLeft(2, "0")}';
  }
}
