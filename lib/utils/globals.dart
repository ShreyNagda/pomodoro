import 'package:pomodoro/utils/pomodoro.dart';

import 'package:flutter/material.dart';

Color primary = const Color(0xFFFE7A8B);
Color text = Colors.white;

List<Pomodoro> defaultPomodoros = [
  Pomodoro(name: "Pomodoro", period: 25),
  Pomodoro(name: "Short Break", period: 5),
  Pomodoro(name: "Long Break", period: 15),
];
