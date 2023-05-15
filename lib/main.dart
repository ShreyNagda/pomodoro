import 'dart:async';
import 'dart:io';

import 'package:cron/cron.dart';
import 'package:dynamic_color_theme/dynamic_color_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kplayer/kplayer.dart';
import 'package:pomodoro/model/timer_model.dart';
import 'package:pomodoro/pages/home_page.dart';
import 'package:pomodoro/pages/on_boarding.dart';
import 'package:pomodoro/pages/settings_page.dart';
import 'package:pomodoro/utils/constants.dart';
import 'package:pomodoro/utils/notification_service.dart';
import 'package:resize/resize.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:window_manager/window_manager.dart';

late SharedPreferences prefs;
late bool isMobile;
late bool isTablet;
late bool isWindows;
late bool isWeb;
NotificationService service = NotificationService();
List<TimerModel> timers = [];
// late AudioPlayer audioPlayer;
late double width;
late double spacer;
late Cron cron;

Future<void> main() async {
  cron = Cron();

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  if (kIsWeb) {
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    WindowManager.instance.setMinimumSize(const Size(400, 400));
    Player.boot();
  } else if (Platform.isAndroid) {
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
  if (!prefs.containsKey(Constants.numberOfBreaksKey)) {
    prefs.setInt(Constants.numberOfBreaksKey, 4);
  }
  if (!prefs.containsKey(Constants.pomodoroCompletedKey)) {
    prefs.setInt(Constants.pomodoroCompletedKey, 0);
  }

  cron.schedule(Schedule.parse("* 0 * * *"), () {
    print(DateTime.now());
    prefs.setInt(Constants.pomodoroCompletedKey, 0);
    // print(prefs.getInt(Constants.pomodoroCompletedKey));
  });

  if (!prefs.containsKey(Constants.dailyGoalKey)) {
    prefs.setInt(Constants.dailyGoalKey, 8);
  }
  if (!kIsWeb && Platform.isAndroid) {
    if (!prefs.containsKey(Constants.wakeLockKey)) {
      prefs.setBool(Constants.wakeLockKey, false);
    }
    if (prefs.getBool(Constants.wakeLockKey)!) {
      Wakelock.enable();
    } else {
      Wakelock.enable();
    }
  }
  if (!prefs.containsKey(Constants.firstTimeOpen)) {
    prefs.setBool(Constants.firstTimeOpen, true);
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

  // @override
  @override
  Widget build(BuildContext context) {
    return Resize(
      allowtextScaling: true,
      builder: () {
        isMobile = ResizeUtil().deviceType == DeviceType.Mobile;
        isTablet = ResizeUtil().deviceType == DeviceType.Tablet;
        isWindows = ResizeUtil().deviceType == DeviceType.Windows;
        isWeb = ResizeUtil().deviceType == DeviceType.Web;
        print(isTablet);
        return DynamicColorTheme(
          data: (Color color, bool isDark) {
            return buildTheme(color, isDark);
          },
          themedWidgetBuilder: (BuildContext context, ThemeData data) {
            // print(Colors.primaries.first.shade300.toString());
            return LayoutBuilder(builder: (context, constraints) {
              width = constraints.maxWidth;
              spacer = width / 10;
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: prefs.getBool(Constants.firstTimeOpen)!
                    ? const OnBoardingScreen()
                    : const HomePage(),
                theme: data,
                routes: {
                  "/home": (context) => const HomePage(),
                  "/settings": (context) => const SettingsPage(),
                  "/onboarding": (context) => const OnBoardingScreen()
                },
              );
            });
          },
          defaultColor: Constants.colors.first,
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
      floatingActionButtonTheme:
          base.floatingActionButtonTheme.copyWith(backgroundColor: color),
      iconTheme: base.iconTheme.copyWith(
          color: accentColor,
          size: isMobile
              ? 20.sp
              : isTablet
                  ? 18.sp
                  : 10.sp
          // opticalSize: 2.rem,
          ),
    );
  }

  TextTheme _buildTextTheme(TextTheme base, Color color) {
    var fontFamily = GoogleFonts.robotoCondensed().fontFamily;
    return base.copyWith(
      bodyMedium: base.bodyMedium!.copyWith(
        fontSize: 12.sp,
        color: color,
        fontFamily: fontFamily,
        overflow: TextOverflow.ellipsis,
      ),
      bodyLarge: base.bodyLarge!.copyWith(
        color: color,
        fontSize: 15.sp,
        fontFamily: fontFamily,
        overflow: TextOverflow.ellipsis,
      ),
      bodySmall: base.bodySmall!.copyWith(
        color: color,
        fontSize: 09.sp,
        fontFamily: fontFamily,
        overflow: TextOverflow.ellipsis,
      ),
      titleSmall: base.titleSmall!.copyWith(
        color: color,
        fontSize: 20.sp,
        fontFamily: fontFamily,
        overflow: TextOverflow.ellipsis,
      ),
      titleMedium: base.titleMedium!.copyWith(
        color: color,
        fontSize: 24.sp,
        fontFamily: fontFamily,
        overflow: TextOverflow.ellipsis,
      ),
      titleLarge: base.titleLarge!.copyWith(
        color: color,
        fontSize: 28.sp,
        letterSpacing: 5,
        fontFamily: fontFamily,
        overflow: TextOverflow.ellipsis,
      ),
      labelSmall: base.labelSmall!.copyWith(color: color, fontSize: 15.sp),
      labelMedium: base.labelMedium!.copyWith(color: color, fontSize: 10.sp),
      labelLarge: base.labelLarge!.copyWith(color: color, fontSize: 5.sp),
    );
  }
}
