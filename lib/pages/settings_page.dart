import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/pages/on_boarding.dart';
import 'package:pomodoro/widgets/color_grid.dart';
import 'package:pomodoro/widgets/number_set.dart';
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

  // late bool isMobile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (isMobile) {
        width = 500.w;
        spacer = 10.w;
      } else if (isWindows) {
        width = constraints.maxWidth < constraints.maxHeight ? constraints.maxWidth : (80 / 100) * constraints.maxWidth;
        spacer = width / 30;
      } else if (isTablet) {
        width = constraints.maxHeight > constraints.maxWidth
            ? constraints.maxWidth
            : constraints.maxHeight;
        spacer = width / 100;
      } else if (isWeb) {
        // print(constraints);
        width = constraints.maxHeight > constraints.maxWidth
            ? constraints.maxWidth
            : constraints.maxHeight;
        spacer = width / 15;
        if (constraints.maxHeight < constraints.maxWidth &&
            constraints.maxHeight < 300) {
          width = constraints.maxWidth;
          spacer = width / 100;
        }
      }
      return Scaffold(
          // backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_rounded),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DurationDisplay(
                      width: width,
                    ),
                    SizedBox(height: spacer),
                    ColorGrid(width: width),
                    SizedBox(
                      height: spacer,
                    ),
                    SizedBox(
                      width: width,
                      child: Row(
                        children: [
                          Expanded(
                            child: NumberSetter(
                              prefsKey: Constants.dailyGoalKey,
                              label: 'Daily Goal',
                            ),
                          ),
                          Expanded(
                            child: NumberSetter(
                              prefsKey: Constants.numberOfBreaksKey,
                              label: 'Pomodoros until Long Break',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: spacer,
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
                      height: spacer,
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
                      height: spacer,
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
                    ),
                    SizedBox(
                      height: spacer,
                    ),
                    Container(
                      width: width,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => const OnBoardingScreen(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: isMobile ? 3.rem : 5.mv,
                                  height: isMobile ? 3.rem : 5.mv,
                                  // padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white12,
                                  ),
                                  child: Icon(
                                    Icons.question_mark,
                                    size: isMobile ? 2.rem : 2.mv,
                                  ),
                                ),
                                SizedBox(
                                  height: spacer,
                                ),
                                Text(
                                  'How to Use?',
                                  style: isMobile
                                      ? Theme.of(context).textTheme.bodyMedium
                                      : isTablet
                                          ? Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
    });
  }
}
