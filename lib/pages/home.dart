import 'package:dynamic_color_theme/dynamic_color_theme.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicColorTheme.of(context).color,
      body: Column(
        children: const [
          // CustomTimer(timerController: )
        ],
      ),
    );
  }
}