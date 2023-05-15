import 'package:flutter/material.dart';

import '../../main.dart';
import '../../model/timer_model.dart';
import 'duration_dialog.dart';

class DurationWidget extends StatefulWidget {
  final int index;
  final double width;

  const DurationWidget({
    super.key,
    required this.index,
    required this.width,
  });

  @override
  State<DurationWidget> createState() => _DurationWidgetState();
}

class _DurationWidgetState extends State<DurationWidget> {
  late TimerModel timerModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    timerModel = timers[widget.index];
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        showDialog(
            context: context,
            builder: (_) {
              return DurationDialog(
                index: widget.index,
                width: widget.width,
              );
            }).then(
          (value) {
            // print(timers);
            setState(() {});
          },
        );
      },
      child: Container(
        width: isMobile ? widget.width / 5 : widget.width / 4,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(!isMobile ? 15 : 10),
            color: Colors.black12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${timerModel.minutes}',
              style: isMobile
                  ? Theme.of(context).textTheme.bodyLarge
                  : isTablet
                      ? Theme.of(context).textTheme.titleSmall
                      : Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              timerModel.name,
              style: isMobile
                  ? Theme.of(context).textTheme.bodyMedium
                  : isTablet
                      ? Theme.of(context).textTheme.bodySmall
                      : Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
