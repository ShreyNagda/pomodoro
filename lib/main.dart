import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/pages/homepage.dart';
import 'package:pomodoro/pages/onboarding.dart';
import 'package:pomodoro/utils/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

late List<String> stringPomodoros;
late SharedPreferences prefs;
bool isPhone = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();
  List<String> tempStringPomodoros = [];
  if (!prefs.containsKey("onboardong")) {
    prefs.setBool("onboarding", true);
  }
  if (!prefs.containsKey("pomodoros")) {
    for (var i in pomodoros) {
      tempStringPomodoros.add(i.toJson());
    }
    await prefs.setStringList("pomodoros", tempStringPomodoros);
  } else {
    tempStringPomodoros = prefs.getStringList("pomodoros")!;
  }
  stringPomodoros = tempStringPomodoros;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro | Shrey Nagda',
      theme: Theme.lightThemeData,
      home:
          prefs.getBool("onboarding")! ? const OnBoarding() : const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Theme {
  static ThemeData lightThemeData = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: primary,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      titleTextStyle: TextStyle(color: text, fontSize: 22),
    ),
    iconTheme: IconThemeData(color: text),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: text),
    ),
    textTheme: GoogleFonts.abelTextTheme().apply(
      bodyColor: text,
      displayColor: text,
    ),
  );
}
