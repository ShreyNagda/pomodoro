import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/widgets/color_grid.dart';
import 'package:pomodoro/widgets/radio_button.dart';
// import 'package:pomodoro/widgets/duration_display.dart';
import 'package:resize/resize.dart';
import 'package:wakelock/wakelock.dart';

import '../main.dart';
import '../utils/constants.dart';
import '../widgets/duration/duration.dart';

class SettingsPage extends StatefulWidget {
  static get route => CupertinoPageRoute(builder: (_) => const SettingsPage());
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late double width;
  late double spacer;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        if (ResizeUtil().deviceType == DeviceType.Mobile) {
          width = constraints.maxWidth;
          spacer = constraints.maxWidth / 50;
        } else if (ResizeUtil().deviceType == DeviceType.Windows ||
            ResizeUtil().deviceType == DeviceType.Linux) {
          if (constraints.maxWidth > constraints.maxHeight) {
            width = constraints.maxHeight / 1.5;
            spacer = constraints.maxHeight / 100;
          } else {
            width = constraints.maxWidth / 1.5;
            spacer = constraints.maxWidth / 100;
          }
        }
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                      iconSize: 1.rem,
                    ),
                  ),
                  DurationDisplay(width: width),
                  SizedBox(
                    height: width / 50,
                  ),
                  ColorGrid(width: width),
                  SizedBox(
                    height: width / 50,
                  ),
                  RadioButton(
                    label: 'Autostart Breaks',
                    width: width,
                    prefsKey: Constants.autoStartBreakKey,
                    onChanged: () {
                      print(prefs.getBool(Constants.autoStartBreakKey));
                    },
                  ),
                  SizedBox(
                    height: width / 50,
                  ),
                  RadioButton(
                    label: 'Autostart Pomodoros',
                    width: width,
                    prefsKey: Constants.autoStartPomodoroKey,
                    onChanged: () {
                      // print(prefs.getBool(Constants.autoStartPomodoroKey));
                    },
                  ),
                  SizedBox(
                    height: width / 50,
                  ),
                  RadioButton(
                    label: 'Keep device awake',
                    width: width,
                    prefsKey: Constants.autoStartBreakKey,
                    onChanged: () async {
                      if (prefs.getBool(Constants.wakeLockKey)!) {
                        await Wakelock.enable();
                      } else {
                        await Wakelock.disable();
                      }
                      print(Wakelock.enabled);
                    },
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
