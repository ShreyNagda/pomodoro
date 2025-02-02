import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/main.dart';
import 'package:pomodoro/pages/custom_indicator.dart';
import 'package:pomodoro/pages/settings.dart';
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
          index = isShortBreak ? 1 : 2;
          isShortBreak = !isShortBreak;
          break;
        default:
          index = 0;
          break;
      }
      setCurrentPomodoro();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller == null
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : SafeArea(
            child: Scaffold(
              body: OrientationBuilder(builder: (context, orientation) {
                var size = MediaQuery.of(context).size;
                double minDimension = min(size.width, size.height);
                double radius = min(100, minDimension / (isPhone ? 3 : 6));

                return TimerControllerListener(
                  controller: _controller!,
                  listener: (context, value) async {
                    if (value.status == TimerStatus.finished) {
                      await webPlayer.play(AssetSource(kIsWeb
                          ? "../../assets/audio/bell.mp3"
                          : "audio/bell.mp3"));
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
                        Widget timerWidget = Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIndicator(
                              percent: value.remaining / totalPeriod,
                              radius: radius,
                              controller: _controller!,
                              child: Container(),
                            ),
                            const SizedBox(height: 20),
                            DailyGoal(
                                dailyGoal: dailyGoal,
                                dailyComplete:
                                    prefs.getInt("dailycomplete") ?? 8),
                            const SizedBox(height: 10),
                          ],
                        );
                        Widget timerWidget2 = Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${(value.remaining ~/ 60).toString().padLeft(2, "0")} : ${(value.remaining % 60).toString().padLeft(2, "0")} ",
                              style: TextStyle(
                                  fontSize: radius / (isPhone ? 5 : 2.5),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.5),
                            ),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: value.status != TimerStatus.running
                                  ? () => changePomodoro()
                                  : null,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white12,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.unfold_more_rounded),
                                    const SizedBox(width: 10),
                                    Text(currentPomodoro.name,
                                        style: TextStyle(
                                            fontSize:
                                                radius / (isPhone ? 6 : 3))),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                        return Stack(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: _controller!.value.status !=
                                      TimerStatus.running
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: IconButton(
                                        onPressed: () => Navigator.of(context)
                                            .push(CupertinoPageRoute(
                                                builder: (context) =>
                                                    const SettingsPage()))
                                            .then((_) => setState(() =>
                                                dailyGoal = prefs
                                                    .getInt("dailygoal")!)),
                                        icon:
                                            const Icon(Icons.settings_rounded),
                                      ),
                                    )
                                  : null,
                            ),
                            Center(
                              child: orientation == Orientation.portrait ||
                                      (!isPhone && size.height > 300)
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [timerWidget, timerWidget2],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [timerWidget, timerWidget2],
                                    ),
                            ),
                          ],
                        );
                      }),
                );
              }),
            ),
          );
  }
}
