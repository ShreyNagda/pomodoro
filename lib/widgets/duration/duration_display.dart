import 'package:flutter/material.dart';

import '../../main.dart';
import '../duration/duration_widget.dart';
class DurationDisplay extends StatefulWidget {
  final double width;
  const DurationDisplay({super.key, required this.width});

  @override
  State<DurationDisplay> createState() => _DurationDisplayState();
}

class _DurationDisplayState extends State<DurationDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          timers.length,
          (index) => DurationWidget(index: index, width: widget.width),
        ),
      ),
    );
  }
}
