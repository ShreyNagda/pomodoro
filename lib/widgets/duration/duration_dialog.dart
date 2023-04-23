import 'package:flutter/material.dart';
// import 'package:pomodoro_timer/model/timer_model.dart';

import '../../main.dart';
import '../../model/timer_model.dart';
import '../../utils/constants.dart';

class DurationDialog extends StatefulWidget {
  final int index;
  final double width;
  const DurationDialog({super.key, required this.index, required this.width});

  @override
  State<DurationDialog> createState() => _DurationDialogState();
}

class _DurationDialogState extends State<DurationDialog> {
  late TimerModel timerModel;
  late int _value;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timerModel = timers[widget.index];
    _value = timerModel.minutes;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: widget.width,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        int newValue = _value - 1;
                        _value = newValue.clamp(0, 60);
                      });
                    },
                    icon: const Icon(Icons.remove)),
                Text(
                  '$_value',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      int newValue = _value + 1;
                      _value = newValue.clamp(0, 60);
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          SizedBox(height: widget.width / 50,),
          IconButton(
            onPressed: () {
              TimerModel newTimerModel =
                  TimerModel(name: timerModel.name, minutes: _value);
              timers.removeAt(widget.index);
              timers.insert(widget.index, newTimerModel);
              prefs.setStringList(
                Constants.timerKey,
                timers.map((e) => e.toJson()).toList(),
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
    );
  }
}
