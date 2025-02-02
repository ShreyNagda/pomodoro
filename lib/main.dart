import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/pages/homepage.dart';
import 'package:pomodoro/pages/onboarding.dart';
import 'package:pomodoro/utils/globals.dart';
import 'package:pomodoro/utils/pomodoro.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late List<Pomodoro> pomodoros;
late SharedPreferences prefs;
bool isPhone = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey("onboarding")) {
    prefs.setBool("onboarding", true);
  }
  if (!prefs.containsKey("refreshtime")) {
    prefs.setInt("refreshtime", DateTime.now().weekday);
  }
  if (!prefs.containsKey("dailygoal")) {
    prefs.setInt("dailygoal", 8);
  }
  if (!prefs.containsKey("dailycomplete")) {
    prefs.setInt("dailycomplete", 0);
  }

  if (!prefs.containsKey("primary")) {
    prefs.setInt("primary", 0xFFEF9A9A);
  }

  if (prefs.getInt("refreshtime")! < DateTime.now().weekday ||
      (prefs.getInt("refreshtime")! == 7 && DateTime.now().weekday == 1)) {
    prefs.setInt("dailycomplete", 0);
    prefs.setInt("refreshtime", DateTime.now().weekday);
  }
  await getPomodoros();
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

Future<void> getPomodoros() async {
  if (prefs.containsKey("pomodoros")) {
    pomodoros = prefs
        .getStringList("pomodoros")!
        .map((p) => Pomodoro.fromJson(p))
        .toList();
  } else {
    pomodoros = defaultPomodoros;
    prefs.setStringList("pomodoros", pomodoros.map((p) => p.toJson()).toList());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro | Shrey Nagda',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home:
          prefs.getBool("onboarding")! ? const OnBoarding() : const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  Color _backgroundColor = Colors.red.shade200;

  ThemeProvider() {
    _loadTheme();
  }

  Color get backgroundColor => _backgroundColor;

  ThemeData get themeData => ThemeData(
      primaryColor: _backgroundColor,
      scaffoldBackgroundColor: _backgroundColor,
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
      cardTheme: const CardTheme(color: Colors.white24));
  void _loadTheme() {
    _backgroundColor = Color(prefs.getInt("primary") ?? 0xFFFE7A8B);
    notifyListeners();
  }

  void setBackgroundColor(Color color) async {
    _backgroundColor = color;
    await prefs.setInt("primary", color.value);
    notifyListeners();
  }
}
