import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/main.dart';
import 'package:pomodoro/pages/onboarding.dart';
import 'package:pomodoro/utils/pomodoro.dart';
import 'package:pomodoro/widgets/iconbutton.dart';
import 'package:pomodoro/widgets/settings_dialog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late List<Pomodoro> pomodoros;
  late int dailyGoal;
  @override
  void initState() {
    getPomodoros();
    dailyGoal = prefs.getInt("dailygoal")!;
    super.initState();
  }

  void getPomodoros() {
    setState(() {
      pomodoros = prefs
          .getStringList("pomodoros")!
          .map((p) => Pomodoro.fromJson(p))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            // color: text,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            // color: Colors.amber,
            width: min(400, MediaQuery.of(context).size.width),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ...pomodoros.map(
                          (p) => InkWell(
                            onTap: () {
                              showSettingDialog(p);
                            },
                            child: Card(
                              // color: Colors.white38,
                              child: Container(
                                height: 100,
                                width: 100,
                                padding: const EdgeInsets.all(10),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        p.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Text(
                                        '${p.period}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Daily Pomdoro Goal",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconButton(
                              callback: () async {
                                setState(() {
                                  if (dailyGoal > 1) dailyGoal--;
                                });
                                await prefs.setInt("dailygoal", dailyGoal);
                              },
                              iconData: Icons.remove_rounded,
                              isDisabled: dailyGoal <= 1,
                              iconSize: 40,
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              padding: const EdgeInsets.all(10),
                              child: Card(
                                child: Center(
                                  child: Text(
                                    '$dailyGoal',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  ),
                                ),
                              ),
                            ),
                            CustomIconButton(
                              callback: () async {
                                setState(() => dailyGoal++);
                                await prefs.setInt("dailygoal", dailyGoal);
                              },
                              iconData: Icons.add_rounded,
                              isDisabled: dailyGoal <= 1,
                              iconSize: 40,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => const OnBoarding()));
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "How to Use?",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showSettingDialog(Pomodoro pomodoro) {
    showDialog(
        context: context,
        builder: (context) {
          return SettingsDialog(pomodoro: pomodoro);
        }).then((_) async {
      getPomodoros();
    });
  }
}
