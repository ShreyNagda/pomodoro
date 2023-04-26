import 'dart:io';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:circle_list/circle_list.dart';
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
  // static get route => CupertinoPageRoute(builder: (_) => const HomePage());
  const HomePage({super.key});

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    switch (receivedAction.buttonKeyPressed) {
      case 'pause':
        _HomePageState.timerController.pause();
        break;
      case 'resume':
        _HomePageState.timerController.start();
        break;
      case 'start':
        _HomePageState.timerController.start();
        break;
      case 'reset':
        _HomePageState.timerController.reset();
        break;
      case 'close':
        await service.deleteNotification(0);
        break;
    }
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  static late TimerController timerController;

  int count = 0;

  late TimerModel timerModel;
  int selectedIndex = 0;
  int maxvalue = 1;
  int selectedindex = 0;

  int baseMultiplier = 15;
  int spacerMultiplier = 2;

  late double width;
  late double height;
  late double spacer;

  AppLifecycleState? state;

  late PlayerController player;

  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.newPlayer();

  @override
  Future<void> dispose() async {
    print('dispose');
    timerController.dispose();
    // localNotificationsPlugin.cancelAll();
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
  //   // TODO: implement didChangeAppLifecycleState
  //   super.didChangeAppLifecycleState(state);
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       this.state = null;
  //       print('Resume');
  //       break;
  //     case AppLifecycleState.inactive:
  //       this.state = state;
  //       print('Inactive');
  //       break;
  //     case AppLifecycleState.paused:
  //       this.state = state;
  //       print('Paused');
  //       break;
  //     case AppLifecycleState.detached:
  //       print('Detached');
  //       break;
  //   }
  // }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // width = 100.w;
    // spacer = 10.w;
    setTimer();
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      player = Player.asset('assets/audio/bell.mp3');
      player.play();
    }
    super.initState();
  }

  @override
  Future<bool> didPopRoute() async {
    await service.deleteNotification(0);
    print('Closed');
    return super.didPopRoute();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (ResizeUtil().deviceType == DeviceType.Mobile) {
        width = constraints.maxWidth / 3;
        spacer = constraints.maxWidth / 50;
      } else if (ResizeUtil().deviceType == DeviceType.Windows ||
          ResizeUtil().deviceType == DeviceType.Linux) {
        if (constraints.maxWidth > constraints.maxHeight) {
          // print('height:${constraints.maxHeight}');
          width = constraints.maxHeight / 4;
          spacer = constraints.maxHeight / 100;
        } else {
          // print('width:${constraints.maxWidth}');
          width = constraints.maxWidth / 4;
          spacer = constraints.maxWidth / 100;
        }
        // print('width: $width');
        // print('spacer: $spacer');
      }
      // return CustomTimer(timerController: timerController);
      return TimerControllerListener(
          controller: timerController,
          listener: (context, value) async {
            // print('Listening..');
            if (Platform.isAndroid) {
              service.createNotification(timerModel, timerController);
            }
            if (state == AppLifecycleState.paused) {
              service.deleteNotification(0);
              // state = null;
            }

            if (value.status == TimerStatus.finished) {
              if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
                player.play();
                // print(player.media);
              } else {
                AssetsAudioPlayer.playAndForget(
                    Audio('assets/audios/bell.mp3'));
              }
              changeTimerMode();
              if (prefs.getBool(Constants.autoStartBreakKey)! &&
                  selectedindex != 0) {
                timerController.start();
              }
              if (prefs.getBool(Constants.autoStartPomodoroKey)! &&
                  selectedindex == 0) {
                timerController.start();
              }
            }
          },
          child: TimerControllerBuilder(
              controller: timerController,
              builder: (context, value, child) {
                return Scaffold(
                  appBar: AppBar(
                    // backgroundColor: Colors.white,
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
                            icon: const Icon(Icons.list)),
                      ),
                    ],
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleList(
                              rotateMode: RotateMode.stopRotate,
                              initialAngle: (pi / 180) * 270,
                              origin: const Offset(0, 0),
                              outerRadius: width + spacer * 5,
                              innerRadius: width + spacer * 2,
                              children: List.generate(
                                timerModel.minutes,
                                (index) => Transform.rotate(
                                  angle:
                                      radians(360 / timerModel.minutes * index)
                                          .toDouble(),
                                  child: Container(
                                    height: width / 12.5,
                                    width: width / 25,
                                    decoration: BoxDecoration(
                                      color:
                                          (value.remaining / 60).ceil() > index
                                              ? Colors.white
                                              : Colors.white24,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: (width + spacer * 1.5) * 2,
                              height: (width + spacer * 1.5) * 2,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.fromBorderSide(
                                  BorderSide(
                                    width: ResizeUtil().deviceType ==
                                            DeviceType.Mobile
                                        ? 0.7.mv
                                        : 0.4.mv,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    if (value.status == TimerStatus.running) {
                                      timerController.pause();
                                    } else {
                                      timerController.start();
                                    }
                                  },
                                  onLongPress: () {
                                    timerController.reset();
                                  },
                                  child: CircularPercentIndicator(
                                      backgroundWidth: width,
                                      animation: true,
                                      animateFromLastPercent: true,
                                      animationDuration: 800,
                                      radius: width,
                                      lineWidth: width,
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
                                          ? const SizedBox.shrink()
                                          : Center(
                                              child: value.status ==
                                                      TimerStatus.paused
                                                  ? Icon(
                                                      Icons.pause_rounded,
                                                      size: 5.rem,
                                                    )
                                                  : IconButton(
                                                      iconSize: 5.rem,
                                                      onPressed: () {
                                                        timerController.start();
                                                      },
                                                      icon: const Icon(
                                                        Icons
                                                            .play_arrow_rounded,
                                                      ),
                                                    ),
                                            )),
                                ),
                              ),
                            ),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(fontSize: spacer * 3),
                                    ),
                                    Text(
                                      formatString(value.remaining),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(fontSize: spacer * 4),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 1.mv,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }));
    });
  }

  void changeTimerMode() {
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

  setBreakKey() {
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
