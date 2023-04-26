import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:resize/resize.dart';
import 'package:timer_controller/timer_controller.dart';

class CustomTimer extends StatefulWidget {
  final TimerController timerController;
  const CustomTimer({super.key, required this.timerController});

  @override
  State<CustomTimer> createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer> {
  late double width;
  late double spacer;
  late int maxvalue;
  late TimerController timerController;

  @override
  void initState() {
    timerController = widget.timerController;
    maxvalue = timerController.value.remaining;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (ResizeUtil().deviceType == DeviceType.Mobile) {
        width = constraints.maxWidth / 3;
        spacer = constraints.maxWidth / 50;
      } else if (ResizeUtil().deviceType == DeviceType.Windows ||
          ResizeUtil().deviceType == DeviceType.Linux) {
        if (constraints.maxWidth > constraints.maxHeight) {
          // print('height:${constraints.maxHeight}');
          width = constraints.maxHeight / 4;
          spacer = constraints.maxHeight / 100;
        } else {
          // print('width:${constraints.maxWidth}');
          width = constraints.maxWidth / 4;
          spacer = constraints.maxWidth / 100;
        }
        // print('width: $width');
        // print('spacer: $spacer');
      }
      return TimerControllerListener(
        controller: timerController,
        listener: (context, value) {},
        child: TimerControllerBuilder(
            controller: timerController,
            builder: (context, value, child) {
              return CircularPercentIndicator(
                  backgroundWidth: width,
                  animation: true,
                  animateFromLastPercent: true,
                  animationDuration: 800,
                  radius: width,
                  lineWidth: width,
                  progressColor: value.status == TimerStatus.paused
                      ? Colors.white24
                      : Colors.white,
                  percent: value.status == TimerStatus.initial
                      ? 0
                      : value.remaining / maxvalue,
                  backgroundColor: Colors.transparent,
                  center: value.status == TimerStatus.running
                      ? const SizedBox.shrink()
                      : Center(
                          child: value.status == TimerStatus.paused
                              ? Icon(
                                  Icons.pause_rounded,
                                  size: 5.rem,
                                )
                              : IconButton(
                                  iconSize: 5.rem,
                                  onPressed: () {
                                    timerController.start();
                                  },
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                  ),
                                ),
                        ));
            }),
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('Dispose');
  }
}
