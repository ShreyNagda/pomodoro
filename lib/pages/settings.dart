import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pomodoro/main.dart';
import 'package:pomodoro/pages/onboarding.dart';
import 'package:pomodoro/utils/pomodoro.dart';
import 'package:pomodoro/widgets/iconbutton.dart';
import 'package:pomodoro/widgets/settings_dialog.dart';
import 'package:provider/provider.dart';

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
    super.initState();
    getPomodoros();
    dailyGoal = prefs.getInt("dailygoal") ?? 4;
  }

  void getPomodoros() {
    setState(() {
      pomodoros = prefs
              .getStringList("pomodoros")
              ?.map((p) => Pomodoro.fromJson(p))
              .toList() ??
          [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var size = MediaQuery.of(context).size;
        bool isLandscape = size.width > size.height;
        double maxWidth = isLandscape
            ? min(800, size.width * 0.9)
            : min(600, size.width * 0.9);
        double cardSize = max(min(120, size.width / (isLandscape ? 6 : 4)), 80);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Settings"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: pomodoros
                            .map(
                              (p) => InkWell(
                                onTap: () => showSettingDialog(p),
                                child: Card(
                                  child: Container(
                                    height: cardSize,
                                    width: cardSize,
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(p.name,
                                            style:
                                                const TextStyle(fontSize: 16)),
                                        Text('${p.period}',
                                            style:
                                                const TextStyle(fontSize: 20)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 30),
                      Text("Daily Pomodoro Goal",
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconButton(
                            callback: () async {
                              if (dailyGoal > 1) {
                                setState(() => dailyGoal--);
                                await prefs.setInt("dailygoal", dailyGoal);
                              }
                            },
                            iconSize: 24,
                            iconData: Icons.remove_rounded,
                            isDisabled: dailyGoal <= 1,
                          ),
                          Card(
                            child: Container(
                              width: cardSize,
                              height: cardSize,
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                child: Text('$dailyGoal',
                                    style: const TextStyle(fontSize: 24)),
                              ),
                            ),
                          ),
                          CustomIconButton(
                            callback: () async {
                              setState(() => dailyGoal++);
                              await prefs.setInt("dailygoal", dailyGoal);
                            },
                            iconData: Icons.add_rounded,
                            iconSize: 24,
                            isDisabled: false,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BlockPicker(
                          itemBuilder: (color, isCurrentColor, changeColor) {
                            return InkWell(
                              radius: 10,
                              onTap: changeColor,
                              child: Card(
                                color: color,
                                elevation: isCurrentColor ? 0 : 2,
                                child: isCurrentColor
                                    ? const Icon(Icons.check_rounded)
                                    : null,
                              ),
                            );
                          },
                          availableColors: [
                            const Color(0xFFCE93D8),
                            Colors.indigo.shade300,
                            const Color(0xFF90CAF9),
                            Colors.green.shade300,
                            const Color(0xFFE9CA6D),
                            Colors.orange.shade300,
                            const Color(0xFFEF9A9A),
                            Colors.grey.shade700,
                            const Color(0xFFA5D6A7),
                            const Color(0xFFF48FB1),
                            const Color(0xFFB39DDB),
                            const Color(0xFF80CBC4),
                          ],
                          pickerColor: Color(prefs.getInt("primary")!),
                          onColorChanged: (color) {
                            Provider.of<ThemeProvider>(context, listen: false)
                                .setBackgroundColor(color);
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).push(
                          CupertinoPageRoute(
                              builder: (context) => const OnBoarding()),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            "How to Use?",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showSettingDialog(Pomodoro pomodoro) {
    showDialog(
      context: context,
      builder: (context) => SettingsDialog(pomodoro: pomodoro),
    ).then((_) => getPomodoros());
  }
}
