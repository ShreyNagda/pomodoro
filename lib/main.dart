// import 'dart:io';

// import 'package:dart_vlc/dart_vlc.dart';
import 'dart:io';

import 'package:dynamic_color_theme/dynamic_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/model/timer_model.dart';
import 'package:pomodoro/pages/splash_page.dart';
import 'package:pomodoro/utils/constants.dart';
import 'package:pomodoro/utils/notification_service.dart';
import 'package:resize/resize.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:window_manager/window_manager.dart';

late SharedPreferences prefs;
NotificationService service = NotificationService();
List<TimerModel> timers = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // DartVLC.initialize();
    await WindowManager.instance.setMinimumSize(const Size(600, 600));
  }
  if(Platform.isAndroid){
    await service.initialize();
  }
  prefs = await SharedPreferences.getInstance();
  await initializePrefs();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(const MyApp());
}

Future<void> initializePrefs() async {
  prefs.setInt(Constants.breakKey, 1);
  if (!prefs.containsKey(Constants.autoStartBreakKey)) {
    prefs.setBool(Constants.autoStartBreakKey, false);
  }
  if (!prefs.containsKey(Constants.autoStartPomodoroKey)) {
    prefs.setBool(Constants.autoStartPomodoroKey, false);
  }
  if (!prefs.containsKey(Constants.wakeLockKey)) {
    prefs.setBool(Constants.wakeLockKey, false);
  }
  if (prefs.getBool(Constants.wakeLockKey)!) {
    Wakelock.enable();
  } else {
    Wakelock.enable();
  }
  if (!prefs.containsKey(Constants.timerKey)) {
    timers = [
      TimerModel(
        name: "Pomodoro",
        minutes: 25,
      ),
      TimerModel(
        name: "Short Break",
        minutes: 5,
      ),
      TimerModel(
        name: "Long Break",
        minutes: 15,
      ),
    ];
    await prefs.setStringList(
        Constants.timerKey, timers.map((e) => e.toJson()).toList());
  } else {
    var data = prefs.getStringList(Constants.timerKey);
    data?.forEach((element) {
      timers.add(TimerModel.fromJson(element));
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Resize(
      allowtextScaling: true,
      builder: () {
        return DynamicColorTheme(
          data: (Color color, bool isDark) {
            return buildTheme(color, isDark);
          },
          themedWidgetBuilder: (BuildContext context, ThemeData data) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const SplashPage(),
              theme: data,
            );
          },
          defaultColor: Colors.primaries.first.shade300,
          defaultIsDark: false,
        );
      },
    );
  }

  ThemeData buildTheme(Color color, bool isDark) {
    ThemeData base = ThemeData.light();
    Color accentColor = Colors.white;
    return base.copyWith(
      primaryColor: color,
      textTheme: _buildTextTheme(base.textTheme, accentColor),
      scaffoldBackgroundColor: color,
      appBarTheme: const AppBarTheme(
          color: Colors.transparent, centerTitle: true, elevation: 0),
      floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
        backgroundColor: color,
      ),
      iconTheme: base.iconTheme.copyWith(
        color: accentColor,
        size: 2.rem,
        opticalSize: 2.rem,
      ),
    );
  }

  TextTheme _buildTextTheme(TextTheme base, Color color) {
    var fontFamily = GoogleFonts.robotoCondensed().fontFamily;
    return base.copyWith(
      bodyMedium: base.bodyMedium!.copyWith(
        fontSize: 0.9.rem,
        color: color,
        fontFamily: fontFamily,
      ),
      bodyLarge: base.bodyLarge!.copyWith(
        color: color,
        fontSize: 1.2.rem,
        fontFamily: fontFamily,
      ),
      bodySmall: base.bodySmall!.copyWith(
        color: color,
        fontSize: 0.6.rem,
        fontFamily: fontFamily,
      ),
      titleSmall: base.titleSmall!.copyWith(
        color: color,
        fontSize: 1.5.rem,
        fontFamily: fontFamily,
      ),
      titleMedium: base.titleMedium!.copyWith(
        color: color,
        fontSize: 1.8.rem,
        fontFamily: fontFamily,
      ),
      titleLarge: base.titleLarge!.copyWith(
        color: color,
        fontSize: 2.1.rem,
        letterSpacing: 5,
        fontFamily: fontFamily,
      ),
    );
  }
}
