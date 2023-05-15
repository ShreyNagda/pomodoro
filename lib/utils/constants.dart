import 'package:flutter/material.dart';

class Constants {
  static String timerKey = 'timers';
  static String breakKey = 'break';
  static String autoStartBreakKey = 'autoStartBreak';
  static String autoStartPomodoroKey = 'autoStartPomodoro';
  static String numberOfBreaksKey = 'numberOfBreaks';
  static String shortBreakKey = 'shortBreaksCompleted';
  static String dailyGoalKey = 'dailyGoal';
  static String pomodoroCompletedKey = 'pomodoroCompleted';
  static String wakeLockKey = 'wakeLock';
  static String firstTimeOpen = 'firstTime';

  static List<Color> colors =
      Colors.primaries.map((element) => element.shade200).toList();
  static Color primaryColor = colors.first;
}
