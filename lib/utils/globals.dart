import 'package:pomodoro/utils/pomodoro.dart';

import 'package:flutter/material.dart';

Color primary = const Color.fromRGBO(255, 102, 122, 1);
Color text = Colors.white;

List<Pomodoro> pomodoros = [
  Pomodoro(name: "Pomodoro", period: 25, index: 0),
  Pomodoro(name: "Short Break", period: 5, index: 0),
  Pomodoro(name: "Long Break", period: 15, index: 0),
];
