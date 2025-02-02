import 'package:flutter/material.dart';
import 'package:timer_controller/timer_controller.dart';

class CustomIndicator extends StatefulWidget {
  final double radius;
  final double percent;
  final TimerController controller;
  final Widget? child;
  const CustomIndicator({
    super.key,
    required this.radius,
    required this.percent,
    required this.child,
    required this.controller,
  });

  @override
  State<CustomIndicator> createState() => _CustomIndicatorState();
}

class _CustomIndicatorState extends State<CustomIndicator>
    with SingleTickerProviderStateMixin {
  late double radius;
  late TimerController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    radius = widget.radius;
  }

  @override
  void didUpdateWidget(covariant CustomIndicator oldWidget) {
    setState(() {
      controller = widget.controller;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller.value.status == TimerStatus.initial ||
            controller.value.status == TimerStatus.paused) {
          controller.start();
        } else if (controller.value.status == TimerStatus.running) {
          controller.pause();
        } else {
          controller.start();
        }
      },
      onLongPress: () {
        if (controller.value.status == TimerStatus.paused ||
            controller.value.status == TimerStatus.finished) {
          controller.reset();
        }
      },
      child: Container(
        width: radius * 2,
        height: radius * 2,
        padding: EdgeInsets.all(0.5 * radius),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius * 2),
          border: Border.fromBorderSide(
            BorderSide(color: Colors.white, width: 0.07 * radius),
          ),
          // color: Colors.amber,
        ),
        child: SizedBox(
          width: radius * 2,
          height: radius * 2,
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              // AnimatedContainer(
              //   curve: Curves.easeInOut,
              //   duration: const Duration(milliseconds: 2000),
              //   child: CircularProgressIndicator(
              //     strokeWidth: radius * 0.9,
              //     value: controller.value.status == TimerStatus.initial ||
              //             controller.value.status == TimerStatus.finished
              //         ? 0
              //         : widget.percent,
              //     color: controller.value.status == TimerStatus.paused
              //         ? Colors.white24
              //         : Colors.white,
              //   ),
              // ),
              TweenAnimationBuilder(
                tween: Tween<double>(
                    begin: controller.value.remaining.toDouble(), end: 0),
                duration: const Duration(milliseconds: 1),
                curve: Curves.easeInOut,
                builder: (context, value, _) => CircularProgressIndicator(
                  strokeWidth: radius * 0.9,
                  value: controller.value.status == TimerStatus.initial ||
                          controller.value.status == TimerStatus.finished
                      ? 0
                      : widget.percent,
                  color: controller.value.status == TimerStatus.paused
                      ? Colors.white24
                      : Colors.white,
                ),
              ),
              if (controller.value.status != TimerStatus.running)
                Icon(
                  Icons.play_arrow_rounded,
                  size: 0.7 * radius,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
